#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
EFI_DIR=${BINARIES_DIR}/efi-part/EFI/BOOT

# Set up the kernel executable according to the UEFI standard.
mkdir -p ${EFI_DIR}
ln -sf ${BINARIES_DIR}/Image ${EFI_DIR}/bootaa64.efi

# Function taking file $1 as input and outputs file $2 padded to size $3.
function resize_flash {
  dd if=/dev/zero of="${BINARIES_DIR}/${2}" bs=1M count="${3}"
  dd if="${BINARIES_DIR}/${1}" of="${BINARIES_DIR}/${2}" conv=notrunc
}

# The QEMU virt machine expects flash devices to be 64M.
resize_flash bl1.bin bl1_resized.bin 64
resize_flash fip.bin fip_resized.bin 64
