# BovReg Reproducibility

## Table of contents

* [Introduction](#Introduction)
* [Workflow details to be recorded](#Workflow-details-to-be-recorded)
    * [1 - Software](#sw)
        * [a - Third-party software](#thirdPartySoftware)
            * [i - Docker](#docker)
            * [ii - Singularity](#singularity)
            * [iii - Conda environment](#conda)
        * [b - Custom scripts](#scripts)    
    * [2 - Workflow](#workflow)
    * [3 - Data](#data)
        * [a - Test input data set](#input_data)
        * [b - Test output result](#output_data)
    * [4 - An integral solution: Workflow managers](#workflow_managers)
* [Template notebooks](#Template-notebooks)
    * [1 - Pipeline](#1---Pipeline)
    * [2 - Template jupyter notebooks](#2---Template-jupyter-notebooks)
    * [3 - How to run the notebooks](#3---how-to-run-the-notebooks)

## Introduction

This repository aims to be a guide for the development of reproducible BovReg bioinformatic analyses. Since WP3 standard 
pipelines will be built on top of the analyses previously performed by the other WPs, the aim of these guidelines is to 
provide a set of minimum good practices to enable that the results obtained by our partners can be reproduced by the 
standard pipelines. To this end, we discuss which are the details we need that you share with us from your 
computational analyses. To ease this procedure, we created a series of templates using [Jupyter](http://jupyter.org/)
notebooks. These templates illustrate the different approaches you can use to share with us your bioinformatics analyses.

> **_Note:_**  The templates run an RNA-seq toy pipeline inspired by the 
[rnaseq-nf](https://github.com/nextflow-io/rnaseq-nf) demo using [Salmon](https://combine-lab.github.io/salmon/) to 
quantify RNA-seq transcripts. In addition, the pipeline runs 
FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) and 
[MultiQC](https://multiqc.info/) to obtain quality measures.

## Workflow details to be recorded: 

In the following sections we will summarize which information should be recorded, so that the results yielded by your 
analysis reproducible (and test that our standard pipelines are working as expected). In each section, we provide 
several possible solutions and at the end we discuss how a workflow manager can be an integral solution to share your
pipelines with WP3.

### <a name="sw"></a> 1. Software

Most of the times, to reproduce a computational result it is necessary to run exactly the same versions of the software 
originally used. For this reason, it is convenient to track any piece of software that has been run by your workflow and 
this involve both third-party software and your own custom scripts, and the exact launched commands.       

#### <a name="thirdPartySoftware"></a> 1.a. Third-party software

With the term "third-party software", we refer to all the tools that are used in a bioinformatic analysis and
that are develop by a different organization other than the original development group of the workflow. To trace the 
versions of the programs used in your analyses, we recommend using an environment management system such as 
[Conda](https://docs.conda.io/projects/conda/en/latest/) or a containerization software such as 
[Docker](http://www.docker.com) or [Singularity](http://singularity.lbl.gov/). Any of these solutions can 
be used to sandbox software tools along with its dependencies, thus, enabling anyone to reproduce your results by 
running exactly the workflow in the same computational environment. Although you can create your 
own containers, an additional advantage of this approach is that many bioinformatic tools are already available as 
pre-build containers in public repositories. You can download ready-to-run containers from the 
[Biocontainers](https://biocontainers-edu.biocontainers.pro/en/latest/index.html) project. These community releases 
containers for bioinformatics tools in the three above-mentioned flavours (Conda, Docker and Singularity).

> **_Note:_**  If you don't want to use any of the proposed solutions, as a minimum requirement you should note the 
name and the versions of the programs used in your workflow to allow us reproduce your results. 

##### <a name="docker"></a> 1.a.i. Docker

In our template, all the software that is needed to run the pipeline can be found as a [Docker](http://www.docker.com) 
image on DockerHub [here](https://hub.docker.com/r/cbcrg/bovreg-demo/). To generate a Docker image all the instructions 
must be structured in a Dockerfile as explained 
[here](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/). Our image has been created using 
this [Dockerfile](https://github.com/nextflow-io/rnaseq-nf/docker/Dockerfile). 

> **_Note:_** We also provide an example of how to use biocontainers to run the pipeline using nextflow. See the 
[biocontainers profile](https://github.com/BovReg/BovReg-Reproducibility/blob/174ac547a2cb34ba40eb194bfaa715fc23e23735/rnaseq-nf/nextflow.config#L38-L57) 
inside the `nextflow.config` file to explore this option.

##### <a name="singularity"></a> 1.a.ii. Singularity

Unlike Docker, Singularity can be run without root privileges, a key feature that makes it a more suitable container 
engine in shared HPC environments. The good news is that Docker containers can be run with Singularity (see 
[here](https://sylabs.io/guides/3.5/user-guide/singularity_and_docker.html) for more information). The Docker image on 
our example has been tested to be compatible with Singularity. 

##### <a name="conda"></a> 1.a.iii. Conda environment

We also sandboxed the software used in our template in a 
[YML file](https://github.com/nextflow-io/rnaseq-nf/conda.yml). This file can be used to 
[generate the Conda environment](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html#creating-an-environment-from-an-environment-yml-file) 
to run our example pipeline.  

#### <a name="scripts"></a> 1.b. Custom scripts

It will convenient that you share any custom script that you have used on your workflow with us. To reproduce your 
results, we will need the exact version of the script that you ran. If you keep your scripts in a version control 
system (such as GitHub, GitLab or other similar solutions), please point us to the state of the code that generate your
results. In our demo, we include a first step of the workflow, performed by 
[this bash script](https://github.com/BovReg/BovReg-Reproducibility/rnaseq-nf/bin/rename_file.sh), that renames the 
input file to showcase how custom scripts can be shared. 

### <a name="workflow"></a> 2. Workflow

When performing a bioinformatic analysis a series of interrelated steps are orchestrated to obtain a final result 
starting from the input raw data. Such a sequential set of steps is known as an analysis workflow. To reproduce the 
results yielded by an analysis workflow it is important to keep track of your workflow steps. Importantly, to reach the 
same computational output is not only enough to record the main tools executed in a workflow but also keep track of the 
parameters used for its execution, single commands, ad-hoc script or intermediary formatting step performed. That is why
this template showcases how to record all the commands used in your analysis using a [Jupyter](http://jupyter.org/) 
notebook.

### <a name="data"></a> 3. Data

To test that the implementation of the pipeline can reproduce your results it is important that you share with us a 
small sample dataset and the results you expect to generate when you run your analysis.

#### <a name="input_data"></a> 3.a. Test input data set

The idea is that once we develop the standard pipeline, we can use a minimal dataset to assure that we actually are 
reproducing the same results that you get from your original analysis. In our example, the sample dataset comes along 
with the code in the GitHub [repository](https://github.com/BovReg/BovReg-Reproducibility/rnaseq-nf/data/ggal). Note 
that to reduce the size of your sample dataset you can provide part of a chromosome as a reference and subsampled input 
data.

#### <a name="output_data"></a> 3.b. Test output result

To check that the pipeline is actually working correctly we will need that you share with us the expected results of 
your analysis when the workflow is run using the sample data using a given set of parameters.

### <a name="workflow_managers"></a> 4. Workflow managers: An integral solution

Workflow managers simplify the way to share a reproducible workflow.  We deployed our demo rna-seq pipeline using 
a popular workflow manager, nextflow, to display how the above discussed points can be done:

**1.** Software: In the config file you can determine to use a 
[container](https://github.com/BovReg/BovReg-Reproducibility/blob/174ac547a2cb34ba40eb194bfaa715fc23e23735/rnaseq-nf/nextflow.config#L31-L36) 
or a [Conda environment](https://github.com/BovReg/BovReg-Reproducibility/blob/174ac547a2cb34ba40eb194bfaa715fc23e23735/rnaseq-nf/nextflow.config#L59-L61) 
to run your pipeline. In the latter case, you can see how the `yml` file is also provided with the pipeline, this way by
using the Conda profile the environment will be created. Also, your custom scripts can be easily distributed with your
pipeline since nextflow will include any script found in the bin directory into the `PATH` environmental variable   
and in this way, they can be called by any of your processes without the need of referencing the full path as shown in this toy  
[example](https://github.com/BovReg/BovReg-Reproducibility/blob/50b8e2da6118e861e86fa499af7357254b8eb68a/rnaseq-nf/main.nf#L60-L74) 
that renames input files. 

**2.** Workflow: Since workflow management systems are designed to automatically run a series of computational steps, this 
is probably the most obvious aspect that workflow managers address. In the case of nextflow, the specific command used
in a given step is defined by the `script` block as for example the 
[command](https://github.com/BovReg/BovReg-Reproducibility/blob/50b8e2da6118e861e86fa499af7357254b8eb68a/rnaseq-nf/main.nf#L107) 
used to create the index with Salmon.  

**3.a.** Test input data set: We include a small input dataset in the Github repository that allows for the testing of the 
workflow analysis. For this purpose, we used as a reference only a part of the chicken chromosome 1 and subsampled the 
`fastq` files accordingly. 

**3.b.** Test output result: The expected output of Salmon quantification (given the test input data set) can also be 
found in the [repository](https://github.com/nextflow-io/rnaseq-nf/data/result_sample). When the pipeline is run the 
corresponding file will be generated inside `results/quant.sf`.

## Template notebooks

### 1 - Pipeline

The templates run an RNA-seq toy pipeline inspired by the [rnaseq-nf](https://github.com/nextflow-io/rnaseq-nf) demo 
using [Salmon](https://combine-lab.github.io/salmon/) and includes the following steps:

* Rename files from "ggal" (*Gallus gallus*) to "chicken" (Bash script) 

* Index transcriptome (Salmon)

* Quantifies transcripts, Maps RNA-seq reads (Salmon)

* Quality of RNA-seq data (FastQC)

* Creates HTML report of Salmon and FastQC runs using multiQC

### 2 - Template jupyter notebooks

We included several notebooks being each of them an example of the different approaches discussed. Choose the notebook 
that fits better with your preferences and use it as a template to share your workflow. Note that any of the notebooks
produce the same results:

* [Execution using Bash](notebook/01_naive_execution.ipynb).

* [Execution using nextflow and Docker](notebook/02_nxf_execution_docker.ipynb).

* [Execution using nextflow and Conda](notebook/03_nxf_execution_conda.ipynb).

### 3 - How to run the notebooks

If you don't have Jupyter installed, first follow [this](https://jupyter.org/install) instructions. Once Jupyter is 
installed, place yourself on the main repository folder and launch jupyter:

```bash
cd /your_path/BovReg-Reproducibility/notebook
jupyter notebook
```

From there, you can choose which file you want to explore and/or run. The idea is that you adapt one of this template to
enclose your analysis so that it allow us to reproduce your results.
   
## Funding

BovReg project has received funding from the European Union’s Horizon 2020 research and innovation program under Grant 
Agreement ID. [815668](https://cordis.europa.eu/project/id/815668).
