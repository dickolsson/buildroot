#!/bin/bash

BOARD_DIR="$(dirname $0)"

cp -f ${BOARD_DIR}/grub.cfg ${BINARIES_DIR}/efi-part/EFI/BOOT/grub.cfg

# Function taking file $1 as input and outputs file $2 padded to size $3.
function resize_flash {
  dd if=/dev/zero of="${BINARIES_DIR}/${2}" bs=1M count="${3}"
  dd if="${BINARIES_DIR}/${1}" of="${BINARIES_DIR}/${2}" conv=notrunc
}

# The QEMU virt machine expects flash devices to be 64M.
resize_flash QEMU_EFI.fd QEMU_EFI_RESIZED.fd 64
resize_flash QEMU_VARS.fd QEMU_VARS_RESIZED.fd 64
