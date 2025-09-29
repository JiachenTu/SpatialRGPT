# SpatialRGPT Setup Status

**Last Updated**: 2025-09-30 03:20 AM

## ✅ Completed Tasks

1. **Environment Setup** - In Progress
   - ✅ Conda environment created at: `/home/jiachen/scratch/graph_reasoning/conda_envs/srgpt`
   - ⏳ Installing dependencies (running in tmux: `srgpt_install`)
   - Monitor: `tail -f /home/jiachen/scratch/graph_reasoning/install_srgpt.log`

2. **Directory Structure** - ✅ Complete
   ```
   /home/jiachen/scratch/graph_reasoning/
   ├── SpatialRGPT/              # Cloned repo
   ├── conda_envs/srgpt/         # Environment (in scratch to save home dir space)
   ├── datasets/                 # Dataset storage
   │   ├── OpenSpatialDataset/
   │   ├── OpenImages/
   │   └── depth_maps/
   ```

3. **Scripts Created** - ✅ Complete
   - `install_srgpt.sh` - Full installation script
   - `download_datasets.sh` - Dataset download with test mode
   - `tmux_install.sh` - Tmux launcher for installation
   - `tmux_download.sh` - Tmux launcher for downloads
   - `README_SETUP.md` - Comprehensive setup guide

4. **Configuration** - ✅ Complete
   - Updated `SpatialRGPT/llava/data/datasets_mixture.py` with scratch space paths

5. **Test Downloads** - ✅ Complete
   - Tested download script successfully

## ⏳ In Progress

**Installation (Running in tmux: `srgpt_install`)**
- Current status: Installing FlashAttention and PyTorch dependencies
- Progress: Downloading CUDA libraries (nccl, cusparse, cudnn, etc.)
- Check: `tail -f /home/jiachen/scratch/graph_reasoning/install_srgpt.log`
- Attach: `tmux attach -t srgpt_install`

## 📋 Next Steps

1. **Wait for Installation to Complete**
   ```bash
   # Check if done
   grep 'SUCCESS!' /home/jiachen/scratch/graph_reasoning/install_srgpt.log

   # Or monitor in real-time
   tmux attach -t srgpt_install  # Ctrl+B, D to detach
   ```

2. **Download Datasets**
   ```bash
   # Launch in tmux
   bash /home/jiachen/scratch/graph_reasoning/tmux_download.sh full

   # Monitor
   tmux attach -t srgpt_download
   tail -f /home/jiachen/scratch/graph_reasoning/download_datasets.log
   ```

3. **Download OpenImages V7 (Manual)**
   ```bash
   # OpenImages is ~500GB, requires manual download
   aws s3 --no-sign-request sync s3://open-images-dataset/train \
       /home/jiachen/scratch/graph_reasoning/datasets/OpenImages/train
   ```

4. **Generate Depth Maps**
   ```bash
   git clone https://github.com/DepthAnything/Depth-Anything-V2
   # Process OpenImages to generate depth maps
   # Save to: /home/jiachen/scratch/graph_reasoning/datasets/depth_maps
   ```

5. **Start Training**
   ```bash
   conda activate /home/jiachen/scratch/graph_reasoning/conda_envs/srgpt
   cd /home/jiachen/scratch/graph_reasoning/SpatialRGPT

   # Stage 1: MM Alignment
   bash scripts/srgpt/llama3_8b/1_mm_align.sh meta-llama/Meta-Llama-3-8B-Instruct output_name
   ```

## 🎯 Key Information

**Paper**: SpatialRGPT: Grounded Spatial Reasoning in Vision Language Models (NeurIPS 2024)
- **arXiv**: https://arxiv.org/abs/2406.01584
- **Key Innovation**: Enhances VLMs with 3D spatial reasoning via depth integration and region proposals
- **Dataset**: ~900K samples with RGB images, depth maps, and spatial annotations

**Training Pipeline**: 3 stages (VILA-based)
1. MM Alignment - Tunes vision projector + region extractor
2. Pretraining - Learns regional representations
3. SFT - Fine-tunes on SpatialRGPT dataset

**Model Sizes**: sheared_3b, llama2_7b, llama3_8b

## 💾 Disk Space Status

- **Home Directory**: 798G/879G used (96% full) ⚠️
- **Scratch Space**: 54T/167T used (33%) ✅
- **Strategy**: All storage-intensive resources in scratch space

## 📚 Documentation

- Full setup guide: `/home/jiachen/scratch/graph_reasoning/README_SETUP.md`
- This status file: `/home/jiachen/scratch/graph_reasoning/STATUS.md`

## 🔧 Useful Commands

```bash
# Tmux management
tmux ls                              # List all sessions
tmux attach -t srgpt_install        # Attach to installation
tmux attach -t srgpt_download       # Attach to downloads

# Monitor installation
tail -f /home/jiachen/scratch/graph_reasoning/install_srgpt.log
grep 'SUCCESS!' /home/jiachen/scratch/graph_reasoning/install_srgpt.log

# Monitor downloads
tail -f /home/jiachen/scratch/graph_reasoning/download_datasets.log
watch -n 60 'du -sh /home/jiachen/scratch/graph_reasoning/datasets/*'

# Activate environment
conda activate /home/jiachen/scratch/graph_reasoning/conda_envs/srgpt

# Check GPU
nvidia-smi
```