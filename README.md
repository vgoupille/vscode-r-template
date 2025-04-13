# A VScode Template for Dockerized R Environment

This Github repository provides a template for a dockerized R development environment with VScode and the Dev Containers extension. It contains the following folders and files:



```shell
.
├── README.md
├── .devcontainer
│   └── devcontainer.json
├── .vscode
│   └── settings.json
├── docker
│   ├── Dockerfile
│   ├── build_docker.sh
│   ├── devcontainer.json
│   ├── install_packages.R
│   ├── install_quarto.sh
│   ├── packages.json
│   └── requirements.txt
└── tests
    ├── app.R
    ├── htmlwidgets.R
    └── plot.R

```

It includes the following folders and files:
- `.devcontainer` - defines the dockerized environment settings with the `devcontainer.json` file
- `.vscode` - enables the modification of the VScode general settings for the dockerized environment with the `settings.json` file
- `docker` - contains the template image settings
- `tests` - R scripts for testing the environment functionality (e.g., Shiny app, static and interactive plots, etc.)

The template default image in the template is `rkrispin/vscode_r_dev:0.1.0`, which comes with R version `4.3.1` and core packages (e.g., `dplyr`, `shiny`, `ggplot2`, `plotly`, etc.). 

## JupyterLab with Multiple Conda Environments

This template now includes a JupyterLab environment with multiple conda environments and R kernel integration:

### Features
- JupyterLab with support for multiple Python kernels and R
- 3 pre-configured conda environments:
  - **env1**: Data Science packages (pandas, numpy, matplotlib, scikit-learn, etc.)
  - **env2**: Bioinformatics packages (biopython, scanpy, anndata, samtools, etc.)
  - **env3**: Machine Learning packages (tensorflow, pytorch, xgboost, etc.)
- R kernel integrated with JupyterLab

### Usage

1. Build the JupyterLab image:
```bash
./docker/build_jupyter.sh
```

2. Run the JupyterLab container:
```bash
./docker/run-jupyter.sh
```

3. Access JupyterLab in your browser:
```
http://localhost:8889
```

4. Select your desired kernel (Python environment or R) when creating a new notebook.

### Environment YML Files

The conda environments are defined in the following YAML files:
- `docker/setting_files/env1.yml` - Data Science environment
- `docker/setting_files/env2.yml` - Bioinformatics environment 
- `docker/setting_files/env3.yml` - Machine Learning environment

You can customize these files to include additional packages as needed.
