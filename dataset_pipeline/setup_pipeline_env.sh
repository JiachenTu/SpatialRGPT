#!/usr/bin/env bash
set -e

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Setup script for 3D scene graph pipeline environment
echo "=== Setting up OSD Pipeline Environment ==="
echo "Started at $(date)"

# Activate conda
eval "$(conda shell.bash hook)"

# Environment path (using scratch space to save home directory space)
CONDA_ENV_PATH="/home/jiachen/scratch/graph_reasoning/conda_envs/osd_pipeline"

# Check if environment already exists
if [ -d "$CONDA_ENV_PATH" ]; then
    echo "Environment already exists at $CONDA_ENV_PATH"
    echo "To remove and recreate, run: conda remove -p $CONDA_ENV_PATH --all -y"
    exit 1
fi

echo "Creating conda environment at $CONDA_ENV_PATH..."
conda create -p $CONDA_ENV_PATH python=3.10 -y

echo "Activating environment..."
conda activate $CONDA_ENV_PATH

echo "Python version:"
python --version

echo "Installing PyTorch 2.2.2 with CUDA 12.1..."
pip install torch==2.2.2 torchvision==0.17.2 torchaudio==2.2.2 --index-url https://download.pytorch.org/whl/cu121

echo "Installing OpenMIM and mmengine..."
pip install -U openmim
mim install mmengine

echo "Installing mmcv..."
pip install mmcv==2.0.0 -f https://download.openmmlab.com/mmcv/dist/cu121/torch2.2/index.html

echo "Installing Wis3D for visualization..."
pip install https://github.com/zju3dv/Wis3D/releases/download/2.0.0/wis3d-2.0.0-py3-none-any.whl

echo "Installing detectron2..."
pip install 'git+https://github.com/facebookresearch/detectron2.git'

echo "Installing other dependencies..."
pip install iopath pyequilib==0.3.0 albumentations einops open3d imageio

echo "Setup completed at $(date)"
echo ""
echo "To activate the environment:"
echo "  conda activate $CONDA_ENV_PATH"
echo ""
echo "Next steps:"
echo "  1. cd dataset_pipeline"
echo "  2. bash scripts/download_all_weights.sh"
echo "  3. Setup external packages (Grounded-SAM, PerspectiveFields)"