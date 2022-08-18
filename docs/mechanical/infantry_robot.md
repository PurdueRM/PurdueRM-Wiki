---
layout: default
title: Standard Robot
parent: Mechanical
nav_order: 1
---

# Standard Robot Design
Here we present our past Standard Robot's designs and review some critical strcuture designs. 

## Standard Robot Building Parameters

<!-- table -->
| Item | Limit | Remarks|
| ------------- | ------------- | ------------- |
| Maximum Total Power Supply Capacity (Wh) | 200 | - |
| Maximum Power Supply Voltage (V) | 30 | - |
| Launching Mechanism | A 17mm Launching Mechanism | - |
| Projectile Supply Capability | Can only receive projectiles | - |
| Maximum Weight (kg) | 25 | Includes battery weight, but not the weight of the Referee System |
| Maximum Initial Size (mm, LxWxH) | 600x600x500 | Its orthographic projection on the ground should not exceed a 600*600 square |
| Maximum Expansion Size (mm, LxWxH) | 800x800x800 | Its orthographic projection on the ground should not exceed a 800*800 square |

![img](infantry_robot_pic_01.jpg)
## 3rd Generation
<!-- pictures -->
![img](pictures/standard_robot/standard_3rd_iter_cad.png)

<!-- table -->
| Item | Features | Description|
| ------------- | ------------- | ------------- |
| Built Date | 2022 | RMUL |
| Chassis | four-Wheel mecanum drive | Powered by [M3508 Motors](https://github.com/RoboMaster-Club/PurdueRM-Wiki/blob/gh-pages/docs/control/Useful%20Documents/Devices%20%26%20Datasheets.md)|
| Suspension | Independent suspension | - |
| Gimbal | Two-axis gimbal | Powered by GM6020 |
| Projectile Tank | On the pitch axis | close to the flywheels | 
| Shooting | Two drone propeller motors | Side by side flywheels |
| Materials | Fiberglass, Aluminum | - |

### Actual Robot
![img](pictures/standard_robot/standard_3rd_iter_actual.jpg)

### Chassis
<!-- pictures -->
![img](pictures/standard_robot/standard_3rd_iter_chassis.png)
This is a brand-new chassis comparing to the 1st and 2nd gen Standards. We designed a structural frame by using 15x15x2 mm aluminum tubes. Instead of welding them together, we chosen to design some "L" and "T" shape fiberglass plates to connect all the tubes. 

### Wheel and Suspension
<!-- pictures -->
![img](pictures/standard_robot/standard_3rd_iter_suspension.png)
We gave up the four-bar linkage suspension system because the manufacturing cost was high, and it wasn't easy to fix when some parts failed. Therefore, we designed a two-side supporting wheel and suspension system. A Mecanum wheel is supported and connected in this system by a hub on each side, like a sandwich. Bearings support the hub on each side. Two flange deep-groove ball bearings support the side connected to the motor. To ensure the bearing on both sides is coaxial, a self-aligning ball bearing is placed on another side to support the hub. 

## 2nd Generation


## 1st Generation
<!-- pictures -->
![img](pictures/standard_robot/standard_1st_iter.png)

<!-- table -->
| Item | Features | Description|
| ------------- | ------------- | ------------- |
| Built Date | 2019 | RMUC |
| Chassis | four-Wheel mecanum drive | Powered by [M3508 Motors](https://github.com/RoboMaster-Club/PurdueRM-Wiki/blob/gh-pages/docs/control/Useful%20Documents/Devices%20%26%20Datasheets.md)|
| Suspension | Independent suspension | - |
| Gimbal | Two-axis gimbal | Powered by RM6025 |
| Projectile Tank | Under the gimabl | Chain route from bottom to top | 
| Shooting | Two drone propeller motors | Side by side flywheels |
| Materials | Carbon fibers, Stainless steel frame, Aluminum | - |

### Acutal Robot
![img](pictures/standard_robot/standard_robot_02.jpg) 

### Chassis
<!-- pictures -->
![img](pictures/standard_robot/standard_robot_chassis01.png) 

Couple large carbon-fiber sheets are supported by a welded stainless-steel frame. A T-shape bumper front of the robot chassis to protect suspension from the collsion. Four vertical standoff are mounted on the bottom plate and top plate of the chassis in order to solidly support the suspension system. 

### Wheel and Suspension
<!-- pictures -->
![img](pictures/standard_robot/standard_suspension_design.png) 

A 4-link suspension system was designed for 1st generation Standard. There are two reasons to install a suspension system in our chassis. First, we are using Mecanum wheels, so we have to ensure the robot's four wheels are firmly attached to the ground to help the control team better program the chassis's motion. Secondly, there are some bumps on the battlefield. A suspension can help the robot to eliminate significant vibration and protect the robot. 

The Mecanum wheel is connected to the motor by an aluminum hub. Even though this hub solidly connects a wheel and M3508 motor, two flange deep-groove ball bearings (red in the picture) support the hub shaft to accommodate radial load from the chassis and protect the output shaft of the motor. 

### Gimbal
<!-- pictures -->
![img](pictures/standard_robot/standard_gimbal_design.png)
Two strategies are applied to reduce the load on both yaw and pitch axis motors. 
 - A four-bar linkage is utilized to actuate both axes, as well as saves space and lower the center of gravity
 - Projectile tank is placed on the chassis instead of on the pitch axis, so it highly reduces the inertia of the pitch axis.

A needle roller thrust bearing(red) and a deep-groove ball bearing (blue)  are placed on the yaw axis. The needle roller thrust bearing can be fitted to a small space but support a large axial load. By combing thrust bearing and deep-groove bearing, which predominantly supports the radial load, we can well fit and mobilize the gimbal yaw axis.

 ### Projectile Shooting and Feeding
 ![img](pictures/standard_robot/standard_shooting_feeding_design.png)

Projectiles are fed by a rotor through the middle of the yaw axis, passed through the pitch axis, and finally arrive at the flywheels. Two flywheels are aligned side by side. The distance between two flywheels is smaller than the projectiles' diameter, so the projectiles can be squeezed forward and launched out of the barrel. 