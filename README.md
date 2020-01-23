# BovReg Reproducibility

This template aims to be a guide for the development of reproducible BovReg bioinformatics analyses. Since WP3 standard pipelines will be built on top of the analyses previously performed by other packages, the aim of these guidelines is to provide a set of minimum good practices to enable that the results obtained by our partners can be reproduced by the standard pipelines. To this end, we created a template using [Jupyter](http://jupyter.org/) notebooks that you can adapt to share your own pipelines.

The template runs an RNA-seq toy pipeline inspired by the [rnaseq-nf](https://github.com/nextflow-io/rnaseq-nf) demo pipeline using [Salmon](https://combine-lab.github.io/salmon/) and includes the following steps:

1- Index transcriptome (Salmon)

2- Quantifies transcripts, Maps RNA-seq reads (Salmon)

3- Quality of RNA-seq data (FastQC)

4- Generates HTML report with quality stats from FastQC and Salmon (MultiQC)

[Link text](#some-id)


## Introduction 

To reproduce the results yielded by your analysis (and test that our standard pipelines are working as expected) we will need that you record the following details:

1. [Workflow](#workflow)

2. [Software](#sw)

    a. [External programs](#ext_pr)

    1. [Docker containers](#docker)

    2. [Conda environment](#conda)

    b. [Custom scripts](#scripts)

3. [Data](#data)

    a. [Test input data set](#input_data)

    b. [Test output result](#output_data)

## <a name="workflow"></a> 1. Workflow

When performing a bioinformatic analysis a series of interrelated steps are orchestrated to obtain a final result starting from the input raw data. Such a sequential set of steps is known as an analysis workflow. To reproduce the results yielded by an analysis workflow it is important to keep track of your workflow steps. Importantly, to reach the same computational output is not only enough to record the main tools executed in a workflow but also keep track of the parameters used for its execution, single commands, ad-hoc script or intermediary formatting step performed. That is why this template showcases how to record all the commands used in your analysis using a [Jupyter](http://jupyter.org/) notebook. 

## <a name="sw"></a> 2. Software

### <a name="ext_pr"></a> 2.a External programs

To trace the versions of the programs used in your analyses, we recommend using an environment management system such as Conda or a containerization software such as Docker or Singularity. Any of these solutions can be used to sandbox software tools along with its dependencies, thus, enabling anyone to reproduce your results by running exactly the same computational environment. Although you can create your own containers, an additional advantage of this approach is that many bioinformatic tools are already available as pre-build containers in public repositories. You can download ready-to-run containers from the Biocontainers project. This community releases containers for bioinformatics tools in the three above-mentioned flavours (Conda, Docker and Singularity). 

All the software that is needed to run the demo pipeline can be found as a docker container or as a conda environment

Since we know that not all of you are using workflow managers, although we strongly advise to use them, we implemented two notebooks one which shows how to naively run the workflow and a second one that is run using Nextflow as workflow manager.

#### <a name="docker"></a> 2.a.1 Docker container

All the software tools used on the pipeline are available in a [Docker](http://www.docker.com) image on DockerHub [here](https://hub.docker.com/r/cbcrg/regressive-msa/) and the image is tested to be compatible with the [Singularity](http://singularity.lbl.gov/). You can follow this Dockerfile to create your container 


#### <a name="conda"></a> 2.a.2 Conda environment

### <a name="scripts"></a> 2.b Custom scripts

## <a name="data"></a> 2 Data

### <a name="input_data"></a> 2.a Test input data set

### <a name="input_data"></a> 2.b Test output result

## Notebooks


## Pipeline


## How to use this template

Using nextflow, docker and bla, bla

Naive execution











 nextflow demo that performs 
A basic pipeline for quantification of genomic features from short read data implemented with Nextflow.