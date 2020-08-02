Intro
=====

This board allows to build a minimal Linux system that boot directly
with Arm Trusted Firmware, EDK2 (UEFI), ACPI and GICv3 without any
additional bootloaders like GRUB2.

Build
=====

  $ make qemu_aarch64_virt_efi_defconfig
  $ make

Emulation
=========

Run the emulation with:

  output/host/bin/qemu-system-aarch64 \
    -M virt,secure=on,gic-version=3 \
    -cpu cortex-a57 \
    -smp 4 \
    -m 1024 \
    -nographic \
    -drive file=output/images/bl1_resized.bin,if=pflash,format=raw \
    -drive file=output/images/fip_resized.bin,if=pflash,format=raw \
	-drive file=output/images/disk.img,if=none,format=raw,id=hd0 \
	-device virtio-blk-device,drive=hd0
