#!/bin/bash

set -e

EFI_DIR=${BINARIES_DIR}/efi-part/EFI/BOOT

# Set up the kernel executable according to the UEFI standard.
mkdir -p ${EFI_DIR}
ln -sf ${BINARIES_DIR}/Image ${EFI_DIR}/bootaa64.efi
