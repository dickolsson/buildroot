################################################################################
#
# edk2-platforms
#
################################################################################

EDK2_PLATFORMS_VERSION = f8958b86e8863432b815a132a0f0fe82950c6dd1
EDK2_PLATFORMS_SITE = $(call github,tianocore,edk2-platforms,$(EDK2_PLATFORMS_VERSION))
EDK2_PLATFORMS_LICENSE = BSD-2-Clause
EDK2_PLATFORMS_LICENSE_FILE = License.txt
EDK2_PLATFORMS_INSTALL_TARGET = NO
EDK2_PLATFORMS_INSTALL_STAGING = YES

# There is nothing to build for edk2-platforms. All we need to do is to copy
# all description files to staging, for other packages to build with.
define EDK2_PLATFORMS_INSTALL_STAGING_CMDS
	rm -rf $(STAGING_DIR)/usr/share/edk2-platforms
	cp -rf $(@D) $(STAGING_DIR)/usr/share/edk2-platforms
endef

$(eval $(generic-package))
