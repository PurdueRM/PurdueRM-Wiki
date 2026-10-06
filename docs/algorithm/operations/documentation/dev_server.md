---
layout: default
title: Developer Server
nav_order: 6
parent: Alg Team Documentation
grand_parent: Algorithm
---

# Developer Server Hardware
The club owns a lot of NVIDIA Jetson Computing Boards. These are usually used to deploy the auto-aim and auto-navigation on our robots.

However, we also use the more powerful ones, like the Jetson Orin AGX, as development servers to deploy and compile our code on.

These Developer Servers are used by Algorithm and VIP members to do their projects like onboarding and specialized VIP projects.

## Current Hardware
- Jetson Orin AGX 32GB
  - Location: Mark Antonov's Apartment
  - This is our current main algorithm developer server
  - There is a script on it right now that creates the new algorithm onboarding accounts
  - Contact Mark Antonov and Tom O'Donnell for help with this server
- Jetson Orin AGX 64GB
  - Krach Cubicle 20
  - This is our VIP projects developer server
  - Setup via Tailscale sharing
  - Contact Andy Niu for help with this server
 
## Jetson Orin AGX 32GB Setup and Usage
This is left empty for Mark Antonov to fill out later

## Jetson Orin AGX 64GB Setup and Usage
This Dev Server is setup via [Tailscale Shared Machine](https://tailscale.com/docs/features/sharing)

### Setup
#### Setup of Tailscale
Install tailscale on the machine via:
```
curl -fsSL https://tailscale.com/install.sh | sh
```
Then run this to start up tailscale:
```
sudo tailscale up
```
Then login/authenticate the device:
```
sudo tailscale login
```
and follow the setup instructions
#### Disable key expiry
Login to the console, and make sure to disable the auto key expiry of the machine. Else you will need to reauthenticate every 180 days

#### Setup of User Account "system"
You can try to do a mail system, but IMO just have a bash script make the account for you and then do the emails manually.



### Usage
Go look at the [script](create_users.sh). It's uploaded here on the wiki
