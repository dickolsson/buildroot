Pinebook Pro
============
https://www.pine64.org/pinebook-pro/

Build:
======
  $ make pinebook_pro_defconfig
  $ make

Write U-Boot to SPI flash
=========================

TODO

Creating bootable SD card:
==========================

Simply invoke (as root)

sudo dd if=output/images/sdcard.img of=/dev/sdX && sync

Where X is your SD card device.

