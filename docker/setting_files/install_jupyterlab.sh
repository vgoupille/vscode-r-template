#!/usr/bin/env bash

# Don't exit immediately on error for better error handling
set +e

# Detect architecture
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
else
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
fi

echo "Detected architecture: $ARCH, using Miniconda URL: $MINICONDA_URL"

# Verify YAML files exist
for env_file in /pkgs/env1.yml /pkgs/env2.yml /pkgs/env3.yml; do
    if [ ! -f "$env_file" ]; then
        echo "Error: Environment file $env_file not found!"
        exit 1
    else
        echo "Found environment file: $env_file"
    fi
done

# Install Miniconda
cd /tmp
echo "Downloading Miniconda..."
wget -q $MINICONDA_URL -O miniconda.sh
echo "Installing Miniconda..."
bash miniconda.sh -b -p /opt/conda
rm miniconda.sh

# Add conda to path
export PATH="/opt/conda/bin:$PATH"
echo 'export PATH="/opt/conda/bin:$PATH"' >> ~/.bashrc
echo 'export PATH="/opt/conda/bin:$PATH"' >> ~/.profile

# Initialize conda
echo "Initializing conda..."
conda init bash
conda init zsh

# Install basic packages in base environment
echo "Installing basic packages in base environment..."
conda install -y -c conda-forge jupyterlab notebook ipykernel

# Install radian in the base environment
echo "Installing radian in base environment..."
pip install -U radian

# Create environments from YAML files
echo "Creating conda environments..."
for env_file in /pkgs/env1.yml /pkgs/env2.yml /pkgs/env3.yml; do
    env_name=$(grep "name:" $env_file | head -1 | cut -d ":" -f2 | tr -d ' ')
    echo "Creating environment $env_name from $env_file..."
    
    # Try to create the environment
    conda env create -f $env_file
    
    # Check if environment creation was successful
    if [ $? -ne 0 ]; then
        echo "Warning: Failed to create environment from $env_file with all dependencies."
        echo "Creating a minimal environment and continuing..."
        
        # Create a minimal environment with the same name
        conda create -y -n $env_name python=3.10 ipykernel
    fi
done

# Install R kernel for Jupyter
echo "Installing R kernel for Jupyter..."
Rscript -e 'install.packages("IRkernel", repos="https://cran.rstudio.com/")'
Rscript -e 'IRkernel::installspec(name = "R", displayname = "R")'

# Configure the kernels for all environments
echo "Configuring kernels for all environments..."
python -m ipykernel install --user --name=base --display-name="Python (base)"

# Configure kernels for each environment if they exist
for env_name in env1 env2 env3; do
    if [ -d "/opt/conda/envs/$env_name" ]; then
        env_display_name="Python"
        case $env_name in
            "env1") env_display_name="Python (Data Science)" ;;
            "env2") env_display_name="Python (Bioinformatics)" ;;
            "env3") env_display_name="Python (Machine Learning)" ;;
        esac
        
        echo "Configuring kernel for $env_name as '$env_display_name'..."
        /opt/conda/envs/$env_name/bin/python -m ipykernel install --user --name=$env_name --display-name="$env_display_name"
    else
        echo "Warning: Environment $env_name not found, skipping kernel configuration."
    fi
done

# Create a directory for JupyterLab config
echo "Configuring JupyterLab..."
mkdir -p /root/.jupyter

# Create a password for JupyterLab (empty password)
jupyter notebook --generate-config
echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = ''" >> /root/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py

# Create aliases for JupyterLab
echo "alias jupyterlab='jupyter lab --no-browser --ip=0.0.0.0 --allow-root'" >> ~/.bashrc

# Make sure radian is in the PATH
echo 'export PATH="/opt/conda/bin:$PATH"' >> ~/.bashrc
echo "alias r='radian'" >> ~/.bashrc

# Clean conda cache to reduce image size
echo "Cleaning up..."
conda clean --all -f -y

echo "JupyterLab installation complete!"
exit 0 