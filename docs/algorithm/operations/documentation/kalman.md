---
layout: default
title: Kalman Filter for Vision
parent: Alg Team Documentation
grand_parent: Algorithm
nav_order: 3
---

# Kalman Filter for Vision

Many times when you're working with vision applications, you'll find that the data you're getting from your sensors is inherently noisy. A camera, for example, takes a 3D world and projects it onto a 2D plane, and in doing so it's losing or distorting information. Running processing operations on camera frames can further introduce noise, like in our context no lightbar detection is going to be 100% accurate or consistent. As a result, our estimation of the target robot's true position (the **state of the system**) will always have a level of noise.

How can we handle these noisy measurements and obtain a more accurate estimate of the state of the system?

## Kalman Filter

In our case, we can produce discrete estimations of the target robot's pose using the solvePnP function. We also have a simplified kinematic model of the target robot. You should note that these two sources of information are actually producing a guess at the same thing: the pose of the target robot. A Kalman filter is a way of combining these two uncertain sources of information and **producing a better estimation of the state of the system than either of them could produce on their own**.

The "sensor" in this case is the camera, which allows us to estimate pose of the robot. Our "prediction" is the kinematic model of the robot, which allows us to predict the pose of the robot at any given time. The Kalman filter is a way of combining these two sources of information to produce a more accurate estimation of the state of the system.


### NOTE: This is only intended to document an outline of our Kalman Filter. I will not be explaining derivations of formulas used here, please refer to [this article first](https://www.bzarg.com/p/how-a-kalman-filter-works-in-pictures/#mjx-eqn-covident) for a more in-depth explanation of the math behind the Kalman filter. This is a work in progress and probably contains errors.

<br>
<br>

# Initialization Step

We can define a **state vector** $X$ that represents the state of the system. In our case, this is the pose of the target robot. We'll initialize this to zeros, since we don't know anything about the state of the system in the beginning.

$$\begin{bmatrix} x_0 \\ y_0 \\ z_0 \\ v_{x_0} \\ v_{y_0} \\ v_{z_0} \end{bmatrix} = \begin{bmatrix} 0 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix}
$$

We can also define a predicted state $\hat{X}$ based on our kinematic model:

$$
\hat{X} = x_0 + v_{x_0} * \triangle t \\
\hat{X} = A * X_{old} \newline \space \newline
\hat{X} = \begin{bmatrix} x_0 + v_{x_0} * \triangle t \\ y_0 + v_{y_0} * \triangle t \\ z_0 + v_{z_0} * \triangle t \\ v_{x_0} \\ v_{y_0} \\ v_{z_0} \end{bmatrix}
$$

Taking $\hat{X}$ and factoring out the state vector:

$$
\hat{X} = \begin{bmatrix} x_0 + v_{x_0} * \triangle t \\ y_0 + v_{y_0} * \triangle t \\ z_0 + v_{z_0} * \triangle t \\ v_{x_0} \\ v_{y_0} \\ v_{z_0} \end{bmatrix} = \overset{\text{State Transition Matrix}}{\begin{bmatrix} 1 & 0 & 0 & \triangle t & 0 & 0 \\ 0 & 1 & 0 & 0 & \triangle t & 0 \\ 0 & 0 & 1 & 0 & 0 & \triangle t \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}} * \overset{\text{State Vector } X}{\begin{bmatrix} x_0 \\ y_0 \\ z_0 \\ v_{x_0} \\ v_{y_0} \\ v_{z_0} \end{bmatrix}}
$$

This gives rise to the **state transition matrix** $A$, which describes how the state of the system changes over time. In our case, this is the kinematic model we apply to the state vector:
$$
 A = \begin{bmatrix} 1 & 0 & 0 & \triangle t & 0 & 0 \\ 0 & 1 & 0 & 0 & \triangle t & 0 \\ 0 & 0 & 1 & 0 & 0 & \triangle t \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}
$$

We'll then define the covariance matrix $P$, which describes the covariance (or uncertainty) correlation between state variables. The $[i, j]$-th entry corresponds to the correlation between uncertainty of state variables $i$ and $j$. We'll initialize this to a diagonal matrix of ones, since we don't know anything about the covariance of the state vector in the beginning:

$$
P = \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}
$$

We also need to represent the uncertainty of our measurement (the pose of the target robot as estimated by solvePnP) and the uncertainty of our prediction (the pose of the target robot as estimated by our kinematic model). We can do this by defining the **measurement covariance matrix** $R$ and the **process noise covariance matrix** $Q$. $Q$ will be initialized to a diagonal matrix of 0.1 as an initial guess. $R$ will be initialized to a diagonal matrix of 5 as an initial guess. This indicates that we're more confident in our prediction via kinematics than our measurement.


$$
Q = \begin{bmatrix} 0.1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 0.1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 0.1 & 0 & 0 & 0 \\ 0 & 0 & 0 & 0.1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 0.1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 0.1 \end{bmatrix}
$$

$$
R = \begin{bmatrix} 5 & 0 & 0 \\ 0 & 5 & 0 \\ 0 & 0 & 5 \end{bmatrix}
$$

