################################################################################
#
# s6-portable-utils
#
################################################################################

S6_PORTABLE_UTILS_VERSION = 2.2.3.1
S6_PORTABLE_UTILS_SITE = http://skarnet.org/software/s6-portable-utils
S6_PORTABLE_UTILS_LICENSE = ISC
S6_PORTABLE_UTILS_LICENSE_FILES = COPYING
S6_PORTABLE_UTILS_DEPENDENCIES = skalibs

S6_PORTABLE_UTILS_CONF_OPTS = \
	$(SHARED_SKALIBS_CONF_OPTS)

define S6_PORTABLE_UTILS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_PORTABLE_UTILS_CONF_OPTS))
endef

define S6_PORTABLE_UTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_PORTABLE_UTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

HOST_S6_PORTABLE_UTILS_DEPENDENCIES = host-skalibs

HOST_S6_PORTABLE_UTILS_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--with-sysdeps=$(HOST_DIR)/lib/skalibs/sysdeps \
	--with-include=$(HOST_DIR)/include \
	--with-dynlib=$(HOST_DIR)/lib \
	--with-lib=$(STAGING_DIR)/lib/skalibs \
	--disable-static \
	--enable-shared \
	--disable-allstatic

define HOST_S6_PORTABLE_UTILS_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_S6_PORTABLE_UTILS_CONF_OPTS))
endef

define HOST_S6_PORTABLE_UTILS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_S6_PORTABLE_UTILS_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install-dynlib install-bin
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
