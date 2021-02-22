################################################################################
#
# s6-rc
#
################################################################################

S6_RC_VERSION = 0.5.2.1
S6_RC_SITE = http://skarnet.org/software/s6-rc
S6_RC_LICENSE = ISC
S6_RC_LICENSE_FILES = COPYING
S6_RC_INSTALL_STAGING = YES
S6_RC_DEPENDENCIES = skalibs s6 execline

S6_RC_CONF_OPTS = \
	$(SHARED_SKALIBS_CONF_OPTS) \
	$(SHARED_EXECLINE_CONF_OPTS) \
	$(SHARED_S6_CONF_OPTS)

define S6_RC_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_RC_CONF_OPTS))
endef

define S6_RC_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_RC_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define S6_RC_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

HOST_S6_RC_DEPENDENCIES = host-skalibs host-s6 host-execline

# The host package does not have a run-time dependency on the
# --libexecdir option. But it must align with the target package since
# it affects the output.
HOST_S6_RC_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--libexecdir=$(if $(BR2_SLASHPACKAGE),/command,/libexec) \
	--with-sysdeps=$(HOST_DIR)/lib/skalibs/sysdeps \
	--with-include=$(HOST_DIR)/include \
	--with-dynlib=$(HOST_DIR)/lib \
	--disable-static \
	--enable-shared \
	--disable-allstatic

define HOST_S6_RC_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_S6_RC_CONF_OPTS))
endef

define HOST_S6_RC_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_S6_RC_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install-dynlib install-bin
	rm -f $(HOST_DIR)/bin/s6-rc-dryrun
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
