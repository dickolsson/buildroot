Intro
=====

This is the board support for MacchiatoBin with a more modern firmware stack
compared to the original build with board/solidrun/macchiatobin.

The goal with this default configuration is to provide a build as close to
ARM Server Base Boot Requirement (SBBR) as possible. This gives us the
following benefits:

 - The firmware is built and flashed separately from the OS image
 - Therefore, the board will boot with any standard Aarch64 distribution image
 - UEFI provides a more standardized firmware interface

How to build
============

The default configuration provides the following stack:

 - ARM Trusted Firmware (mainline)
 - EDK2 UEFI firmware (mainline)
 - Linux 5.9 (mainline)

    $ make solidrun_macchiatobin_efi_defconfig
    $ make

The next step will depend on whether you have U-Boot or UEFI flashed on the
board.

How to flash the firmware from U-Boot
=====================================

In this example we will assume that the board has U-Boot flashed on it. We will
flash the new UEFI firmware from the U-Boot console to the SPI flash, using
the "bubt" (Burn ATF) command.

Once the build process is finished you will have an image called
"flash-image.bin" in the output/images/ directory.

First, format a USB drive with an EXT4 partition and copy the "flash-image.bin"
file onto the USB drive.

Second, attach to the serial console[1], insert the USB drive into the board,
boot the board and enter the U-Boot console. On the U-Boot console enter the
following commands:

    usb start
    bubt flash-image.bin spi usb

Lastly, unplug the USB drive and reboot the board. The board will now
boot with the newly flashed UEFI firmware.

How to flash the firmware from UEFI
===================================

In this example we will assume that the board has UEFI flashed on it. We will
flash the new UEFI firmware from the old UEFI console to the SPI flash, using
the "fupdate" command.

First, format a USB drive with an FAT partition and copy the "flash-image.bin"
file onto the USB drive.

Second, attach to the serial console[1], insert the USB drive into the board,
boot the board and enter the UEFI shell. In the UEFI shell, find what file
system your USB drive got mapped to by using the "map" and "ls" commands.
Then enter this command (assuming your USB drive is on "FS0"):

    fupdate FS0:\flash-image.bin spi

Lastly, unplug the USB drive and reboot the board. The board will now
boot with the newly flashed UEFI firmware.

How to write the SD card
========================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory. This image only contains the Linux kernel and
the rest of the operating system.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX bs=1M conv=fsync
  $ sudo sync

Plug in the SD card into the board and boot.

Note that because the board is now using UEFI firmware, the board will also
boot any other standard Aarch64 distribution image.

[1]: http://wiki.espressobin.net/tiki-index.php?page=Quick+User+Guide
