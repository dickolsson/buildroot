#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
EFI_DIR=${BINARIES_DIR}/efi-part/EFI/BOOT

# Set up the kernel executable according to the UEFI standard.
mkdir -p ${EFI_DIR}
ln -sf ${BINARIES_DIR}/Image ${EFI_DIR}/bootaa64.efi

function resize_flash {
  dd if=/dev/zero of="${BINARIES_DIR}/${2}" bs=1M count=256
  dd if="${BINARIES_DIR}/${1}" of="${BINARIES_DIR}/${2}" conv=notrunc
}

resize_flash "SBSA_FLASH0.fd" "SBSA_FLASH0_RESIZED.fd"
resize_flash "SBSA_FLASH1.fd" "SBSA_FLASH1_RESIZED.fd"
