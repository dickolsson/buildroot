################################################################################
#
# s6
#
################################################################################

S6_VERSION = 2.10.0.1
S6_SITE = http://skarnet.org/software/s6
S6_LICENSE = ISC
S6_LICENSE_FILES = COPYING
S6_INSTALL_STAGING = YES
S6_DEPENDENCIES = skalibs execline

S6_CONF_OPTS = \
	$(SHARED_SKALIBS_CONF_OPTS) \
	$(SHARED_EXECLINE_CONF_OPTS)

# SHARED_S6_CONF_OPTS can be used by dependant packages.
ifeq ($(BR2_SLASHPACKAGE),y)
SHARED_S6_CONF_OPTS = \
	--with-include=$(call slashpackage,admin,s6)/include \
	--with-dynlib=$(call slashpackage,admin,s6)/library.so \
	--with-lib=$(call slashpackage,admin,s6)/library
else
SHARED_S6_CONF_OPTS = \
	--with-lib=$(STAGING_DIR)/lib/s6
endif


define S6_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_CONF_OPTS))
endef

define S6_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define S6_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

HOST_S6_DEPENDENCIES = host-execline

# The host package does not have a run-time dependency on the
# --libexecdir option. But it must align with the target package since
# it affects the output.
HOST_S6_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--libexecdir=$(if $(BR2_SLASHPACKAGE),/command,/libexec) \
	--with-sysdeps=$(HOST_DIR)/lib/skalibs/sysdeps \
	--with-include=$(HOST_DIR)/include \
	--with-dynlib=$(HOST_DIR)/lib \
	--disable-static \
	--enable-shared \
	--disable-allstatic

define HOST_S6_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_S6_CONF_OPTS))
endef

define HOST_S6_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_S6_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install-dynlib install-include
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
