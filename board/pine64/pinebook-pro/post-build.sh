#!/bin/bash

BOARD_DIR="$(dirname $0)"
MKIMAGE=${HOST_DIR}/bin/mkimage

${MKIMAGE} \
	-n rk3399 \
	-T rkspi \
	-d ${BINARIES_DIR}/u-boot-tpl-dtb.bin:${BINARIES_DIR}/u-boot-spl-dtb.bin \
	${BINARIES_DIR}/idbloader_spi.img

cat <(dd if=${BINARIES_DIR}/idbloader_spi.img bs=512K conv=sync) ${BINARIES_DIR}/u-boot.itb > ${BINARIES_DIR}/spi_flash.bin

