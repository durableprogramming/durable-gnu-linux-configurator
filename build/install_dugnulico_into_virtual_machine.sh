#!/bin/bash

# Set error handling options
set -e

# Welcome message
echo "=> Installing DugNiLiCo into Virtual Machine..."
echo -e "\nThis will create a copy of the test VM and install Durable GNU-Linux Configurator into it."

# Check for dependencies
echo "Checking for dependencies..."
if ! command -v virt-customize &> /dev/null; then
    echo "Installing required libguestfs tools..."
    sudo apt-get update
    sudo apt-get install -y libguestfs-tools
fi

# Define VM names and paths
SOURCE_VM_NAME="dugnlico_test"
TARGET_VM_NAME="dugnlico_installed"
DISK_PATH="./build/${TARGET_VM_NAME}.qcow2"

# Check if source VM exists
if ! virsh dominfo "$SOURCE_VM_NAME" &> /dev/null; then
    echo "Source VM '$SOURCE_VM_NAME' not found. Please run init_virtual_machine.sh first."
    exit 1
fi

# Ensure source VM is shut down
if [ "$(virsh domstate $SOURCE_VM_NAME)" != "shut off" ]; then
    echo "Shutting down source VM..."
    virsh shutdown "$SOURCE_VM_NAME"
    # Wait for VM to shut down (timeout after 60 seconds)
    for i in {1..60}; do
        if [ "$(virsh domstate $SOURCE_VM_NAME)" == "shut off" ]; then
            break
        fi
        sleep 1
    done
    
    if [ "$(virsh domstate $SOURCE_VM_NAME)" != "shut off" ]; then
        echo "Force stopping VM..."
        virsh destroy "$SOURCE_VM_NAME"
    fi
fi

# Create a copy of the VM disk
echo "Creating a copy of the VM disk..."
if [ -f "$DISK_PATH" ]; then
    echo "Target disk already exists. Removing..."
    rm -f "$DISK_PATH"
fi

cp "./build/${SOURCE_VM_NAME}.qcow2" "$DISK_PATH"

# Use virt-customize to install DugNiLiCo
echo "Installing DugNiLiCo into the VM..."
virt-customize -a "$DISK_PATH" \
    --run-command 'curl -fsSL https://raw.githubusercontent.com/durableprogramming/durable-gnu-linux-configurator/master/boot.sh -o /tmp/boot.sh' \
    --run-command 'chmod +x /tmp/boot.sh' \
    --firstboot-command 'su - $(getent passwd 1000 | cut -d: -f1) -c "DISPLAY=:0 gnome-terminal -- bash -c \"bash /tmp/boot.sh; exec bash\""'

# Create a new VM using the modified disk
echo "Creating new VM with DugNiLiCo installed..."
if virsh dominfo "$TARGET_VM_NAME" &> /dev/null; then
    echo "Target VM already exists. Removing..."
    virsh undefine "$TARGET_VM_NAME" --remove-all-storage
fi

virt-install \
    --name "$TARGET_VM_NAME" \
    --memory 4096 \
    --vcpus 2 \
    --disk "$DISK_PATH",format=qcow2 \
    --import \
    --os-variant ubuntu24.04 \
    --graphics spice \
    --network default \
    --boot uefi \
    --noautoconsole

echo "Installation complete! VM '$TARGET_VM_NAME' has been created with DugNiLiCo installed."
echo "The installation will start automatically on first boot."
echo "To start the VM, run: virsh start $TARGET_VM_NAME"
echo "To connect to the VM, run: virt-viewer $TARGET_VM_NAME"

