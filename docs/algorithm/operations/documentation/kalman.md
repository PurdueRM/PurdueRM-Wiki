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

This gives rise to the **state transition matrix** $A$, which describes how the state of the system changes over time. In our case, this is the kinematic model we apply to the state vector.

$$
 A = \begin{bmatrix} 1 & 0 & 0 & \triangle t & 0 & 0 \\ 0 & 1 & 0 & 0 & \triangle t & 0 \\ 0 & 0 & 1 & 0 & 0 & \triangle t \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}
$$

We'll then define the covariance matrix $P$, which describes the covariance (or uncertainty) correlation between state variables. The $[i, j]$-th entry corresponds to the correlation between uncertainty of state variables $i$ and $j$. We'll initialize this to a diagonal matrix of 10000 as an initial guess. This indicates that we're very uncertain about the state of the system in the beginning.

$$
P = \begin{bmatrix} 10000 & 0 & 0 & 0 & 0 & 0 \\ 0 & 10000 & 0 & 0 & 0 & 0 \\ 0 & 0 & 10000 & 0 & 0 & 0 \\ 0 & 0 & 0 & 10000 & 0 & 0 \\ 0 & 0 & 0 & 0 & 10000 & 0 \\ 0 & 0 & 0 & 0 & 0 & 10000 \end{bmatrix}
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

The covariance of the predicted state vector $\hat{X}$ is given by $\hat{P}_t$:

$$
\hat{P}_t = APA^T + Q = \begin{bmatrix} 1 & 0 & 0 & \triangle t & 0 & 0 \\ 0 & 1 & 0 & 0 & \triangle t & 0 \\ 0 & 0 & 1 & 0 & 0 & \triangle t \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 1 & 0 & 0 & \triangle t & 0 & 0 \\ 0 & 1 & 0 & 0 & \triangle t & 0 \\ 0 & 0 & 1 & 0 & 0 & \triangle t \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}^T + \begin{bmatrix} 0.1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 0.1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 0.1 & 0 & 0 & 0 \\ 0 & 0 & 0 & 0.1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 0.1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 0.1 \end{bmatrix}
$$

We can then define the **innovation of measurement** $y_t$ as the difference between our measurement and our prediction. 
Note that since $\hat{X_t} \in \R^6$ we need to map this vector in $\real^6 \rightarrow \real^3$ in order to subtract between the measurement and prediction. $H$ is this such **observation matrix** that maps from the state space to the measurement space:

$$
y_t = z_t - H\hat{X_t} \newline \space \newline
y_t = \begin{bmatrix} x \\ y \\ z \end{bmatrix} - \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix} \begin{bmatrix} x_0 + v_{x_0} * \triangle t \\ y_0 + v_{y_0} * \triangle t \\ z_0 + v_{z_0} * \triangle t \\ v_{x_0} \\ v_{y_0} \\ v_{z_0} \end{bmatrix} = \begin{bmatrix} x - (x_0 + v_{x_0} * \triangle t) \\ y - (y_0 + v_{y_0} * \triangle t) \\ z - (z_0 + v_{z_0} * \triangle t) \end{bmatrix} 
$$ 


The predicted covariance of our innovation is given by $S_t$:

$$
S_t = H\hat{P_t}H^T + R = \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix} \hat{P_t} \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}^T + \begin{bmatrix} 5 & 0 & 0 \\ 0 & 5 & 0 \\ 0 & 0 & 5 \end{bmatrix}
$$


We now have all the information we need to calculate the **Kalman gain** and update our state vector and covariance matrix. The Kalman gain $K$ first maps $\hat{P}_t$ from $\real^6 \rightarrow \real^3$ and then multiplies by the inverse of $S_t$. 

$$
K = \hat{P_t}H^TS_t^{-1} = \hat{P_t} \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}^T S_t^{-1}
$$

Intuitively, a large covariance in the state vector (high uncertainty) or a small covariance in the innovation (high confidence in measurement) will result in a larger Kalman gain. This makes sense, since we want to trust our measurement more if we're more confident in it, and we want to trust our prediction more if we're less confident in our measurement.

The updated covariance matrix $P_t$ is given by:

$$
P_t = (I - KH)\hat{P_t} = (I - K \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}) \hat{P_t}
$$

