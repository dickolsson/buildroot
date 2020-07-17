#!/bin/bash

BOARD_DIR="$(dirname $0)"

cp -f ${BOARD_DIR}/grub.cfg ${BINARIES_DIR}/efi-part/EFI/BOOT/grub.cfg

# The QEMU virt machine expects flash devices to be 64M.
truncate -s 64M "${BINARIES_DIR}/QEMU_EFI.fd"
truncate -s 64M "${BINARIES_DIR}/QEMU_VARS.fd"
