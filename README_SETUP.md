# SpatialRGPT Setup Guide

## Paper Summary
**SpatialRGPT: Grounded Spatial Reasoning in Vision Language Models** (NeurIPS 2024)
- **Paper**: https://arxiv.org/abs/2406.01584
- **Key Innovation**: Enhances VLMs with 3D spatial reasoning by integrating depth information and processing region proposals (boxes/masks)
- **Contributions**:
  - Data curation pipeline from 3D scene graphs
  - Plugin module for depth integration
  - SpatialRGPT-Bench for evaluating 3D spatial cognition

## Directory Structure

```
/home/jiachen/scratch/graph_reasoning/
├── SpatialRGPT/                          # Main repo
├── conda_envs/srgpt/                     # Conda environment (saved on scratch to avoid space issues)
├── datasets/                             # All datasets (storage-intensive)
│   ├── OpenSpatialDataset/              # ~900K annotated samples
│   ├── OpenImages/train/                 # ~500GB RGB images
│   └── depth_maps/                       # Generated depth maps
├── install_srgpt.sh                      # Installation script
├── download_datasets.sh                  # Dataset download script
├── tmux_install.sh                       # Tmux launcher for installation
├── tmux_download.sh                      # Tmux launcher for downloads
└── README_SETUP.md                       # This file
```

## Setup Steps

### 1. Environment Setup

The conda environment is created in scratch space to avoid filling up your home directory (which is at 96% capacity).

**Start installation in tmux (recommended):**
```bash
cd /home/jiachen/scratch/graph_reasoning
bash tmux_install.sh
```

**Monitor installation:**
```bash
# Attach to tmux session
tmux attach -t srgpt_install

# Or watch log file
tail -f /home/jiachen/scratch/graph_reasoning/install_srgpt.log

# Check completion
grep 'SUCCESS!' /home/jiachen/scratch/graph_reasoning/install_srgpt.log
```

**Activate environment:**
```bash
conda activate /home/jiachen/scratch/graph_reasoning/conda_envs/srgpt
```

### 2. Dataset Download

**Test download first (recommended):**
```bash
cd /home/jiachen/scratch/graph_reasoning
bash download_datasets.sh test
```

**Full download in tmux:**
```bash
bash tmux_download.sh full
```

**Monitor downloads:**
```bash
# Attach to tmux session
tmux attach -t srgpt_download

# Or watch log file
tail -f /home/jiachen/scratch/graph_reasoning/download_datasets.log

# Check dataset sizes
watch -n 60 'du -sh /home/jiachen/scratch/graph_reasoning/datasets/*'
```

**Dataset components:**
1. **OpenSpatialDataset**: Downloaded from HuggingFace (a8cheng/OpenSpatialDataset)
2. **OpenImages V7**: Need to download manually from https://storage.googleapis.com/openimages/web/download_v7.html
   ```bash
   # Using AWS CLI (no sign-in required)
   aws s3 --no-sign-request sync s3://open-images-dataset/train \
       /home/jiachen/scratch/graph_reasoning/datasets/OpenImages/train
   ```
3. **Depth Maps**: Generate using DepthAnythingV2
   ```bash
   git clone https://github.com/DepthAnything/Depth-Anything-V2
   # Follow their instructions to process OpenImages and save to:
   # /home/jiachen/scratch/graph_reasoning/datasets/depth_maps
   ```

### 3. Dataset Paths Configuration

✅ Already updated in `SpatialRGPT/llava/data/datasets_mixture.py`:
- `data_path`: `/home/jiachen/scratch/graph_reasoning/datasets/OpenSpatialDataset/result_10_depth_convs.json`
- `image_path`: `/home/jiachen/scratch/graph_reasoning/datasets/OpenImages/train`
- `depth_path`: `/home/jiachen/scratch/graph_reasoning/datasets/depth_maps`

### 4. Training

SpatialRGPT follows a 3-stage training pipeline (VILA-based):