And finally we produce our final estimation of the state of the system $X_t$, which is our state predicted by our kinematic model plus the Kalman gain times the innovation of measurement. You can think of this as a weighted average of our prediction and our measurement, where the weight is given by the Kalman gain.

$$
X_t = \hat{X_t} + K(y_t) \newline
= \begin{bmatrix} x_0 + v_{x_0} * \triangle t \\ y_0 + v_{y_0} * \triangle t \\ z_0 + v_{z_0} * \triangle t \\ v_{x_0} \\ v_{y_0} \\ v_{z_0} \end{bmatrix} + K \begin{bmatrix} x - (x_0 + v_{x_0} * \triangle t) \\ y - (y_0 + v_{y_0} * \triangle t) \\ z - (z_0 + v_{z_0} * \triangle t) \end{bmatrix}  \newline
$$

Intuitively, if our real measurement is close to our prediction (or the uncertainty of our measurement is low), then the Kalman gain will be closer to 1, resulting in a larger trust into our measured state. If our real measurement is far from our prediction (or the uncertainty of our measurement is high), then the Kalman gain will be closer to 0, resulting in a larger trust into our predicted state.


Then we can extract our predicted position and velocity from $X$, our updated state vector:
```cpp
dst[0] = this->X(0, 0); // predicted x
dst[1] = this->X(1, 0); // predicted y
dst[2] = this->X(2, 0); // predicted z
dst[3] = this->X(3, 0); // predicted vx
dst[4] = this->X(4, 0); // predicted vy
dst[5] = this->X(5, 0); // predicted vz
```

## Summarizing the Process:
1. **Initializations**:
   1. Define state vector $X$ along with its covariance matrix $P$.
   2. Define state transition matrix (model of system) $A$ and its process noise covariance matrix $Q$.
   3. Define the observation matrix $H$, which maps from the state space to the measurement space.
   4. Define the measurement covariance matrix $R$, which captures the noise of the sensor and is treated as constant.
2. **Update Step**:
    1. Populate the measurement vector $X_{measured_{t}}$ or $Z_t$.
    2. Calculate the predicted state vector $\hat{X}$ based on the state model and its covariance matrix $\hat{P}_t$.
    3. Update the innovation of measurement $y_t$ and its covariance matrix $S_t$.
    4. Calculate the Kalman gain $K$.
    5. Update the state vector $X_t$ and its covariance matrix $P_t$.

<br>
<br>
<br>
<br>

# Let's Do an Example Mathematically

Start by assuming we've initialized and reset the Kalman filter. We'll also assume that we have a pose estimate from solvePnP after 0.1 seconds ($\triangle t$): 

```cpp
this->X_t_measure(0, 0) = pos_x;
this->X_t_measure(1, 0) = pos_y;
this->X_t_measure(2, 0) = pos_z;
```
$$
X_{measured_{t}} = z_t = \begin{bmatrix} 10 \\ 20 \\ 40 \end{bmatrix} \text{ for example}
$$

Putting $\triangle t$ into our state transition matrix $A$:

```cpp
this->A(0, 3) = dt;
this->A(1, 4) = dt;
this->A(2, 5) = dt;
```

$$
 A = \begin{bmatrix} 1 & 0 & 0 & \triangle t & 0 & 0 \\ 0 & 1 & 0 & 0 & \triangle t & 0 \\ 0 & 0 & 1 & 0 & 0 & \triangle t \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix} = \begin{bmatrix} 1 & 0 & 0 & 0.1 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0.1 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0.1 \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}
$$

Updating our predicted state vector $\hat{X}$:

```cpp
this->X_hat_t = this->A * this->X;
```
$$
\hat{X} = A * X = \begin{bmatrix} 1 & 0 & 0 & 0.1 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0.1 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0.1 \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 0 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix} = \begin{bmatrix} 0 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix}
$$

