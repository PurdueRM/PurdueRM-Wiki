---
layout: default
title: Alg Team Project Starter Info
parent: Algorithm
nav_order: 9
---

# Robomaster Project Starter Info
By: Tom O'Donnell (tkodonne@purdue.edu)

This document will serve to introduce you to each sign-up project for the algorithm team this semester. I hope this will provide you with enough info to get started, however dm me if you have remaining questions/concerns.

***
## Group 1: Research Group
All of the below research teams *WILL COLLABORATE WITH EACH OTHER* because they are so tightly-knit:


**Task 1: Research Ballistic Drag Models**

For this task, you will be researching various methods (or models) for accounting for drag within a projectile simulation. 

Some examples may include: static drag values based on projectile size, Newton's method, etc.

Specifically, I will ask for pros/cons of various methods, an explanation of how they work, necessary equations, etc. A PowerPoint should suffice.

**Task 2: Methods of Implementing Drag in Pitch / Yaw Calculations**

To accurately hit a target using our robot, we must calculate the yaw+pitch needed by the gimbal to have a bullet reach a certain XYZ coordinate. To obtain this pitch and yaw value, we need to simulate the trajectory a bullet will follow. Using a simple kinematic approach we can account for gravity, but accounting for drag is a bit harder. 

Your job is to research methods of implementing the effects of drag in these projectile simulations, whether it be via a lookup table (dependent on distance to the target), or numerically solving an equation. You can consider factors such as execution time, accuracy, etc.

**Task 3: Research Decision Theory**

Our goal is to create a fully-autonomous sentry robot. As such, if the sentry sees >1 robot, which robot should it prioritize shooting? We are forced to make a choice here, and your job is to determine *how we should make this choice.* Specifically, what factors play into which robot we should prioritize shooting? 

Some further questions include: How do we ensure we track and shoot the same robot if our vision becomes obstructed for an instant? Even further, what methods can we use to implement this (decision tree, weights,, etc.). How might we pseudocode this? 
- REQUIRES collaboration with pilots (Leo Liu)
***

## Group 2: Aiming Group


**Task 1: Test yaw/pitch calculations and bullet spread**

To accurately hit a target using our robot, we must calculate the yaw+pitch needed by the gimbal to have a bullet reach a certain XYZ coordinate. To obtain this pitch and yaw value, we need to simulate the trajectory a bullet will follow.

Your job is to test our current simulations/code and yaw+pitch calculations. You will fire bullets and collect data regarding accuracy of pitch/yaw calculations, bullet spread, drag, etc.

This may involve setting up a target **x** meters away from the robot, plugging values into our code, an ensuring the fired projectile lands at **x** meters. Or doing analysis on the distribution of locations where projectiles hit a target.

You will work closely with Dhiro and Tom, so stay in contact with them for next steps.

**Task 2: Run tests in the robomaster simulation using projectile models**

To hit an enemy robot with a projectile, we must correctly set the gimbal's yaw and pitch angles (which are calculated via projectile/ballistics equations). 

You will be testing these calculations in the robomaster simulation to ensure they theoretically work, especially those involving a moving target.

This will require learning how to use the sim.

**Task 3: Testing assumptions of constant velocity / acceleration until bullet contact**
- *This task is a little complex.*

Background: To accurately hit a target using our robot, we assume enemy robots move with a constant velocity or constant acceleration. This assumption is required, since we need to "lead our shots" to hit a moving target. We cannot reasonably determine by HOW MUCH to lead our shots without using this assumption to predict where the enemy will be after a certain time interval.

Your job is to test if this assumption is even valid. Do the robots move with constant velocity? Do they move with constant acceleration? If not, can we reasonably APPROXIMATE their motion as such? How much error might this approximation induce?


To test this, you can look at competition footage, test using our actual robots, use the robomaster simulator, etc. I am specifically looking for an answer to the above questions, and also reasoning WHY. 

***
## Group 3: Programming or YOLOv5 Model

**Task 1: Compile Dhiro's Yaw/Pitch calculations, write and verify test cases**

To accurately hit a target using our robot, we must calculate the yaw+pitch needed by the gimbal to have a bullet reach a certain XYZ coordinate. To obtain this pitch and yaw value, we need to simulate the trajectory a bullet will follow.

- We currently have a model which accounts only for gravity, and supports hitting a moving target. Your job is to compile this code, and verify it produces correct results (that the resulting yaw+pitch angles will result in the bullet hitting the desired XYZ).

To accomplish this, you will be writing *test cases*. They may look something like this:

```
static int _test_number_one() 
{ 
	double pitch; 
	double yaw; 
	double target_x = 1.0; 
	double target_y = 0.0; 

	calc_yaw_pitch(target_x, target_y, 15, &pitch, &yaw); 
	
	assert(pitch > 0 && pitch <= 90); 
	assert(yaw >= -360 && yaw <= 360); 
	assert(pitch == 45); 
}
```
Where you define a target XYZ, call the yaw/pitch calculation function, and verify the results match expectations. Again, you need to ensure these calculations will ACTUALLY HIT THE TARGET, so you will need to devise a way to determine if a bullet will hit a moving target upon its landing.

This will involve using (at minimum) kinematics, and a solid understanding of C/C++ programming practices. You may use a unit testing framework, or just the `assert()` macro.

**Task 2: Use two high-frame rate cameras to perform motion-tracking on bullets**

This is a HIGHLY advanced and experimental task. You will use two high-frame-rate cameras in stereo to track the motion of projectiles on the field. If you sign up for this, contact Louis Liu for details.

**Task 3: Create a finalized YOLOv5 model, and conduct formal testing**

We use a Convolutional Neural Network called YOLOv5 to detect enemy robots (specifically their armor plates) on the battlefield. Your job will be creating a finalized YOLOv5 model.

Specifically, you will train three YOLOv5 models:
- Using our current dataset captured in BIDC basement
-  Augmented dataset (ask Tom for this)
- Generated dataset.

You will also conduct formal performance analysis, and determine in which scenarios the models lack in performance/accuracy.

**Task 4: Collect data of the sentry armor plates for YOLOv5 model**

You will gather video/images of robots with the sentry logo on their armor plate, for use in our YOLOv5 robot detection / classification model. 

Essentially, you will be recording using a camera (Intel Realsense) and driving robots around in a chosen location. May need to research our current dataset to determine a suitable number of images to capture, or a suitable duration of video footage. 

***
If any questions remain, contact me (Tom O'Donnell). I will clear up any questions.
