#!/usr/bin/env bash

# Don't exit immediately on error for better error handling
set +e

# Verify YAML files exist
for env_file in /pkgs/env1.yml /pkgs/starsolo_env.yml; do
    if [ ! -f "$env_file" ]; then
        echo "Error: Environment file $env_file not found!"
        exit 1
    else
        echo "Found environment file: $env_file"
    fi
done

# Add conda to path (should already be in PATH from base image)
export PATH="/opt/conda/bin:$PATH"

# Install basic packages in base environment
echo "Installing basic packages in base environment..."
conda install -y -c conda-forge jupyterlab notebook ipykernel

# Install radian in the base environment
echo "Installing radian in base environment..."
pip install -U radian

# Create environments from YAML files
echo "Creating conda environments..."
for env_file in /pkgs/env1.yml /pkgs/starsolo_env.yml; do
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

# Configure the Scanpy kernel if it exists
if [ -d "/opt/conda/envs/env_scanpy" ]; then
    echo "Configuring kernel for env_scanpy as 'Python (Scanpy)'..."
    /opt/conda/envs/env_scanpy/bin/python -m ipykernel install --user --name=env_scanpy --display-name="Python (Scanpy)"
else
    echo "Warning: Environment env_scanpy not found, skipping kernel configuration."
fi

# Configure the STARsolo kernel if it exists
if [ -d "/opt/conda/envs/env_STARsolo" ]; then
    echo "Configuring kernel for env_STARsolo as 'Python (STARsolo)'..."
    /opt/conda/envs/env_STARsolo/bin/python -m ipykernel install --user --name=env_STARsolo --display-name="Python (STARsolo)"
    
    # Add alias for STARsolo
    echo "alias starsolo='conda run -n env_STARsolo STAR'" >> ~/.bashrc
else
    echo "Warning: Environment env_STARsolo not found, skipping kernel configuration."
fi

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

# Clean conda cache to reduce image size
echo "Cleaning up..."
conda clean --all -f -y

echo "JupyterLab installation complete!"
exit 0 