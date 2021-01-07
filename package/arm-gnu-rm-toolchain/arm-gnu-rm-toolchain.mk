################################################################################
#
# arm-gnu-rm-toolchain
#
################################################################################

ARM_GNU_RM_TOOLCHAIN_VERSION = 9-2019
ARM_GNU_RM_TOOLCHAIN_VERSION_QUARTER = q4
ARM_GNU_RM_TOOLCHAIN_VERSION_LABEL = major
# The version string is inconsistently constructed (i.e. both with and
# without dash between the year and quarter) which is why we need to
# split up the URL like this.
ARM_GNU_RM_TOOLCHAIN_SITE = https://developer.arm.com/-/media/Files/downloads/gnu-rm/$(ARM_GNU_RM_TOOLCHAIN_VERSION)$(ARM_GNU_RM_TOOLCHAIN_VERSION_QUARTER)/
ARM_GNU_RM_TOOLCHAIN_SOURCE = gcc-arm-none-eabi-$(ARM_GNU_RM_TOOLCHAIN_VERSION)-$(ARM_GNU_RM_TOOLCHAIN_VERSION_QUARTER)-$(ARM_GNU_RM_TOOLCHAIN_VERSION_LABEL)-$(HOSTARCH)-linux.tar.bz2
ARM_GNU_RM_TOOLCHAIN_LICENSE = GPL-3.0+

HOST_ARM_GNU_RM_TOOLCHAIN_INSTALL_DIR = $(HOST_DIR)/opt/gcc-arm-none-eabi

define HOST_ARM_GNU_RM_TOOLCHAIN_INSTALL_CMDS
	rm -rf $(HOST_ARM_GNU_RM_TOOLCHAIN_INSTALL_DIR)
	mkdir -p $(HOST_ARM_GNU_RM_TOOLCHAIN_INSTALL_DIR)
	cp -rf $(@D)/* $(HOST_ARM_GNU_RM_TOOLCHAIN_INSTALL_DIR)/

	mkdir -p $(HOST_DIR)/bin
	cd $(HOST_DIR)/bin && \
	for i in ../opt/gcc-arm-none-eabi/bin/*; do \
		ln -sf $$i; \
	done
endef

$(eval $(host-generic-package))
