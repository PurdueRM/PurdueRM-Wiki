---
layout: default
title: Kalman Filter for Vision
parent: Alg Team Documentation
grand_parent: Algorithm
nav_order: 3
---

# Kalman Filter for Vision

- X is 6x1 state vector
- A is the state transition matrix, init to identity
- H is 3x6 observation model matrix defining how state vector relates to measurement. init as 
$$\begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}$$
- Q is process noise covariance, diag matrix of q0 which is initial process noise covariance (0.1)
- R is measurement covariance matrix, initialized to r (which is 5), initial measurement noise covariance
- X_t_measure is a matrix of the values measured from our sensors, in this case xyz position from tvec
- z is measurement at time t

In constructor we reset, so:
- X is now 6x1 column vector of 
$$\begin{bmatrix} x_0 \\ y_0 \\ z_0 \\ v_{x_0} \\ v_{y_0} \\ v_{z_0} \end{bmatrix} = \begin{bmatrix} 0 \\ 0 \\ 0 \\ 0 \\ 0 \\ 0 \end{bmatrix}
$$
- P is 6x6 joint covariance a diagonal matrix of p0 (originally 1) and is the covariance matrix of the state estimation: 
$$\begin{bmatrix} p_0 & 0 & 0 & 0 & 0 & 0 \\ 0 & p_0 & 0 & 0 & 0 & 0 \\ 0 & 0 & p_0 & 0 & 0 & 0 \\ 0 & 0 & 0 & p_0 & 0 & 0 \\ 0 & 0 & 0 & 0 & p_0 & 0 \\ 0 & 0 & 0 & 0 & 0 & p_0 \end{bmatrix} = \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}
$$

From solvepnp we then call the update function.

- X_t_measure = 
$$
\begin{bmatrix} x \\ y \\ z \end{bmatrix}
$$
- A (state transition matrix) = 
$$
\begin{bmatrix} 1 & 0 & 0 & dt & 0 & 0 \\ 0 & 1 & 0 & 0 & dt & 0 \\ 0 & 0 & 1 & 0 & 0 & dt \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}
$$
- X_hat_t (our BEST guess at time t) = 
$$
\begin{bmatrix} x_0 + dt*vx \\ y_0 + dt*vy \\ z_0 + dt*vz \\ vx \\ vy \\ vz \end{bmatrix}
$$
- P_hat_t (covariance matrix of X) = 
$$
APA^T + Q = \begin{bmatrix} 1 & 0 & 0 & dt & 0 & 0 \\ 0 & 1 & 0 & 0 & dt & 0 \\ 0 & 0 & 1 & 0 & 0 & dt \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix} * \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \\ dt & 0 & 0 & 1 & 0 & 0 \\ 0 & dt & 0 & 0 & 1 & 0 \\ 0 & 0 & dt & 0 & 0 & 1 \end{bmatrix} \begin{bmatrix} 1 & 0 & 0 & dt & 0 & 0 \\ 0 & 1 & 0 & 0 & dt & 0 \\ 0 & 0 & 1 & 0 & 0 & dt \\ 0 & 0 & 0 & 1 & 0 & 0 \\ 0 & 0 & 0 & 0 & 1 & 0 \\ 0 & 0 & 0 & 0 & 0 & 1 \end{bmatrix}^T + \begin{bmatrix} q_0 & 0 & 0 & 0 & 0 & 0 \\ 0 & q_0 & 0 & 0 & 0 & 0 \\ 0 & 0 & q_0 & 0 & 0 & 0 \\ 0 & 0 & 0 & q_0 & 0 & 0 \\ 0 & 0 & 0 & 0 & q_0 & 0 \\ 0 & 0 & 0 & 0 & 0 & q_0 \end{bmatrix}
$$
- z_t (measurement at time t) = 
$$
\begin{bmatrix} 1 & 0 & 0 \\ 0 & 1 & 0 \\ 0 & 0 & 1 \end{bmatrix} * \begin{bmatrix} x \\ y \\ z \end{bmatrix} = \begin{bmatrix} x \\ y \\ z \end{bmatrix}
$$
- y_t (innovation of measurement, aka diff between a priori prediction and measurement) = 
$$
z_t - HX_t = \begin{bmatrix} x \\ y \\ z \end{bmatrix} - \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix} * \begin{bmatrix} dt*v_x \\ dt*v_y \\ dt*v_z \\ 0 \\ 0 \\ 0 \end{bmatrix} = \begin{bmatrix} x - dt*v_x \\ y - dt*v_y \\ z - dt*v_z \end{bmatrix}
$$ 
aka reduce X_hat_t to a 3x1 vector and subtract from z_t
- s_t (innovation of covariance) = 
$$
H\hat{P_t}H^T + R = \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix} \hat{P_t} \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}^T + \begin{bmatrix} r & 0 & 0 \\ 0 & r & 0 \\ 0 & 0 & r \end{bmatrix}
$$
- K (kalman gain) = 
$$
\hat{P_t}H^TS_t^{-1} = \hat{P_t} \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}^T S_t^{-1}
$$
- P_t (covariance matrix of X) gets updated = 
$$
(I - KH)\hat{P_t} = (I - K \begin{bmatrix} 1 & 0 & 0 & 0 & 0 & 0 \\ 0 & 1 & 0 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & 0 & 0 \end{bmatrix}) \hat{P_t}
$$
- X (state vector) gets updated =
$$
\hat{X_t} + K(y_t) = \begin{bmatrix} x_0 + dt*v_x \\ y_0 + dt*v_y \\ z_0 + dt*v_z \\ v_x \\ v_y \\ v_z \end{bmatrix} + K \begin{bmatrix} x - dt*v_x \\ y - dt*v_y \\ z - dt*v_z \end{bmatrix} = \text{Measurement Prediction} + \text{Kalman Gain} * \text{Innovation of Measurement} = \begin{bmatrix} x_0 + dt*v_x + K(x - dt*v_x) \\ y_0 + dt*v_y + K(y - dt*v_y) \\ z_0 + dt*v_z + K(z - dt*v_z) \\ v_x + K(x - dt*v_x) \\ v_y + K(y - dt*v_y) \\ v_z + K(z - dt*v_z) \end{bmatrix}
$$

Then we can extract our position and velocity from X, our updated state vector:
```cpp
dst[0] = this->X(0, 0); // predicted x
dst[1] = this->X(1, 0); // predicted y
dst[2] = this->X(2, 0); // predicted z
dst[3] = this->X(3, 0); // predicted vx
dst[4] = this->X(4, 0); // predicted vy
dst[5] = this->X(5, 0); // predicted vz
```