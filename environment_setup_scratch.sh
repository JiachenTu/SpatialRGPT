#!/usr/bin/env bash

# Modified environment setup script that uses scratch space for conda environment
# This avoids running out of space in the home directory

# This is required to activate conda environment
eval "$(conda shell.bash hook)"

# Use scratch space for conda environment
CONDA_ENV_PATH="/home/jiachen/scratch/graph_reasoning/conda_envs/srgpt"

echo "Creating conda environment in scratch space: $CONDA_ENV_PATH"
conda create -p $CONDA_ENV_PATH python=3.10 -y

echo "Activating environment..."
conda activate $CONDA_ENV_PATH

# This is required to enable PEP 660 support
echo "Upgrading pip..."
pip install --upgrade pip

# This is optional if you prefer to use built-in nvcc
echo "Installing CUDA toolkit..."
conda install -c nvidia cuda-toolkit -y

# Install FlashAttention2
echo "Installing FlashAttention2..."
pip install https://github.com/Dao-AILab/flash-attention/releases/download/v2.5.8/flash_attn-2.5.8+cu122torch2.3cxx11abiFALSE-cp310-cp310-linux_x86_64.whl

# Install VILA
echo "Installing VILA..."
cd /home/jiachen/scratch/graph_reasoning/SpatialRGPT
pip install -e .
pip install -e ".[train]"
pip install -e ".[eval]"

# Install HF's Transformers
echo "Installing Transformers..."
pip install git+https://github.com/huggingface/transformers@v4.37.2

# Copy custom files
echo "Copying custom transformers and deepspeed files..."
site_pkg_path=$(python -c 'import site; print(site.getsitepackages()[0])')
cp -rv ./llava/train/transformers_replace/* $site_pkg_path/transformers/
cp -rv ./llava/train/deepspeed_replace/* $site_pkg_path/deepspeed/

echo "Environment setup complete!"
echo "To activate this environment, run:"
echo "conda activate $CONDA_ENV_PATH"