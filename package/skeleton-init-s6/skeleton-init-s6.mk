################################################################################
#
# skeleton-init-s6
#
################################################################################

SKELETON_INIT_S6_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_INIT_S6_ADD_SKELETON_DEPENDENCY = NO
SKELETON_INIT_S6_DEPENDENCIES = skeleton-init-common host-s6-rc
SKELETON_INIT_S6_PROVIDES = skeleton

define SKELETON_INIT_S6_USERS
	log -1 log -1 * - - - Log writer
	syslog -1 syslog -1 * - - - Syslog reader
	klog -1 klog -1 * - - - Kernel log reader
endef

define SKELETON_INIT_S6_INSTALL_TARGET_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_INIT_S6_PKGDIR)/skeleton,$(TARGET_DIR))
endef

SKELETON_INIT_S6_FIFO_FILES = \
	$(TARGET_DIR)/etc/s6-linux-init/build/run-image/service/s6-linux-init-shutdownd/fifo \
	$(TARGET_DIR)/etc/s6-linux-init/build/run-image/service/s6-svscan-log/fifo

define SKELETON_INIT_S6_RECREATE_FIFO_FILES
	$(foreach f,$(SKELETON_INIT_S6_FIFO_FILES), \
		rm -rf $(f); mkfifo -m 0600 $(f);)
endef

define SKELETON_INIT_S6_RC_COMPILE
	rm -rf $(TARGET_DIR)/etc/s6-rc/compiled
	$(HOST_DIR)/bin/s6-rc-compile \
		$(TARGET_DIR)/etc/s6-rc/compiled \
		$(TARGET_DIR)/etc/s6-rc/service
endef

SKELETON_INIT_S6_TARGET_FINALIZE_HOOKS += \
	SKELETON_INIT_S6_RECREATE_FIFO_FILES \
	SKELETON_INIT_S6_RC_COMPILE

$(eval $(generic-package))