**Available model sizes:**
- `sheared_3b`
- `llama2_7b`
- `llama3_8b`

**Training stages:**
```bash
# Stage 1: MM Alignment (trains vision projector + region extractor)
bash scripts/srgpt/llama3_8b/1_mm_align.sh <BASE_MODEL_PATH> <OUTPUT_NAME>

# Stage 2: Pretraining (learns regional representations)
bash scripts/srgpt/llama3_8b/2_pretrain.sh <STAGE1_CHECKPOINT> <OUTPUT_NAME>

# Stage 3: SFT (fine-tunes on SpatialRGPT dataset)
bash scripts/srgpt/llama3_8b/3_sft.sh <STAGE2_CHECKPOINT> <OUTPUT_NAME>
```

### 5. Evaluation

**Region Classification:**
```bash
bash scripts/srgpt/eval/coco_cls.sh <PATH_TO_CKPT> <CKPT_NAME> <CONV_TYPE>
```

**SpatialRGPT-Bench:**
First download Omni3D images and SpatialRGPT-Bench annotations from HuggingFace (a8cheng/SpatialRGPT-Bench), then:
```bash
bash scripts/srgpt/eval/srgpt_bench.sh <PATH_TO_CKPT> <CKPT_NAME> <CONV_TYPE>
```

## Repository Architecture

### Core Components
- **`/llava/model/`**: VLM architecture with region extractor and depth support
  - `llava_arch.py`: Main model architecture (line 62-100)
  - `region_extractor/`: Encodes region proposals into tokens
  - `multimodal_encoder/`: Vision encoders (CLIP, SigLIP)
  - `multimodal_projector/`: Projects vision features to LLM space

- **`/llava/data/`**: Dataset loading and preprocessing
  - `dataset.py`: Main dataset classes
  - `datasets_mixture.py`: Dataset registry

- **`/llava/train/`**: Training utilities
  - `train_mem.py`: Main training script
  - `sequence_parallel/`: Sequence parallelism for long contexts

### Dataset Pipeline
- **`/dataset_pipeline/`**: Tools to synthesize spatial reasoning data
  - Grounded-SAM for object detection
  - Perspective Fields for depth estimation
  - LLM rephrase for natural language

### Demo
- **`/demo/`**: Gradio interface (requires separate environment)

## Useful Commands

**Check disk space:**
```bash
df -h /home/jiachen         # Home dir (limited space!)
df -h /home/jiachen/scratch # Scratch dir (ample space)
```

**Tmux management:**
```bash
tmux ls                           # List sessions
tmux attach -t <session_name>    # Attach to session
# Press Ctrl+B, then D to detach
tmux kill-session -t <session_name>  # Kill session
```

**Monitor GPU usage:**
```bash
watch -n 1 nvidia-smi
```

## Next Steps

1. ✅ Environment and directory structure created
2. ⏳ Run installation: `bash tmux_install.sh`
3. ⏳ Download datasets: `bash tmux_download.sh full`
4. ⏳ Generate depth maps using DepthAnythingV2
5. ⏳ Run training pipeline

## Troubleshooting

**Out of space errors:**
- The conda environment is in scratch space: `/home/jiachen/scratch/graph_reasoning/conda_envs/srgpt`
- All datasets should go to: `/home/jiachen/scratch/graph_reasoning/datasets/`
- Home directory is at 96% capacity, avoid installing there

**Import errors:**
- Make sure to activate the correct environment: `conda activate /home/jiachen/scratch/graph_reasoning/conda_envs/srgpt`

**Dataset not found:**
- Check paths in `llava/data/datasets_mixture.py` (already updated)
- Verify datasets are downloaded to scratch space

## References
- **Paper**: https://arxiv.org/abs/2406.01584
- **GitHub**: https://github.com/AnjieCheng/SpatialRGPT
- **Project Page**: https://www.anjiecheng.me/SpatialRGPT
- **HuggingFace**: https://huggingface.co/collections/a8cheng/spatialrgpt-66fef10465966adc81819723