# Jumpserver Lab on Parrot OS

A cybersecurity lab project to run a jumpserver VM on Parrot OS using VirtualBox, overcoming the `VERR_VMX_IN_VMX_ROOT_MODE` error with a custom Bash script.

## Overview
This project started as a way to build hands-on Linux and virtualization skills for my CompTIA Security+ prep and cybersecurity job hunt. I set up a VirtualBox VM on my Parrot OS ThinkCentre (16GB RAM, 500GB HDD), but hit a snag: VirtualBox wouldn’t start my jumpserver VM due to a conflict with KVM modules. After troubleshooting, I crafted a script to automate the fix and began configuring the VM as a jumpserver for pen testing practice.

## Problem
- **Error**: `VirtualBox can't operate in VMX root mode. Please disable the KVM kernel extension... (VERR_VMX_IN_VMX_ROOT_MODE)`.
- **Cause**: KVM modules (`kvm`, `kvm_intel`) locked the CPU’s VT-x virtualization, clashing with VirtualBox’s `vboxdrv`.

## Solution
- **Manual Fix**: Ran these commands one by one in the terminal:
  ```bash
  sudo rmmod kvm_intel
  sudo rmmod kvm
  sudo modprobe vboxdrv
Worked but reset on reboot.
Automated Fix: Created load_vbox_modules.sh:
bash

#!/bin/bash
TEMP_FILE="$HOME/vbox_load_status"
pkexec /bin/bash -c "
  rmmod kvm_intel && rmmod kvm && modprobe vboxdrv &&
  echo 'VirtualBox driver loaded successfully! KVM modules unloaded.' > $TEMP_FILE ||
  echo 'Failed to unload KVM or load VirtualBox - check logs.' > $TEMP_FILE
  chown $USER:$USER $TEMP_FILE
"
if [ -f "$TEMP_FILE" ]; then
  cat "$TEMP_FILE"
  rm "$TEMP_FILE"
else
  echo "Script execution failed - check pkexec or permissions."
fi
Double-clicking this script unloads KVM and loads VirtualBox modules, making the VM runnable post-reboot.
Jumpserver Setup
VM Specs: 10GB dynamic disk, 4096 MB RAM, Bridged Adapter.
Progress:
Installed Ubuntu 24.04.2 LTS.
Named it "jumpserver" by adding 127.0.0.1 jumpserver to /etc/hosts (hit a nano typing glitch, fixed with echo).
Set hostname: sudo hostnamectl set-hostname jumpserver.
Next: Installing SSH server (openssh-server) and pen testing tools (e.g., Nmap, Metasploit).
Goals
Build a secure jumpserver for cybersecurity labs.
Document troubleshooting and scripting skills for my portfolio.
Prep for Security+ topics like network security and threat detection.
Next Steps
Test SSH access from host: ssh user@jumpserver-ip.
Add tools and firewall (UFW).
Make VirtualBox fix persistent (blacklist KVM, auto-load vboxdrv).
Files
`load_vbox_modules.sh` (load_vbox_modules.sh): Script to fix VirtualBox.
Last Updated: March 2025
