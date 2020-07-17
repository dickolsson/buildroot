#!/bin/bash

BOARD_DIR="$(dirname $0)"
EFI_DIR=${BINARIES_DIR}/efi-part/EFI/BOOT

# Set up the kernel executable according to the UEFI standard.
mkdir -p ${EFI_DIR} && \
ln -sf ${BINARIES_DIR}/Image ${EFI_DIR}/bootaa64.efi

function resize_or_link_flash {
  if [ -n "${3}" ]; then
    dd if=/dev/zero of="${BINARIES_DIR}/${2}" bs=1M count=${3} && \
    dd if="${BINARIES_DIR}/${1}" of="${BINARIES_DIR}/${2}" conv=notrunc || exit 1
  else
    ln -srf "${BINARIES_DIR}/${1}" "${BINARIES_DIR}/${2}" || exit 1
  fi
}

if grep -Eq "^BR2_TARGET_ARM_TRUSTED_FIRMWARE_PLATFORM=\"qemu_sbsa\"$" ${BR2_CONFIG}; then
  resize_or_link_flash "SBSA_FLASH0.fd" "secureflash.bin" "256"
  resize_or_link_flash "SBSA_FLASH1.fd" "flash0.bin" "256"

elif grep -Eq "^BR2_TARGET_ARM_TRUSTED_FIRMWARE_PLATFORM=\"qemu\"$" ${BR2_CONFIG}; then
  resize_or_link_flash "bl1.bin" "secureflash.bin" "64"
  resize_or_link_flash "fip.bin" "flash0.bin" "64"
fi
