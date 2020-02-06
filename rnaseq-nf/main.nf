/*
 * Copyright 2020 Centre for Genomic Regulation (CRG)
 * Copyright 2020 BovReg
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */ 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 *
 * Authors:
 * - Jose Espinosa-Carrasco <espinosacarrascoj@gmail.com>
 */

/*
 * Default pipeline parameters. They can be overridden on the command line eg.
 * given `params.foo` specify on the run command line `--foo some_value`.
 */

params.reads = "$baseDir/data/ggal/ggal_gut_{1,2}.fq"
params.transcriptome = "$baseDir/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa"
params.outdir = "results"
params.multiqc = "$baseDir/multiqc"

log.info """\
 R N A S E Q - N F   P I P E L I N E
 ===================================
 transcriptome: ${params.transcriptome}
 reads        : ${params.reads}
 outdir       : ${params.outdir}
 """

transcriptome_file = file(params.transcriptome)
multiqc_file = file(params.multiqc)

Channel
    .fromFilePairs( params.reads, checkExists:true )
    .set { read_pairs_ch }

/*
 * Rename files from "ggal" (*Gallus gallus*) to "chicken" (Bash script)
 */
process rename_file {
    label "salmon"
    tag "$pair_id"

    input:
    set pair_id, file(reads) from read_pairs_ch

    output:
    set val('chicken_gut'), file('*.fq') into read_pairs_chicken, read_pairs2_chicken

    script:
    """
    rename_files.sh
    """
}

/*
 * Index transcriptome with Salmon
 */
process index {
    label "salmon"
    tag "$transcriptome.simpleName"

    input:
    file transcriptome from transcriptome_file

    output:
    file 'index' into index_ch

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """
}

/*
 * Quantifies transcripts, Maps RNA-seq reads (Salmon)
 */
process quant {
    label "salmon"
    tag "$pair_id"
    publishDir params.outdir + "_salmon", pattern: "$pair_id/*.sf", saveAs: { filename -> 'quant.sf' }

    input:
    file index from index_ch
    set pair_id, file(reads) from read_pairs_chicken

    output:
    file(pair_id) into quant_ch
    file ("$pair_id/*.sf") into result_to_check

    script:
    """
    salmon quant --threads $task.cpus --libType=U -i $index -1 ${reads[0]} -2 ${reads[1]} -o $pair_id
    """
}

/*
 * Quality of RNA-seq data (FastQC)
 */
process fastqc {
    tag "FASTQC on $sample_id"
    publishDir params.outdir + "_fastqc"

    input:
    set sample_id, file(reads) from read_pairs2_chicken

    output:
    file("fastqc_${sample_id}_logs") into fastqc_ch


    script:
    """
    mkdir fastqc_${sample_id}_logs
    fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads}
    """
}

/*
 * Creates html report of Salmon and FastQC runs using multiQC
 */
process multiqc {
    publishDir params.outdir + "_multiqc", mode:'copy'
    
    input:
    file('data*/*') from quant_ch.mix(fastqc_ch).collect()
    file(config) from multiqc_file

    output:
    file('multiqc_report.html') optional true

    script:
    """
    cp $config/* .
    echo "custom_logo: \$PWD/logo.png" >> multiqc_config.yaml
    multiqc -v .
    """
}

/*
 * Prints message when worflow is succesfully complete
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir" + "_multiqc/multiqc_report.html\n" : "Oops .. something went wrong" )
}
