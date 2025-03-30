#!/bin/bash

TEMP_FILE="$HOME/vbox_load_status"

# Unload KVM and load VirtualBox with pkexec
pkexec /bin/bash -c "
  rmmod kvm_intel && rmmod kvm && modprobe vboxdrv &&
  echo 'VirtualBox driver loaded successfully! KVM modules unloaded.' > $TEMP_FILE ||
  echo 'Failed to unload KVM or load VirtualBox - check logs.' > $TEMP_FILE
  chown $USER:$USER $TEMP_FILE
"

# Display output
if [ -f "$TEMP_FILE" ]; then
  cat "$TEMP_FILE"
  rm "$TEMP_FILE"
else
  echo "Script execution failed - check pkexec or permissions."
fi
