The aarch64-sbsa board is generic and will work for platforms that are
compliant with the Server Base System Architecture (SBSA) specification.
An SBSA platform will need configuration that build firmware compliant with
the Server Base Boot Requirement (SBBR) specification.

This SBSA board expect SBBR firmware to be packaged in two binaries:

1. secureflash.bin: The BL1 stage that will be loaded into secure memory
2. flash0.bin: Remaining firmware image packages loaded into non-secure memory

The following configurations currently provide SBBR firmware:

- qemu_aarch64_sbsa_sbbr_defconfig: An implementation of SBBR for QEMU SBSA
- qemu_aarch64_virt_sbbr_defconfig: An implementation of SBBR for QEMU Virt

Building and booting under QEMU SBSA
====================================

$ make qemu_aarch64_sbsa_sbbr_defconfig
$ make
$ qemu-system-aarch64 \
	-M sbsa-ref \
	-cpu cortex-a57 \
	-smp 4 \
	-m 1024 \
	-nographic \
	-drive file=output/images/secureflash.bin,if=pflash,format=raw \
	-drive file=output/images/flash0.bin,if=pflash,format=raw \
	-hda output/images/disk.img

Building and booting under QEMU Virt
====================================

$ make qemu_aarch64_virt_sbbr_defconfig
$ make
$ qemu-system-aarch64 \
	-M virt,secure=on,gic-version=3 \
	-cpu cortex-a57 \
	-smp 4 \
	-m 1024 \
	-nographic \
	-drive file=output/images/secureflash.bin,if=pflash,format=raw \
	-drive file=output/images/flash0.bin,if=pflash,format=raw \
	-drive file=output/images/disk.img,if=none,format=raw,id=hd0 \
	-device virtio-blk-device,drive=hd0
