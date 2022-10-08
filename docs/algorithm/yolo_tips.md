---
layout: default
title: YoloV5 Training Tips
parent: Algorithm
nav_order: 8
---

# YoloV5 Training Tips
By Tom O'Donnell (tkodonne@purdue.edu)
***
If you're working on the "Training YoloV5" onboarding project, odds are you're going to get confused at one point or another. The instructions posted in the Discord server were intentionally left vague, as the goal is for you to understand for yourself what results in a good model. 

However, this has left people stuck, so I've written this starter pack to explain the components of training.

**You do not need to understand all of this page, but parts of it will likely come in handy. Feel free to skim parts you don't want to read.**

**Yes, this is complicated, but it's a chance to learn a new skill and insight into how our robot classification actually works.**

## Table of Contents
- [What Comprises a Dataset?](#What-comprises-a-dataset)
- [Files and Folder Layout](#Files-and-Folder-Layout)
- [How to Train Yolo](#How-to-train-yolo)
- [Evaluating Model Performance](#Evaluating-Performance)
- [Summary and a step-by-step](#Summary)

***

## What comprises a dataset?
### - Images
Many pictures containing the item you want to train to detect, the number / diversity of which depends on your needs. 
### - Annotations
Text files describing where in the image your desired object appears. Every image you have in your dataset REQUIRES an individual annotation file, it's how yolo can learn about your objects!

Here's an example of an annotation file:

`image_123.txt contents:`

    5 0.209316 0.241667 0.116745 0.091667
    4 0.715802 0.295833 0.073113 0.091667

As such, each line of an annotation file follows the format:

`object_class` `x_center_object` `y_center_object` `bounding_box_width` `bounding_box_height`

**Fortunately, any dataset you find online at Roboflow or other sites will likely have annotation files already. If you're gathering your own data from scratch, however, you will need to create these files yourself.**

### - data.yaml
This file tells yolo exactly where your images and annotation files are located, along with info on the types of objects you're trying to train to detect. Again, datasets you find online will probably have this file already.

***

## Files and Folder Layout

*This is probably the part of this article you came here for.*

So you have images, you have annotation files, and you have your data.yaml`. What now?

After setting up yolo, you should open the resulting yolov5 folder. Inside of it is a folder named `data`. Take your `data.yaml`and place it in here.

You'll also notice two folders called `images` and `labels`. Each one of these two folders is subdivided into three groups: `test`, `train`, and `val`, which I briefly described earlier. If you look at your downloaded dataset, it should also be divided into groups of the same names. So go ahead and place your `train` images into the `train` folder, `test` images into `test`, and `val` images into `val`. 

Similarly, go back up one directory, and place your `test`, `train`, and `val` annotation files into their respective folders in `labels`.

In summary, all of these folders/files should be in your `yolov5/data` folder:

- data.yaml
- images/
	- test/
	  -   <your_test_images>
	- train/
	  -   <your_train_images>
	- val/
	  -   <your_val_images>
- labels/
	- test/
	  -   <your_test_labels>
	- train/
	  -   <your_train_labels>
	- val/
	  -   <your_val_labels>

***

## How to train yolo
- Open a command prompt window inside `/yolov5`.
- Customize and run this command depending on your PC and desired epochs:

      python train.py --img <image_size> --cfg yolov5s.yaml --batch <batches> --epochs <epochs> --data` data.yaml --weights yolov5s.pt --workers <workers>

	- For example, you may run: `python train.py --img 848 --cfg yolov5s.yaml --batch 24 --epochs 40 --data data.yaml --weights yolov5s.pt --workers 12`
- You will probably run into some errors. If you're running out of memory, decrease your batch size to start. Other issues are solvable with a simple google search usually.

***

## Evaluating Performance
After training for your specified number of epochs, yolo will output a number of files and images into the`runs/train/expX` folder. The model resulting from training is saved into `weights`. You'll notice there are actually TWO  files, `best.pt` and `last.pt`. 

`last.pt` saves your training results after the last epoch you trained on, and `best.pt` saves your **best** training results, which is actually quite cool. 

To actually see how your model performs, you'll be most interested in viewing `results.csv`, and you may actually want to plot this data for easier viewing.

You'll want your loss to be as low as possible. Typically it'll flatline, and when it starts to increase again that's a good sign your training is done, or overfitting is starting to occur. mAP (mean average precision) is a metric combining the precision-recall curve into a single value representing the average of all precisions.

This is the past of the onboarding project I left intentionally vague. Partially because learning this is not a one-size-fits-all approach, where you can definitely say training is done after `x` number of epochs or when your mAP hits a certain value.

***

# Summary
- A dataset is made up of images, labels, and `data.yaml` describing where yolo can find those files.
- Images and labels are split up into `test`, `train`, and `val` subdivisions. You will place your images and labels in their respective subdivison folders, and `data.yaml` inside the `/yolov5/data/` folder prior to training.
- You need to customize your training command to your training goals and PC hardware.
- You can use `results.csv` to evaluate your model's performance.

If you want a step-by-step, here you go:
1. Gather images and annotations
2. Create `data.yaml`
3. Place `data.yaml` into `/yolov5/data/`
4. Place each subdivision of images into the respective folder inside `/yolov5/data/images/`
5. Place each subdivision of labels into the respective folder inside `/yolov5/data/labels/`
6. Customize your training command
7. Train and wait several hours for it to complete
8. Evalutate model performance