# Update Step
Once we have initialized all the needed matrices, we can start the update step. The update step is where we take a measurement from the camera and combine it with our prediction to produce a better estimation of the state of the system.

Since we have a pose estimate from our camera, let's define a **measurement vector** $X_{measured_{t}}$ that represents the pose of the target robot as estimated by solvePnP:

$$
X_{measured_{t}} = \begin{bmatrix} x \\ y \\ z \end{bmatrix}
$$

More rigorously, we should be calling this $Z_t$, which is the measurement at time $t$. 

Now we'll form our pose prediction based on the kinematic model we defined earlier (this should be familiar from above):
$$
\hat{X} = A * X = \begin{bmatrix} 1 & 0 & 0 & \triangle t & 0 & 0 \\ 0 & 1 & 0 & 0 & \triangle t & 0 \\ 0 & 0 & 1 & 0 & 0 & \triangle t \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix} * \begin{bmatrix} x_0 \\ y_0 \\ z_0 \\ v_{x_0} \\ v_{y_0} \\ v_{z_0} \end{bmatrix} = \begin{bmatrix} x_0 + v_{x_0} * \triangle t \\ y_0 + v_{y_0} * \triangle t \\ z_0 + v_{z_0} * \triangle t \\ v_{x_0} \\ v_{y_0} \\ v_{z_0} \end{bmatrix}
$$

The covariance of the predicted state vector is given by $P_t$:

$$
P_t = APA^T + Q = \begin{bmatrix} 1 & 0 & 0 & dt & 0 & 0 \\ 0 & 1 & 0 & 0 & dt & 0 \\ 0 & 0 & 1 & 0 & 0 & dt \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 1 & 0 & 0 & dt & 0 & 0 \\ 0 & 1 & 0 & 0 & dt & 0 \\ 0 & 0 & 1 & 0 & 0 & dt \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}^T + \begin{bmatrix} 0.1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 0.1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 0.1 & 0 & 0 & 0 \\ 0 & 0 & 0 & 0.1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 0.1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 0.1 \end{bmatrix}
$$

We can then define the **innovation of measurement** $y_t$ as the difference between our measurement and our prediction:

$$
y_t = z_t - H\hat{X_t} \newline \space \newline
y_t = \begin{bmatrix} x \\ y \\ z \end{bmatrix} - \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix} * \begin{bmatrix} x_0 + v_{x_0} * \triangle t \\ y_0 + v_{y_0} * \triangle t \\ z_0 + v_{z_0} * \triangle t \\ v_{x_0} \\ v_{y_0} \\ v_{z_0} \end{bmatrix} = \begin{bmatrix} x - (x_0 + v_{x_0} * \triangle t) \\ y - (y_0 + v_{y_0} * \triangle t) \\ z - (z_0 + v_{z_0} * \triangle t) \end{bmatrix} 
$$ 


The predicted covariance of our innovation is given by $S_t$:

$$
S_t = H\hat{P_t}H^T + R = \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix} \hat{P_t} \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}^T + \begin{bmatrix} 5 & 0 & 0 \\ 0 & 5 & 0 \\ 0 & 0 & 5 \end{bmatrix}
$$


We now have all the information we need to calculate the **Kalman gain** and update our state vector and covariance matrix. The Kalman gain $K$ is given by:

$$
K = \hat{P_t}H^TS_t^{-1} = \hat{P_t} \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}^T S_t^{-1}
$$

The updated covariance matrix $P_t$ is given by:

$$
P_t = (I - KH)\hat{P_t} = (I - K \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}) \hat{P_t}
$$

And finally we produce our final estimation of the state of the system $X_t$:

$$
X_t = \hat{X_t} + K(y_t) \newline
= \begin{bmatrix} x_0 + dt*v_x \\ y_0 + dt*v_y \\ z_0 + dt*v_z \\ v_x \\ v_y \\ v_z \end{bmatrix} + K \begin{bmatrix} x - (x_0 + v_{x_0} * \triangle t) \\ y - (y_0 + v_{y_0} * \triangle t) \\ z - (z_0 + v_{z_0} * \triangle t) \end{bmatrix}  \newline
= \begin{bmatrix} x_0 + dt*v_x \\ y_0 + dt*v_y \\ z_0 + dt*v_z \\ v_x \\ v_y \\ v_z \end{bmatrix} + \begin{bmatrix} K_{x} * (x - (x_0 + v_{x_0} * \triangle t)) \\ K_{y} * (y - (y_0 + v_{y_0} * \triangle t)) \\ K_{z} * (z - (z_0 + v_{z_0} * \triangle t)) \\ 0 \\ 0 \\ 0 \end{bmatrix} \newline
$$



Then we can extract our predicted position and velocity from X, our updated state vector:
```cpp
dst[0] = this->X(0, 0); // predicted x
dst[1] = this->X(1, 0); // predicted y
dst[2] = this->X(2, 0); // predicted z
dst[3] = this->X(3, 0); // predicted vx
dst[4] = this->X(4, 0); // predicted vy
dst[5] = this->X(5, 0); // predicted vz
```