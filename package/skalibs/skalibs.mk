################################################################################
#
# skalibs
#
################################################################################

SKALIBS_VERSION = 2.10.0.1
SKALIBS_SITE = http://skarnet.org/software/skalibs
SKALIBS_LICENSE = ISC
SKALIBS_LICENSE_FILES = COPYING
SKALIBS_INSTALL_STAGING = YES

SKALIBS_CONF_OPTS = \
	--prefix=/ \
	--with-sysdep-devurandom=yes \
	$(if $(BR2_SLASHPACKAGE),--enable-slashpackage) \
	$(SHARED_STATIC_LIBS_OPTS)

# SHARED_SKALIBS_CONF_OPTS can be used by dependant packages.
ifeq ($(BR2_SLASHPACKAGE),y)
SKALIBS_CONF_OPTS += \
	--enable-slashpackage \
	--with-default-path=/command:/usr/bin:/bin

SHARED_SKALIBS_CONF_OPTS = \
	--enable-slashpackage \
	--prefix=/ \
	--with-sysdeps=$(call slashpackage,prog,skalibs)/sysdeps \
	--with-include=$(call slashpackage,prog,skalibs)/include \
	--with-dynlib=$(call slashpackage,prog,skalibs)/library.so \
	--with-lib=$(call slashpackage,prog,skalibs)/library \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)

else
SKALIBS_CONF_OPTS += \
	--with-default-path=/usr/bin:/bin

SHARED_SKALIBS_CONF_OPTS = \
	--prefix=/ \
	--with-sysdeps=$(STAGING_DIR)/lib/skalibs/sysdeps \
	--with-include=$(STAGING_DIR)/include \
	--with-dynlib=$(STAGING_DIR)/lib \
	--with-lib=$(STAGING_DIR)/lib/skalibs \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)
endif

define SKALIBS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(SKALIBS_CONF_OPTS))
endef

define SKALIBS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define SKALIBS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	rm -rf $(TARGET_DIR)/lib/skalibs
endef

define SKALIBS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

# The --with-default-path option needs to match the target variant.
HOST_SKALIBS_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--with-default-path=$(if $(BR2_SLASHPACKAGE),/command:/usr/bin:/bin,/usr/bin:/bin) \
	--disable-static \
	--enable-shared \
	--disable-allstatic

define HOST_SKALIBS_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_SKALIBS_CONF_OPTS))
endef

define HOST_SKALIBS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_SKALIBS_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
