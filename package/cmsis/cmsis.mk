################################################################################
#
# cmsis
#
################################################################################

# Version 5.6.0 is the last version before CMSIS changed their build system.
# The new build system does not yet work with Buildroot as it requires
# proprietary tools to build fully.
CMSIS_VERSION = 5.6.0
# We require the source code to be fetched with Git so that files handled with
# Git Large File Storage gets fetched properly (static RTX5 libraries for GCC).
CMSIS_SITE = git://github.com/ARM-software/CMSIS_5.git
CMSIS_LICENSE = Apache-2.0
CMSIS_LICENSE_FILES = LICENSE.txt

HOST_CMSIS_INSTALL_DIR = $(HOST_DIR)/share/cmsis

define HOST_CMSIS_INSTALL_CMDS
	rm -rf $(HOST_CMSIS_INSTALL_DIR)
	cp -rf $(@D) $(HOST_CMSIS_INSTALL_DIR)
endef

$(eval $(host-generic-package))
