################################################################################
#
# mdevd
#
################################################################################

MDEVD_VERSION = 0.1.3.0
MDEVD_SITE = http://skarnet.org/software/mdevd
MDEVD_LICENSE = ISC
MDEVD_LICENSE_FILES = COPYING
MDEVD_INSTALL_STAGING = YES
MDEVD_DEPENDENCIES = skalibs

MDEVD_CONF_OPTS = $(SHARED_SKALIBS_CONF_OPTS)

define MDEVD_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(MDEVD_CONF_OPTS))
endef

define MDEVD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define MDEVD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define MDEVD_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

$(eval $(generic-package))
