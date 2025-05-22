---
layout: default
title: Flashing an Orin
parent: Alg Team Documentation
grand_parent: Algorithm
nav_order: 5
---

# Starting the Navigation Stack
### By Tom O'Donnell


**Beware unwary traveler,** for the flashing of an Orin is a treacherous journey fraught with peril. The path is littered with the bones of those who have attempted to flash their Orins without proper preparation. The flashing process is a dark and mysterious ritual that requires great skill and knowledge, a dark rite, whispering secrets only understood by those fluent in BSPs, device trees, and carrier boards. Many have been lost in the depths of the flashing process, never to return. The flashing process is not for the faint of heart, and only the bravest souls dare to attempt it. If you are not prepared to face the horrors of the flashing process, turn back now and seek the guidance of a seasoned Orin flasher. But if you are ready to embark on this perilous journey, read on and prepare yourself.

## Prerequisites
- A computer ("host") with a Linux operating system (Ubuntu 20.04 REQUIRED for Jetpack 5.1, Ubuntu 22.04 REQUIRED for Jetpack 6.x)
- A USB-C to USB-A cable to connect the Orin to the host (ideally the one that came with the Orin, otherwise it must be a data cable)
- NVIDIA's SDK Manager installed on the computer
- The Orin's power supply

*NOTE: The flashing process will differ depending on the carrier board used. The official NVIDIA Carrier board can just use the standard instructions in SDK Manager. The DaMiao carrier may also work with the standard instructions, but may have a separate flashing script (I forgot). The ConnectTech carriers definitely have a different flashing process.*

## Flashing a ConnectTech Orin
1. **Follow [this guide](https://connecttech.com/resource-center/kdb373/)** through step 11. This will have you download the JetPack OS Image, and install the ConnectTech BSP into the Image (BSP = Board Support Package, a collection of drivers allowing the OS to communicate with the carrier board).
2. **Install Prerequisites**. This *may not be required* for some boards, but the flash succeeded when I did this:
   1. `cd` into the `Linux_for_Tegra` folder inside the JetPack OS Image folder.
   2. `sudo ./apply_binaries.sh`
   3. `sudo ./tools/l4t_flash_prerequisites.sh`
   4. To save a headache, set a username and password for the Orin to whatever you'd like: `sudo ./tools/l4t_create_default_user.sh -u <username> -p <password>`. 
3. **Flash the Orin**. This part always took a million tries for me. 
   1. Connect the Orin to the host computer using the USB-C to USB-A cable. Power on the Orin.
   2. Put the Orin into recovery mode by holding the recovery button on the carrier board for 5 seconds, then pressing the RESET button on the carrier board. The Orin should now be in recovery mode.
   3. Verify that the Orin is in recovery mode by running the command `lsusb` in a terminal on the host computer. You should see a device with the name "NVIDIA Corp.". 
   4. Inside the `Linux_for_Tegra` folder, run the command `sudo ./cti-nvme-flash.sh cti/orin-nx/boson-orin/base` to flash the Orin. This assumes you are using Boson Carrier (NGX007). A different carrier may require a different path, like `cti/orin-nx/boson22-orin/base` or something. 
4. **Logging in to the Orin**. After the flashing process is complete, SSH is usually NOT enabled by default. To enable SSH, you must first log in to the Orin using a monitor and keyboard. After logging in, run the command `sudo systemctl enable ssh` to enable SSH. You can now SSH into the Orin using the command `ssh <username>@<orin_ip_address>`. 

## Debugging Common Headaches
- **Orin not entering recovery mode**: Make sure you are holding the recovery button for 5 seconds before pressing the reset button. If this doesn't work, try using a different USB-C to USB-A cable. 
- **Something about "you may be in USB timeout"**: Try a different USB-C to USB-A cable, or try a different USB port on the host computer. Or do the infamous process below and try flashing again. All times I got this error I just tried a different cable/port/entered recovery mode again and it worked eventually.
  - Unplug the Orin from the host computer.
  - Unplug the USB-C cable from the Orin.
  - Re-enter recovery mode by holding the recovery button for 5 seconds, then pressing the reset button.
  - Plug the USB-C cable back into the Orin.
  - Plug the Orin back into the host computer.
- **Flash completes, I see NVIDIA logo but then it complains about some boot issue and shuts off**. Devious issue, I re-flashed after trying the "Prerequisites" step above, and modified the flash command to what I have listed, and it worked. So try a different flash command perhaps if you are not using NGX007 carrier.

## Cool Orin Tips and Tricks
- **Enable max performance mode**: This is a must for the Orin to run at full power. To enable max performance mode, run the command `sudo nvpmodel -m 0` in a terminal on the Orin. This will set the Orin to max performance mode. You can check the current power mode by running the command `sudo nvpmodel -q` in a terminal on the Orin. Also, `sudo jetson_clocks --fan` will put clocks at max and set the fans to 100%. I usually put this command as a startup script so it runs every time the Orin boots up.