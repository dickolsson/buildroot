#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
EFI_DIR=${BINARIES_DIR}/efi-part/EFI/BOOT

# Set up the kernel executable according to the UEFI standard.
mkdir -p ${EFI_DIR}
ln -sf ${BINARIES_DIR}/Image ${EFI_DIR}/bootaa64.efi

# The QEMU virt machine expects the BIOS flash device to be 64M.
rm -rf ${BINARIES_DIR}/flash.bin
dd if=${BINARIES_DIR}/bl1.bin of=${BINARIES_DIR}/flash.bin bs=4096 conv=notrunc
dd if=${BINARIES_DIR}/fip.bin of=${BINARIES_DIR}/flash.bin seek=64 bs=4096 conv=notrunc
