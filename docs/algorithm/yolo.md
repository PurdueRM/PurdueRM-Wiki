---
layout: default
title: Using YoloV5
parent: Algorithm
nav_order: 1
---

# Setting up YoloV5
### By Tom O'Donnell (tkodonne@purdue.edu)

You will need Python and Pip installed for this step. Make a new working directory for setting up Yolo.

`git clone https://github.com/ultralytics/yolov5`

Now installing all requirements for Yolo:

`pip install -r yolov5/requirements.txt`

(As a forewarning, we were unable to use Yolo on M1 Macs due to architecture issues. You may need to compile a few libraries from source to do so.)

# Getting a dataset

To make a suitable dataset, you will need a large collection of images of the object you want to detect. The size is to be determined by you.

After collecting a set of images, you will need to add **bounding boxes** to the images and export the dataset into the YoloV5 format. 

### PRO Tip:
Use roboflow.com to simplify this process. Simply upload the images, and use the built-in bounding box feature to add bounding boxes.

You can also add preprocessing/augmentations to diversify your data as needed, however this step is not always necessary. (Then export the dataset in YoloV5 (pytorch) format).

# Train YoloV5

Download the dataset you created, and paste all the files and folders into the root directory of your YoloV5 folder.

To train YoloV5, run the following command: 

`python train.py --img <image_size> --cfg yolov5s.yaml --batch 32 --epochs <epochs> --data data.yaml --weights yolov5s.pt --workers 24`

This process will likely take forever, so please use a beefy PC. Also, increasing epochs will likely increase the accuracy of YoloV5, but it will increase training time and detection time hugely.

# Testing YoloV5

- `python detect.py --source 0` for webcam
- `python detect.py --source file.jpg` for image
- and so on for other data types

# Demo:

Detecting Enemy Robots via YOLOv5:
[https://youtu.be/4KRM93TuxyA](https://youtu.be/4KRM93TuxyA)
