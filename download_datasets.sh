#!/usr/bin/env bash
set -e

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Dataset download script for SpatialRGPT
# Storage location: /home/jiachen/scratch/graph_reasoning/datasets/

LOG_FILE="$SCRIPT_DIR/download_datasets.log"
DATASET_DIR="/home/jiachen/scratch/graph_reasoning/datasets"

# Test mode flag (set to "test" for small sample, "full" for complete download)
MODE=${1:-"test"}

echo "=== SpatialRGPT Dataset Download ===" | tee $LOG_FILE
echo "Mode: $MODE" | tee -a $LOG_FILE
echo "Started at $(date)" | tee -a $LOG_FILE
echo "Dataset directory: $DATASET_DIR" | tee -a $LOG_FILE

# Activate conda environment (optional, needed for huggingface-cli)
eval "$(conda shell.bash hook)"

# Install huggingface-cli if not present
if ! command -v huggingface-cli &> /dev/null; then
    echo "Installing huggingface-cli..." | tee -a $LOG_FILE
    pip install -U "huggingface_hub[cli]" 2>&1 | tee -a $LOG_FILE
fi

#================================================================================
# 1. Download OpenSpatialDataset from HuggingFace
#================================================================================
echo "" | tee -a $LOG_FILE
echo "Step 1: Downloading OpenSpatialDataset..." | tee -a $LOG_FILE
OSD_DIR="$DATASET_DIR/OpenSpatialDataset"

if [ "$MODE" = "test" ]; then
    echo "TEST MODE: Downloading sample file only" | tee -a $LOG_FILE
    # Download only the dataset info/README for testing
    huggingface-cli download a8cheng/OpenSpatialDataset \
        --repo-type dataset \
        --local-dir $OSD_DIR \
        --include "README.md" \
        2>&1 | tee -a $LOG_FILE
    echo "Test download successful! Check $OSD_DIR" | tee -a $LOG_FILE
else
    echo "FULL MODE: Downloading complete OpenSpatialDataset (~900K samples)" | tee -a $LOG_FILE
    huggingface-cli download a8cheng/OpenSpatialDataset \
        --repo-type dataset \
        --local-dir $OSD_DIR \
        2>&1 | tee -a $LOG_FILE
fi

#================================================================================
# 2. Download OpenImages V7
#================================================================================
echo "" | tee -a $LOG_FILE
echo "Step 2: Downloading OpenImages V7..." | tee -a $LOG_FILE
OPENIMAGES_DIR="$DATASET_DIR/OpenImages"
mkdir -p $OPENIMAGES_DIR

if [ "$MODE" = "test" ]; then
    echo "TEST MODE: Skipping OpenImages download (use manual download for specific splits)" | tee -a $LOG_FILE
    echo "For testing, you can download a few images manually from:" | tee -a $LOG_FILE
    echo "https://storage.googleapis.com/openimages/web/download_v7.html" | tee -a $LOG_FILE
else
    echo "FULL MODE: Downloading OpenImages train split" | tee -a $LOG_FILE
    echo "Note: OpenImages V7 train split is ~500GB" | tee -a $LOG_FILE
    echo "Download instructions: https://storage.googleapis.com/openimages/web/download_v7.html" | tee -a $LOG_FILE
    echo "" | tee -a $LOG_FILE
    echo "You need to download using the official tools:" | tee -a $LOG_FILE
    echo "1. Install awscli or use the provided download scripts" | tee -a $LOG_FILE
    echo "2. Download train images to: $OPENIMAGES_DIR/train" | tee -a $LOG_FILE
    echo "" | tee -a $LOG_FILE
    echo "Example using aws s3:" | tee -a $LOG_FILE
    echo "aws s3 --no-sign-request sync s3://open-images-dataset/train $OPENIMAGES_DIR/train" | tee -a $LOG_FILE
fi

#================================================================================
# 3. Instructions for Depth Maps
#================================================================================
echo "" | tee -a $LOG_FILE
echo "Step 3: Depth maps generation" | tee -a $LOG_FILE
DEPTH_DIR="$DATASET_DIR/depth_maps"
mkdir -p $DEPTH_DIR

echo "Depth maps need to be generated from RGB images using DepthAnythingV2" | tee -a $LOG_FILE
echo "Depth directory: $DEPTH_DIR" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE
echo "To generate depth maps:" | tee -a $LOG_FILE
echo "1. Clone DepthAnythingV2: git clone https://github.com/DepthAnything/Depth-Anything-V2" | tee -a $LOG_FILE
echo "2. Follow their instructions to process images" | tee -a $LOG_FILE
echo "3. Save depth as 8-bit colorized images to: $DEPTH_DIR" | tee -a $LOG_FILE

#================================================================================
# Summary
#================================================================================
echo "" | tee -a $LOG_FILE
echo "=== Download Summary ===" | tee -a $LOG_FILE
echo "Completed at $(date)" | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE
ls -lh $DATASET_DIR 2>&1 | tee -a $LOG_FILE
echo "" | tee -a $LOG_FILE
echo "Log file: $LOG_FILE" | tee -a $LOG_FILE

if [ "$MODE" = "test" ]; then
    echo "" | tee -a $LOG_FILE
    echo "TEST MODE completed successfully!" | tee -a $LOG_FILE
    echo "To download full datasets, run:" | tee -a $LOG_FILE
    echo "bash $0 full" | tee -a $LOG_FILE
fi