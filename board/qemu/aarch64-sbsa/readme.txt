Intro
=====

The QEMU sbsa-ref machine is primarily meant for firmware development and
testing. Thus, the Linux kernel is not necessarily meant to boot to userland.

A successful boot should be considered:

1. ARM Trusted Firmware (ATF) boots until BL31
2. ATF loads EDK2 (UEFI) as BL33
3. EDK2 loads the Linux kernel in EFI stub mode
4. Linux begins to boot, exits boot services, begins loading the address map
5. Freeze

Build
=====

  $ make qemu_aarch64_sbsa_defconfig
  $ make

Emulation
=========

Run the emulation with:

  output/host/bin/qemu-system-aarch64 \
    -M sbsa-ref \
    -cpu cortex-a57 \
    -smp 4 \
    -m 1024 \
    -nographic \
    -drive file=output/images/SBSA_FLASH0_RESIZED.fd,if=pflash,format=raw \
    -drive file=output/images/SBSA_FLASH1_RESIZED.fd,if=pflash,format=raw \
    -hda output/images/disk.img
