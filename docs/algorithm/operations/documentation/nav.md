---
layout: default
title: Sentry Auto-Navigation
parent: Alg Team Documentation
grand_parent: Algorithm
nav_order: 4
---

# Starting the Navigation Stack
### By Tom O'Donnell, Louis Liu, Elliot Boudreau, and Ritika Mugundan

This document will guide you through the process of starting the navigation stack on the Sentry. The navigation stack is a collection of ROS2 nodes that allow the robot to autonomously navigate through an environment. The navigation stack uses the ROS2 Navigation2 package, which is a powerful and flexible tool for autonomous navigation. The navigation stack is capable of creating a map of the environment, localizing the robot within the map, and planning and executing paths to reach a goal. The navigation stack is capable of navigating in both simulated and real environments.

## TO CREATE A MAP FROM SIMULATED ENVIRONMENT:

TBD

## TO CREATE A MAP FROM REAL ENVIRONMENT:

Open 5 terminals and connect to the Orin with: `ssh -XC purduerm@182.168.1.54` or `ssh -XC purduerm@182.168.1.30` (whichever IP the orin is on)

- Term1 in `~/ros2-ws`: 
  - `ros2 launch prm_autobot_2023 lidar_control_launch.py`
- Term2 in `~/ros2-ws`: 
  - `ros2 launch nav2_bringup navigation_launch.py`
- Term3 in `~/ros2-ws`: 
  - `ros2 launch slam_toolbox online_asynch_launch.py`
- Term4 in `~/ros2-ws`: 
  - `ros2 run rviz2 rviz2 -d /opt/ros/foxy/share/nav2_bringup/rviz/nav2_default_view.rviz`


**Drive around and record map**, use Rviz window to see the map to check completion. There might be weird obstacles that arent really there (usually if someone is standing around whil you record) If you are not satisfied and cant get rid of the artifact obstacles, restart the terminals and drive again.

Once the map is satisfactory. Run the following command while the other four terminals are running until it successfully saves the map. The command works when a debug message in the terminal says the map is successfully saved. It can take many tries, but no longer than a few minutes of trying.

- Term5 in `/ros2-ws/src/prm_autobot_2023/maps`: 
  - `ros2 run nav2_map_server map_saver cli -t /map -f Robomaster_Arena`

Once this command successfully saves the map, you colcon build the prm_autobot_2023 Project and run the autobot launch as normal.


## TO AUTONOMOUSLY NAVIGATE IN SIMULATED ENVIRONMENT

`ros2 launch prm_autobot_2023 autobot_simulation_launch.py`


## TO AUTONOMOUSLY NAVIGATE IN REAL ENVIRONMENT

Make sure the robot is on.

Connect a terminal to the Orin with: `ssh -XC purduerm@182.168.1.54` or `ssh -XC purduerm@182.168.1.30` (whichever IP the orin is on)

- Terminal in `~/ros2-ws`:
  - `ros2 launch prm_autobot_2023 autobot_launch.py`

Check `README` in worlds file

**NOTE:** There is currently a bug where the program will launch successfully, but will not have any lidar or local costmap data vizible. Rviz will only display the map.png file. 
Currently, we relaunch until it works, it can take a few tries. Once RVIZ launches and there is live updating local cost map data being displayed, the system is ready to use.

We believe this is due to the launch file, There are no rules for the launch order of nodes and servers, so things may launch in different orders.