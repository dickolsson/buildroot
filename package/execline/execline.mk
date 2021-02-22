################################################################################
#
# execline
#
################################################################################

EXECLINE_VERSION = 2.7.0.1
EXECLINE_SITE = http://skarnet.org/software/execline
EXECLINE_LICENSE = ISC
EXECLINE_LICENSE_FILES = COPYING
EXECLINE_INSTALL_STAGING = YES
EXECLINE_DEPENDENCIES = skalibs

EXECLINE_CONF_OPTS = \
	$(SHARED_SKALIBS_CONF_OPTS)

# SHARED_EXECLINE_CONF_OPTS can be used by dependant packages.
ifeq ($(BR2_SLASHPACKAGE),y)
SHARED_EXECLINE_CONF_OPTS = \
	--enable-slashpackage \
	--with-include=$(call slashpackage,admin,execline)/include \
	--with-dynlib=$(call slashpackage,admin,execline)/library.so \
	--with-lib=$(call slashpackage,admin,execline)/library
else
SHARED_EXECLINE_CONF_OPTS = \
	--with-lib=$(STAGING_DIR)/lib/execline
endif

define EXECLINE_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(EXECLINE_CONF_OPTS))
endef

define EXECLINE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define EXECLINE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define EXECLINE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

HOST_EXECLINE_DEPENDENCIES = host-skalibs

# The host package does not have a run-time dependency on the
# --shebangdir and --libexecdir options. But they must align with the
# target package since they affect the output.
HOST_EXECLINE_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--shebangdir=$(if $(BR2_SLASHPACKAGE),/command,/bin) \
	--libexecdir=$(if $(BR2_SLASHPACKAGE),/command,/libexec) \
	--with-sysdeps=$(HOST_DIR)/lib/skalibs/sysdeps \
	--with-include=$(HOST_DIR)/include \
	--with-dynlib=$(HOST_DIR)/lib \
	--disable-static \
	--enable-shared \
	--disable-allstatic

define HOST_EXECLINE_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_EXECLINE_CONF_OPTS))
endef

define HOST_EXECLINE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_EXECLINE_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
