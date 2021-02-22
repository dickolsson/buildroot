################################################################################
#
# socklog
#
################################################################################

SOCKLOG_VERSION = v2.2.2
SOCKLOG_SITE = $(call github,just-containers,socklog,$(SOCKLOG_VERSION))
SOCKLOG_LICENSE = BSD-3-Clause
SOCKLOG_LICENSE_FILES = COPYING
SOCKLOG_INSTALL_STAGING = YES
SOCKLOG_DEPENDENCIES = skalibs

SOCKLOG_CONF_OPTS = $(SHARED_SKALIBS_CONF_OPTS)

define SOCKLOG_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(SOCKLOG_CONF_OPTS))
endef

define SOCKLOG_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define SOCKLOG_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define SOCKLOG_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

$(eval $(generic-package))
