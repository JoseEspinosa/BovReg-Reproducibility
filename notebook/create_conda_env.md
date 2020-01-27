1. If you don't have conda installed in your system follow the instructions [here](https://docs.conda.io/projects/conda/en/latest/user-guide/install/)

2. Create the environment from the repository `yml` file.

```bash
cd /your_path/BovReg-Reproducibility/rnaseq-nf
conda env create -f conda.yml

```

3. Once the environment is created activate it

```bash
conda activate rnaseq-nf
```

4. Run the jupyter notebook after activating the environment

```bash
jupyter notebook
```