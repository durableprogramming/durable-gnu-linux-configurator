#!/bin/bash

# Set error handling options
set -e

# Welcome message using the ASCII art
source ./ascii.sh

echo "=> Creating Virtual Machine Environment for DugNiLiCo..."
echo -e "\nThis will set up a virtual environment for testing the Durable GNU-Linux Configurator."

# Check for dependencies
echo "Checking for dependencies..."
if ! command -v virt-manager &> /dev/null || ! command -v qemu-system-x86_64 &> /dev/null; then
    echo "Installing required virtualization packages..."
    sudo apt-get update
    sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
fi

# Download latest Ubuntu ISO if needed
UBUNTU_VERSION="24.04"
ISO_NAME="ubuntu-${UBUNTU_VERSION}-desktop-amd64.iso"
ISO_PATH="./build/${ISO_NAME}"

if [ ! -f "$ISO_PATH" ]; then
    echo "Downloading Ubuntu ${UBUNTU_VERSION} ISO..."
    mkdir -p ./build
    wget -O "$ISO_PATH" "https://releases.ubuntu.com/${UBUNTU_VERSION}/${ISO_NAME}"
fi

# Create virtual machine
VM_NAME="dugnlico_test"
VM_DISK="./build/${VM_NAME}.qcow2"

echo "Creating virtual machine disk..."
if [ ! -f "$VM_DISK" ]; then
    qemu-img create -f qcow2 "$VM_DISK" 20G
fi

echo "Setting up virtual machine..."
virt-install \
    --name "$VM_NAME" \
    --memory 4096 \
    --vcpus 2 \
    --disk "$VM_DISK",format=qcow2 \
    --cdrom "$ISO_PATH" \
    --os-variant ubuntu24.04 \
    --graphics spice \
    --network default \
    --boot uefi \
    --console pty,target_type=serial

echo "Virtual machine setup complete!"
echo "After installing Ubuntu, run the following command in the VM to test DugNiLiCo:"
echo "curl -fsSL https://raw.githubusercontent.com/durableprogramming/durable-gnu-linux-configurator/master/boot.sh | bash"
