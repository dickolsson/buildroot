Intro
=====

The System Guidance Infrastructure 575 is a Fixed Virtual Platform (FVP)
provided by ARM. It's used as a reference implementation for ARM server
systems to develop and test firmware and operating systems.

The "FVP_CSS_SGI-575" program is free to download and is required in order to
use this configuration. Refer to the ARM Developer portal for information:

https://developer.arm.com/tools-and-software/simulation-models/fixed-virtual-platforms

How to build
============

The default configuration provides the following stack:

 - ARM Trusted Firmware (mainline)
 - EDK2 UEFI firmware (mainline)
 - Linux 5.9 (mainline)

    $ make arm_sgi575_defconfig
    $ make

How to boot
===========

The below command assumes that the "FVP_CSS_SGI-575" program has been installed
in your $PATH.

FVP_CSS_SGI-575 \
	--disable-analytics \
	--data css.scp.armcortexm7ct="output/images/scp_ramfw.bin@0x0BD80000" \
	-C css.scp.ROMloader.fname="output/images/mcp_romfw.bin" \
	-C css.scp.ROMloader.fname="output/images/scp_romfw.bin" \
	-C css.trustedBootROMloader.fname="output/images/bl1.bin" \
	-C board.flashloader0.fname="output/images/fip.bin" \
	-C board.flashloader1.fname="output/images/nor_flash1.bin" \
	-C board.flashloader1.fnameWrite="output/images/nor_flash1.bin" \
	-C board.flashloader2.fname="output/images/nor_flash2.bin" \
	-C board.flashloader2.fnameWrite="output/images/nor_flash2.bin" \
	-C board.virtioblockdevice.image_path="output/images/disk.img"
