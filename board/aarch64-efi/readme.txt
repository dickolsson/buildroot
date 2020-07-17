
The aarch64_efi_defconfig allows to build a minimal Linux system that
can boot on all AArch64 servers providing an EFI firmware and ACPI.

Building and booting
====================

$ make aarch64_efi_defconfig
$ make

The file output/images/disk.img is a complete disk image that can be
booted, it includes the grub2 bootloader, Linux kernel and root
filesystem.

Testing under Qemu
==================

This image can also be tested using Qemu:

qemu-system-aarch64 \
	-M virt \
	-cpu cortex-a57 \
	-m 512 \
	-nographic \
	-drive file=output/images/QEMU_EFI_RESIZED.fd,if=pflash,format=raw \
	-drive file=output/images/QEMU_VARS_RESIZED.fd,if=pflash,format=raw \
	-drive file=output/images/disk.img,if=none,format=raw,id=hd0 \
	-device virtio-blk-device,drive=hd0 \
	-netdev user,id=eth0 \
	-device virtio-net-device,netdev=eth0

Note that output/images/QEMU_*.fd are the flash device files built by
the EDK2 package.
