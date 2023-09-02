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
- Get introduced to ROS2
- Understand how to create and communicate between nodes in our codebase
  - General node structure
  - CMakeLists
  - package.xml
- Understand best practices in software engineering


**Instructions:**
1. Log onto the development server
2. `cd` into `onboarding_files/ros`.
3. You have **three* files you need to complete. Don't worry, two are literally just filling in a couple words.
4. To build your project, `cd` into the `onboarding_files` folder and run `colcon build`.
5. To test your project, run `source install/setup.sh` and `ros2 run listener <executable_name`. Ensure it receives the correct message: "You have completed the ROS2 onboarding project"

**Resources and helpful info:**
If you don't understand a step, look it up! No shame in consulting documentation.


