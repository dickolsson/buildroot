################################################################################
#
# toybox
#
################################################################################

TOYBOX_VERSION = 0.8.4
TOYBOX_SITE = $(call github,landley,toybox,$(TOYBOX_VERSION))
TOYBOX_LICENSE = BSD-0
TOYBOX_LICENSE_FILES = LICENSE

TOYBOX_KCONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_TOYBOX_CONFIG))

TOYBOX_MAKE_OPTS = \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	PREFIX="$(TARGET_DIR)" \
	KCONFIG_ALLCONFIG="$(TOYBOX_KCONFIG_FILE)" \
	$(if $(BR2_STATIC_LIBS),LDFLAGS="--static")

define TOYBOX_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TOYBOX_MAKE_OPTS) -C $(@D)
endef

define TOYBOX_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TOYBOX_MAKE_OPTS) -C $(@D) install
endef

$(eval $(kconfig-package))
