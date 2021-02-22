################################################################################
#
# skeleton-slashpackage
#
################################################################################

SKELETON_SLASHPACKAGE_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_SLASHPACKAGE_ADD_SKELETON_DEPENDENCY = NO
SKELETON_SLASHPACKAGE_DEPENDENCIES = skeleton-init-common
SKELETON_SLASHPACKAGE_PROVIDES = skeleton

define SKELETON_SLASHPACKAGE_INSTALL_TARGET_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_SLASHPACKAGE_PKGDIR)/skeleton,$(TARGET_DIR))
endef

$(eval $(generic-package))
