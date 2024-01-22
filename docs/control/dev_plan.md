---
layout: default
title: Development Plan
parent: Control
nav_order: 9
---
# Development Plan

## Table of projects

- [Hardware Library Refractor](#hardware-library-refractor)
- [MC Board Setup](#DM-board-setup)
- [OpenOCD Debug Setup](#openocd-setup)


## Hardware Library Refractor

You will need to refractor the current control code by extracting an extra layer of abstraction. A repository you can work on is the [sentry control repo](https://github.com/RoboMaster-Club/Mecanum_Sentry).

Below is an example for your reference. We are using the code snippet in [GM6020.c](https://github.com/RoboMaster-Club/Mecanum_Sentry/blob/main/Devices/Devices.c/GM6020_Motor.c?plain=#L14-L15)

``` c
Motor_Init_t GM6020_Yaw;
Motor_Init_t GM6020_Pitch;
```

If we put the struct here, the driver cannot be used universal among all the robots and different board, as other robot may not have a GM6020 motor used specifically for yaw or pitch degree of freedom.

We could change the location to initialized these data structures. Particularly for yaw and pitch, we can move it to [Gimbal_Control.c](https://github.com/RoboMaster-Club/Mecanum_Sentry/blob/main/HigherLevelApps/HigherLevelApps.c/Gimbal_Control.c). These higher level application files are specific to different unique robots, and are therefore better place to initialize these struct.

## DM board setup

Long story short, set up the new board with functionality of FreeRTOS, RS485, IMU, CAN, UART.

Download the demo using [this link](https://drive.google.com/file/d/1WG6DzMJeL-3jpTETfSFXjilFFrTLP8so/view?usp=drive_link). If you want to read the comments in the code, which is impossible because they are in chinses, you can unzip using chinese decoding and throw this into chatgpt. Or just throw it into chatgpt and see how it work. :)

try to compile the code and understand the workflow, and ask me for a board to start physical testing

## OpenOCD Setup

or specifically for the remote debugger, using CMSIS_DAP protocal. CMSIS-DAP is kind of a parellel concept of st-link or j-link, for your better reference in the context you will be facing. Refer to [this youtuber](https://www.youtube.com/watch?v=FNDp1G0bYoU&t=618s) and try to set it up on your local machine (with cross platform capatibility)