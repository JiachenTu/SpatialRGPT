#!/usr/bin/env bash
set -e

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "=== Downloading Model Weights for 3D Scene Graph Pipeline ==="
echo "Started at $(date)"

# Create directories for external packages
mkdir -p osdsynth/external/Grounded-Segment-Anything/recognize-anything
mkdir -p osdsynth/external/PerspectiveFields/models

echo ""
echo "Step 1/5: Downloading SAM ViT-H (358MB)..."
wget -c https://dl.fbaipublicfiles.com/segment_anything/sam_vit_h_4b8939.pth \
    -P osdsynth/external/Grounded-Segment-Anything

echo ""
echo "Step 2/5: Downloading SAM-HQ ViT-H (2.6GB)..."
wget -c https://huggingface.co/Uminosachi/sam-hq/resolve/main/sam_hq_vit_h.pth \
    -P osdsynth/external/Grounded-Segment-Anything

echo ""
echo "Step 3/5: Downloading Grounding DINO (660MB)..."
wget -c https://github.com/IDEA-Research/GroundingDINO/releases/download/v0.1.0-alpha/groundingdino_swint_ogc.pth \
    -P osdsynth/external/Grounded-Segment-Anything

echo ""
echo "Step 4/5: Downloading RAM (Recognize Anything Model, 3GB)..."
wget -c https://huggingface.co/spaces/xinyu1205/Tag2Text/resolve/main/ram_swin_large_14m.pth \
    -P osdsynth/external/Grounded-Segment-Anything/recognize-anything

echo ""
echo "Step 5/5: Downloading Perspective Fields (102MB)..."
wget -c https://www.dropbox.com/s/z2dja70bgy007su/paramnet_360cities_edina_rpf.pth \
    -P osdsynth/external/PerspectiveFields/models

echo ""
echo "=== Download Summary ==="
echo "Completed at $(date)"
echo ""
echo "Downloaded weights:"
du -sh osdsynth/external/Grounded-Segment-Anything/*.pth 2>/dev/null || echo "SAM weights location check..."
du -sh osdsynth/external/Grounded-Segment-Anything/recognize-anything/*.pth 2>/dev/null || echo "RAM weights location check..."
du -sh osdsynth/external/PerspectiveFields/models/*.pth 2>/dev/null || echo "Perspective Fields weights location check..."
echo ""
echo "Total size:"
du -sh osdsynth/external/