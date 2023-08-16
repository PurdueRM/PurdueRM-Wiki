---
layout: default
title: Computer Vision Project
parent: Onboarding Process
grand_parent: Algorithm
nav_order: 2
---

## This page will serve to briefly summarize the goals and instructions for the Computer Vision Onboarding project.


**Objective**: Read the `pbd.jpg` image, detect the Earth, and crop a 50x50px window around it

**Goals**:
- Get introduced to OpenCV
- Understand basic image processing techniques
	- Gaussian Blur
	- Partial Derivatives / Magnitude maxima
	- Sobel 

**Instructions:**
1. Log onto the development server
2. `cd` into `onboarding_files/cv` and run `nano pbd.py`
3. Starter code and instructions are provided for you

**Resources and helpful info:**
If you don't understand a step, look it up! No shame in consulting documentation.
- OpenCV Documentation: [https://docs.opencv.org/4.x/d6/d00/tutorial_py_root.html](https://docs.opencv.org/4.x/d6/d00/tutorial_py_root.html)
- What is a partial derivative?
	-  A partial derivative is a way to measure how the intensity of a pixel changes with respect to changes in its neighboring pixels. It helps us understand how quickly the pixel values change as we move in different directions within an image. In our case, we use the partial derivatives in the X and Y direction to locate the region of the most intense pixel intensity change, which will be the location of the Earth!

