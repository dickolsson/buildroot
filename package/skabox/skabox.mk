################################################################################
#
# skabox
#
################################################################################

SKABOX_VERSION = 0.0.1
SKABOX_SITE = file:///home/sysadm/senzillaos/release/latest
SKABOX_LICENSE = ISC
SKABOX_LICENSE_FILES = LICENSE
SKABOX_INSTALL_STAGING = YES

SKABOX_KCONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_SKABOX_CONFIG))
SKABOX_MAKE_ENV = $(HOST_MAKE_ENV)

# Build-time dependencies
SKABOX_DEPENDENCIES = host-python3-kconfiglib host-fakeroot \
	host-s6-portable-utils host-s6-linux-init host-s6-rc

# Run-time dependencies
SKABOX_DEPENDENCIES += s6-linux-init s6-rc s6-linux-utils \
	s6-portable-utils s6-networking mdevd bearssl socklog

define SKABOX_USERS
	log -1 log -1 * - - - Log writer
	syslog -1 syslog -1 * - - - Syslog reader
	klog -1 klog -1 * - - - Kernel log reader
endef

define SKABOX_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define SKABOX_INSTALL_STAGING_CMDS
	$(SKABOX_MAKE_ENV) $(MAKE) \
		$(SKABOX_MAKE_OPTS) DESTDIR="$(STAGING_DIR)" -C $(@D) install
endef

define SKABOX_INSTALL_TARGET_CMDS
	$(SKABOX_MAKE_ENV) $(MAKE) \
		$(SKABOX_MAKE_OPTS) DESTDIR="$(TARGET_DIR)" -C $(@D) install
endef

define SKABOX_TARGET_FINALIZE
	$(SKABOX_MAKE_ENV) $(MAKE) \
		$(SKABOX_MAKE_OPTS) DESTDIR="$(TARGET_DIR)" \
		-C $(BUILD_DIR)/skabox-$(SKABOX_VERSION) \
		finalize
endef

SKABOX_TARGET_FINALIZE_HOOKS += SKABOX_TARGET_FINALIZE

$(eval $(kconfig-package))
