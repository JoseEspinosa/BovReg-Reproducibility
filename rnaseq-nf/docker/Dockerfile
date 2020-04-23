FROM continuumio/miniconda:4.7.12

LABEL maintainer="Jose Espinosa-Carrasco <espinosacarrascoj@gmail.com>" \
      description="Docker image containing software requirements for rnaseq-nf demo"

COPY conda.yml .

RUN conda env update -n root -f conda.yml && \
    conda clean -afy