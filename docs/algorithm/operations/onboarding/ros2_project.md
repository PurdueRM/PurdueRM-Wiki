---
layout: default
title: SWE/ROS2 Project
parent: Onboarding Process
grand_parent: Algorithm
nav_order: 3
---

## This page will serve to briefly summarize the goals and instructions for the SWE and ROS2 project.


**Objective**: Create a ROS2 node that subscribes to the topic "talker" and prints out the message received

**Goals**:
- Get introduced to ROS2, the industry-standard modular communication framework in robotics.
- Understand how to create and communicate between nodes in our codebase
  - General node structure
  - CMakeLists
  - package.xml
- Understand best practices in software engineering


**Instructions:**
1. Log onto the development server and `cd` into `onboarding_files/ros2/listener`.
2. You have **three* files you need to complete. Don't worry, two are literally just filling in a couple words. Go ahead and follow the instructions in the three files: `CMakeLists.txt`, `package.xml`, and `listener_starter.cpp`.
3. To build your project, `cd` into the `onboarding_files/ros2/` folder and run `colcon build`. Run `source install/setup.sh` to update changes.
4. To test your project, you will need to run the talker node first. Login to the server **in a second window** and `cd` into the talker folder and run `source ../install/setup.sh`. Start the talker node using `ros2 run talker_example talker`. 
5. Back in the original window, `cd` into the your listener project folder, and run `ros2 run listener <executable_name>`. Ensure the listener receives the correct message: "You have completed the ROS2 onboarding project!".

**Resources and helpful info:**
If you don't understand a step, look it up! No shame in consulting documentation. Let's just say writing a listener node is a very common task.


