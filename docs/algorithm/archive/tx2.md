---
layout: default
title: NVIDIA TX2
parent: Archived Pages
grand_parent: Algorithm
nav_order: 5
---

# The NVIDIA Jetson Tx2
### By Tom O'Donnell (tkodonne@purdue.edu)

We use the NVIDIA Jetson Tx2 module to run all of our computer vision and AI-related software on the robot. It's packed with a 256-core Pascal GPU and 256 CUDA Cores, and 8GB 128-bit LPDDR4 Memory. 

Since the internal storage is only 32GB, you should equip the Tx2 with a 32GB or higher MicroSD card.

## Booting up the Tx2
On the east end of the PCB there's a green terminal with a ground and power jack. Properly connect jumper wires to that terminal and to a power source such as the robot or an external battery. The Tx2 will immediately begin to boot up.

## Using a camera on the Tx2
We use the Intel RealSense camera in order to capture not only RGB video, but also infrared, depth, gyroscopic, and acceleration data of the robot. Simply enough, it connects over USB.

To record video from the camera, refer to this section of the GItLab: https://gitlab.com/robomaster-club/realsense-recorder/-/tree/main/

Here there are various setup scripts, and a service you can schedule to start on boot to auto-record once the Tx2 turns on. You can edit and recompile `recorder.cpp` and `viewer.cpp` to enable/disable features of the camera, or set FPS.

The runner saves videos in `.bag` format at ``/home/purduerm/sdcard/``, which can be viewed using Intel RealSense Viewer on a PC.

**IMPORTANT TIP**: The runner script will only record video if *the value of GPIO pin zero is `1`*, which is its default state. This is cool, since if you want to stop recording, you can simply take a female-to-female jumper and connect pin 0 to pin 7 (gnd).

## COMMON ISSUES WITH THE TX2

- **The Tx2 does not boot**
	- Likely a SD card configuration issue. Connect the Tx2 to an external monitor, and `nano /etc/fstab`. If there is an entry for an SD card, update the entry's UUID to match your SD card's UUID, and reboot. Then check the SD card's mount folder to ensure it  was properly mounted on boot.



