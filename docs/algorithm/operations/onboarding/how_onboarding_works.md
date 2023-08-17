---
layout: default
title: Get Started Here!
parent: Onboarding Process
grand_parent: Algorithm
nav_order: 1
---

### Overview:
This season, we have designed two project options for members to choose from. You must select and complete one of the following projects before the second meeting:
1.  **Computer Vision**: Detect the Earth in the famous Pale Blue Dot image
2. **SWE / ROS2**: Explore our code pipeline and write software to receive a message published by our robot

You should have already filled out the Google Form to join the team (if not, DM `@tomdonel`). Within 48 hours of filling out the form, you will receive an email with your login information to the development server.

***

### **To log onto the server**, follow these instructions:
If you are on MacOS or Linux:
- Open a terminal window and type: `ssh -XC <your_puid>@tx2.purduerm.org -p 10051`. 
- Enter your password (from email) an you will be placed into your home directory. Your starter code for onboarding is waiting for you!

If you are on Windows:
- Download PuTTY from https://www.putty.org.
- Download X410 server from https://www.x410.dev (free version).
- Under the "Connection" > "SSH" > "X11" settings, make sure the `Enable X11 forwarding` option is checked. Set `localhost:0:0` as the "X display location".
- For your login information:
	- Hostname: `tx2.purduerm.org`
	- Port: `10051`
	- Username/Password: see email
- Important: Save your login info with a name. It will preserve your settings for next time. 
- Hit connect, and you will be placed into your home directory. Your starter code for onboarding is waiting for you!
	
***

You should now get started on your onboarding project! Both projects have sufficient starter code + instructions, and there are further instructions in the ROS2 and CV sections of the Onboarding Process wiki page. Good luck!


