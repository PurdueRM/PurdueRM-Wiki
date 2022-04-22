---
layout: default
title: A Good Dataset
parent: Algorithm
nav_order: 3
---

# Making a Good Dataset

**Here I will answer the questions of:**
- What qualifies as a "good" dataset?
- How can I increase the reliability of YoloV5?

A "good" dataset is one that enables a balance between accuracy with size. With YoloV5, good results can be obtained with minimal tweaking, assuming your dataset is labelled well, and has an adequate size.

The size of your dataset will obviously vary based on your needs, however Yolov5 recommends >1.5k images, and >10k labelled objects total.

## Increasing YoloV5 accuracy
**Dataset conditions:**
- Collect data under varying conditions (lighting, angles, environments). Your goal is to accurately represent your deployment environment.
- ADD AUGMENTATIONS TO IMAGES, such as rotating, cutting out specific portions, distortions, etc. (it's free dataset diversification)
- Add 0-10% "background images" with no objects to reduce false positives
- Larger Yolo models such as YOLOv5x will likely produce better results, but at the cost of performance and longer training time.
- Start with *pretrained weights* for small/medium datasets. Larger datasets should use the `--weights ''` flag to start new.

**Training Conditions:**
- Begin with 300 epochs (`--epochs 300` when training). *Adjust epochs if overfitting/underfitting occurs!*
- Usually you'll want to train at the same image size that your images are (duh).
- Use the largest batch size your hardware supports.
