#!/usr/bin/env bash
set -e

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Log file for installation
LOG_FILE="$SCRIPT_DIR/install_srgpt.log"
echo "Installation started at $(date)" > $LOG_FILE

# Activate conda
eval "$(conda shell.bash hook)"

# Environment path
CONDA_ENV_PATH="/home/jiachen/scratch/graph_reasoning/conda_envs/srgpt"

echo "Activating conda environment..." | tee -a $LOG_FILE
conda activate $CONDA_ENV_PATH

echo "Python version:" | tee -a $LOG_FILE
python --version | tee -a $LOG_FILE

echo "Upgrading pip..." | tee -a $LOG_FILE
pip install --upgrade pip 2>&1 | tee -a $LOG_FILE

echo "Installing CUDA toolkit..." | tee -a $LOG_FILE
conda install -c nvidia cuda-toolkit -y 2>&1 | tee -a $LOG_FILE

echo "Installing FlashAttention2..." | tee -a $LOG_FILE
pip install https://github.com/Dao-AILab/flash-attention/releases/download/v2.5.8/flash_attn-2.5.8+cu122torch2.3cxx11abiFALSE-cp310-cp310-linux_x86_64.whl 2>&1 | tee -a $LOG_FILE

cd "$SCRIPT_DIR"

echo "Installing VILA base package..." | tee -a $LOG_FILE
pip install -e . 2>&1 | tee -a $LOG_FILE

echo "Installing VILA training dependencies..." | tee -a $LOG_FILE
pip install -e ".[train]" 2>&1 | tee -a $LOG_FILE

echo "Installing VILA eval dependencies..." | tee -a $LOG_FILE
pip install -e ".[eval]" 2>&1 | tee -a $LOG_FILE

echo "Installing Transformers..." | tee -a $LOG_FILE
pip install git+https://github.com/huggingface/transformers@v4.37.2 2>&1 | tee -a $LOG_FILE

echo "Copying custom files..." | tee -a $LOG_FILE
site_pkg_path=$(python -c 'import site; print(site.getsitepackages()[0])')
cp -rv ./llava/train/transformers_replace/* $site_pkg_path/transformers/ 2>&1 | tee -a $LOG_FILE
cp -rv ./llava/train/deepspeed_replace/* $site_pkg_path/deepspeed/ 2>&1 | tee -a $LOG_FILE

echo "Installation completed at $(date)" | tee -a $LOG_FILE
echo "SUCCESS!" | tee -a $LOG_FILE