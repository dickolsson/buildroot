################################################################################
#
# arm-scp-firmware
#
################################################################################

ARM_SCP_FIRMWARE_VERSION = 4d81f267bc163a3a14580bca038dec75d6f95305
ARM_SCP_FIRMWARE_SITE = $(call github,ARM-software,SCP-firmware,$(ARM_SCP_FIRMWARE_VERSION))
ARM_SCP_FIRMWARE_LICENSE = BSD-3-Clause
ARM_SCP_FIRMWARE_LICENSE_FILES = licence.md
ARM_SCP_FIRMWARE_INSTALL_IMAGES = YES
ARM_SCP_FIRMWARE_DEPENDENCIES = host-cmsis

# The System Control Processor (SCP) on ARM platforms is a 32-bit
# Cortex M or Cortex R processor which requires its firmware to be built
# with the GNU Arm Embedded Toolchain. Therefore, we use this pre-built
# toolchain (as a host package) since it's most likely a different
# architecture compared to the toolchain targeting the main processor.
ARM_SCP_FIRMWARE_DEPENDENCIES += host-arm-gnu-rm-toolchain

ARM_SCP_FIRMWARE_PRODUCT = $(call qstrip,$(BR2_TARGET_ARM_SCP_FIRMWARE_PRODUCT))
ARM_SCP_FIRMWARE_MAKE_OPTS = \
	CMSIS_DIR="$(HOST_DIR)/share/cmsis/CMSIS/Core" \
	OS_DIR="$(HOST_DIR)/share/cmsis/CMSIS/RTOS2" \
	CC="$(HOST_DIR)/bin/arm-none-eabi-gcc" \
	PRODUCT="$(ARM_SCP_FIRMWARE_PRODUCT)"

define ARM_SCP_FIRMWARE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(ARM_SCP_FIRMWARE_MAKE_OPTS)
endef

ARM_SCP_FIRMWARE_BINS = \
	$(@D)/build/product/$(ARM_SCP_FIRMWARE_PRODUCT)/mcp_romfw/release/bin/mcp_romfw.bin \
	$(@D)/build/product/$(ARM_SCP_FIRMWARE_PRODUCT)/scp_ramfw/release/bin/scp_ramfw.bin \
	$(@D)/build/product/$(ARM_SCP_FIRMWARE_PRODUCT)/scp_romfw/release/bin/scp_romfw.bin

define ARM_SCP_FIRMWARE_INSTALL_IMAGES_CMDS
	$(foreach f,$(ARM_SCP_FIRMWARE_BINS), \
		if [ -f "$(f)" ]; then \
			cp $(f) $(BINARIES_DIR)/; \
		fi;)
endef

$(eval $(generic-package))