```cpp
this->P_hat_t = this->A * this->P * this->A.transpose() + this->Q;
```
$$
\hat{P}_t = APA^T + Q = \begin{bmatrix} 1 & 0 & 0 & 0.1 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0.1 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0.1 \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 10000 & 0 & 0 & 0 & 0 & 0 \\ 0 & 10000 & 0 & 0 & 0 & 0 \\ 0 & 0 & 10000 & 0 & 0 & 0 \\ 0 & 0 & 0 & 10000 & 0 & 0 \\ 0 & 0 & 0 & 0 & 10000 & 0 \\ 0 & 0 & 0 & 0 & 0 & 10000 \end{bmatrix} \begin{bmatrix} 1 & 0 & 0 & 0.1 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0.1 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0.1 \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}^T + \begin{bmatrix} 0.1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 0.1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 0.1 & 0 & 0 & 0 \\ 0 & 0 & 0 & 0.1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 0.1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 0.1 \end{bmatrix} \newline
= \begin{bmatrix} 10100.1 & 0 & 0 & 1000 & 0 & 0 \\ 0 & 10100.1 & 0 & 0 & 1000 & 0 \\ 0 & 0 & 10100.1 & 0 & 0 & 1000 \\ 1000 & 0 & 0 & 10000.1 & 0 & 0 \\ 0 & 1000 & 0 & 0 & 10000.1 & 0 \\ 0 & 0 & 1000 & 0 & 0 & 10000.1 \end{bmatrix}
$$

```cpp
this->z_t = Eigen::Matrix<float, 3, 3>::Identity() * this->X_t_measure;
```
$$
X_{measured_{t}} = z_t = \begin{bmatrix} 1 & 0 & 0 \\ 0 & 1 & 0 \\ 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 10 \\ 20 \\ 40 \end{bmatrix} = \begin{bmatrix} 10 \\ 20 \\ 40 \end{bmatrix}
$$

```cpp
this->y_t = this->z_t - this->H * this->X_hat_t;
```

$$
y_t = z_t - H\hat{X_t} \newline \space \newline
y_t = \begin{bmatrix} 10 \\ 20 \\ 40 \end{bmatrix} - \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix} * \begin{bmatrix} 0 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix} = \begin{bmatrix} 10 \\ 20 \\ 40 \end{bmatrix}
$$ 

```cpp
this->S_t = this->H * this->P_hat_t * this->H.transpose() + this->R;
```

$$
S_t = H\hat{P_t}H^T + R = \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix} \begin{bmatrix} 10100.1 & 0 & 0 & 1000 & 0 & 0 \\ 0 & 10100.1 & 0 & 0 & 1000 & 0 \\ 0 & 0 & 10100.1 & 0 & 0 & 1000 \\ 1000 & 0 & 0 & 10000.1 & 0 & 0 \\ 0 & 1000 & 0 & 0 & 10000.1 & 0 \\ 0 & 0 & 1000 & 0 & 0 & 10000.1 \end{bmatrix} \begin{bmatrix} 1 & 0 & 0 \\ 0 & 1 & 0 \\ 0 & 0 & 1 \\ 0 & 0 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 0 \end{bmatrix} + \begin{bmatrix} 5 & 0 & 0 \\ 0 & 5 & 0 \\ 0 & 0 & 5 \end{bmatrix} \newline
= \begin{bmatrix} 10105.1 & 0 & 0 \\ 0 & 10105.1 & 0 \\ 0 & 0 & 10105.1 \end{bmatrix}
$$

```cpp
this->K = this->P_hat_t * this->H.transpose() * this->s_t.inverse();
```

$$
K = \hat{P_t}H^TS_t^{-1} = \begin{bmatrix} 10100.1 & 0 & 0 & 1000 & 0 & 0 \\ 0 & 10100.1 & 0 & 0 & 1000 & 0 \\ 0 & 0 & 10100.1 & 0 & 0 & 1000 \\ 1000 & 0 & 0 & 10000.1 & 0 & 0 \\ 0 & 1000 & 0 & 0 & 10000.1 & 0 \\ 0 & 0 & 1000 & 0 & 0 & 10000.1 \end{bmatrix} \begin{bmatrix} 1 & 0 & 0 \\ 0 & 1 & 0 \\ 0 & 0 & 1 \\ 0 & 0 & 0 \\ 0 & 0 & 0 \\ 0 & 0 & 0 \end{bmatrix} \begin{bmatrix} 10105.1 & 0 & 0 \\ 0 & 10105.1 & 0 \\ 0 & 0 & 10105.1 \end{bmatrix}^{-1} \newline
= \begin{bmatrix} 0.9999 & 0 & 0 \\ 0 & 0.9999 & 0 \\ 0 & 0 & 0.9999 \\ 0.0999 & 0 & 0 \\ 0 & 0.0999 & 0 \\ 0 & 0 & 0.0999 \end{bmatrix}
$$

