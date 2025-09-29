# SpatialRGPT Setup Progress

**Last Updated**: 2025-09-30 07:00 AM

## ✅ Completed

### 1. Repository Setup
- **Fork**: https://github.com/JiachenTu/SpatialRGPT
- **Branch**: `dev`
- **Location**: `/nas/jiachen/graph_reasoning/SpatialRGPT`

### 2. Environment Installation
- **Status**: ✅ Complete
- **Environment**: `/home/jiachen/scratch/graph_reasoning/conda_envs/srgpt`
- **Tmux session**: `srgpt_install` (completed)
- **Log**: `/nas/jiachen/graph_reasoning/install_srgpt.log`
- **Installed components**:
  - FlashAttention2 v2.5.8
  - VILA base + training + eval
  - Transformers v4.37.2
  - All dependencies

### 3. Dataset Download
- **Status**: ✅ OpenSpatialDataset downloaded
- **Tmux session**: `srgpt_download` (completed)
- **Log**: `/nas/jiachen/graph_reasoning/SpatialRGPT/download_datasets.log`

**Downloaded**:
- ✅ OpenSpatialDataset: 7.6GB (`result_10_depth_convs.json`)
  - ~900K pre-generated 3D scene graphs
  - Location: `/home/jiachen/scratch/graph_reasoning/datasets/OpenSpatialDataset/`

**Not Downloaded**:
- ❌ OpenImages V7: Empty (~500GB needed for generating new scene graphs)
- ❌ Depth maps: Empty (need to generate from RGB using DepthAnythingV2)

---

## 🔄 In Progress

### 4. 3D Scene Graph Pipeline Setup

**Goal**: Set up pipeline to generate 3D scene graphs from RGB images

**Components needed**:
1. **Pipeline environment** (`osd_pipeline`)
   - Separate conda env with different dependencies
   - Python 3.10 + PyTorch + mmengine + detectron2

2. **Model weights** (~10GB total)
   - SAM / SAM-HQ
   - Grounding DINO
   - RAM (Recognize Anything Model)
   - Perspective Fields

3. **External packages**
   - Grounded-Segment-Anything
   - PerspectiveFields

4. **Input images** (for generation)
   - OpenImages V7 train split (~500GB)
   - Or custom image dataset

**Pipeline outputs**:
- JSON files with 3D scene graphs
- Each scene graph contains:
  - Detected objects with 3D bounding boxes
  - Point clouds (reconstructed 3D positions)
  - Spatial relationships (left/right, above/below, etc.)
  - Segmentation masks

---

## 📝 Next Steps

1. Create pipeline conda environment
2. Download model weights
3. Install Grounded-SAM and PerspectiveFields
4. Test pipeline on sample images
5. (Optional) Download OpenImages V7 for large-scale generation
6. (Optional) Generate depth maps using DepthAnythingV2

---

## 📊 Storage Usage

```
/home/jiachen/scratch/graph_reasoning/
├── SpatialRGPT/              18M (code repository)
├── conda_envs/
│   └── srgpt/               1.5G (training environment)
├── datasets/
│   ├── OpenSpatialDataset/  7.6G (downloaded)
│   ├── OpenImages/          512B (empty - need ~500GB)
│   └── depth_maps/          512B (empty - need ~500GB)
```

---

## 🔑 Key Files

- **Training env**: `/home/jiachen/scratch/graph_reasoning/conda_envs/srgpt`
- **Dataset config**: `llava/data/datasets_mixture.py`
- **Training scripts**: `scripts/srgpt/llama3_8b/`
- **Pipeline scripts**: `dataset_pipeline/`
- **Setup logs**: `install_srgpt.log`, `download_datasets.log`