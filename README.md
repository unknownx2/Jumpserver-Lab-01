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