```cpp
this->P = (Eigen::Matrix<float, 6, 6>::Identity() - this->K * this->H) * this->P_hat_t;
```

$$
P_t = (I - KH)\hat{P_t} = (I - K \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}) \hat{P_t} \newline
= \left( \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix} - \begin{bmatrix} 0.9999 & 0 & 0 \\ 0 & 0.9999 & 0 \\ 0 & 0 & 0.9999 \\ 0.0999 & 0 & 0 \\ 0 & 0.0999 & 0 \\ 0 & 0 & 0.0999 \end{bmatrix} \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}\right) \begin{bmatrix} 10100.1 & 0 & 0 & 1000 & 0 & 0 \\ 0 & 10100.1 & 0 & 0 & 1000 & 0 \\ 0 & 0 & 10100.1 & 0 & 0 & 1000 \\ 1000 & 0 & 0 & 10000.1 & 0 & 0 \\ 0 & 1000 & 0 & 0 & 10000.1 & 0 \\ 0 & 0 & 1000 & 0 & 0 & 10000.1 \end{bmatrix} \newline
= \begin{bmatrix} 4.9967 & 0 & 0 & 0.4947 & 0 & 0 \\ 0 & 4.9967 & 0 & 0 & 0.4947 & 0 \\ 0 & 0 & 4.9967 & 0 & 0 & 0.4947 \\ 0.4947 & 0 & 0 & 9901.14 & 0 & 0 \\ 0 & 0.4947 & 0 & 0 & 9901.14 & 0 \\ 0 & 0 & 0.4947 & 0 & 0 & 9901.14 \end{bmatrix}
$$

```cpp
this->X = this->X_hat_t + this->K * this->y_t;
```

$$
\begin{bmatrix} 0 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix} + \begin{bmatrix} 0.9999 & 0 & 0 \\ 0 & 0.9999 & 0 \\ 0 & 0 & 0.9999 \\ 0.0999 & 0 & 0 \\ 0 & 0.0999 & 0 \\ 0 & 0 & 0.0999 \end{bmatrix} \begin{bmatrix} 10 \\ 20 \\ 40 \end{bmatrix} \newline
= \begin{bmatrix} 9.999 \\ 19.998 \\ 39.996 \\ 0.999 \\ 1.998 \\ 3.996 \end{bmatrix}
$$

```cpp
dst[0] = this->X(0, 0); // 9.999
dst[1] = this->X(1, 0); // 19.998
dst[2] = this->X(2, 0); // 39.996
dst[3] = this->X(3, 0); // 0.999
dst[4] = this->X(4, 0); // 1.998
dst[5] = this->X(5, 0); // 3.996
```

$$
\begin{bmatrix} x \\ y \\ z \\ v_x \\ v_y \\ v_z \end{bmatrix} = \begin{bmatrix} 9.999 \\ 19.998 \\ 39.996 \\ 0.999 \\ 1.998 \\ 3.996 \end{bmatrix}
$$

Comparing to results from the kalman filter implementation in C++:

```cpp
Kalman Filter Result:
X: 9.99505
Y: 19.9901
Z: 39.9802
X Velocity: 0.989599
Y Velocity: 1.9792
Z Velocity: 3.9584
```

<br>
<br>

# Results
Comparing the results of our calculation to the results of the Kalman filter implementation in C++:

$$
\begin{bmatrix} x \\ y \\ z \\ v_x \\ v_y \\ v_z \end{bmatrix} = \overset{\text{Manual Calculation}}{\begin{bmatrix} 9.999 \\ 19.998 \\ 39.996 \\ 0.999 \\ 1.998 \\ 3.996 \end{bmatrix}} \approx \overset{\text{C++ Code}}{\begin{bmatrix} 9.99505 \\ 19.9901 \\ 39.9802 \\ 0.989599 \\ 1.9792 \\ 3.9584 \end{bmatrix}}
$$

Then checking the predicted velocity following our assumption of zero acceleration:

$$
\frac{10mm}{0.1s} = 100mm/s = \underset{\text{Kinematic}}{0.1m/s} \approx \underset{\text{C++ Code}}{0.989m/s}
$$

This indicates that our C++ code is working as expected, and is able to predict the position and velocity of our target robot.