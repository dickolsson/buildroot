################################################################################
#
# s6-linux-init
#
################################################################################

S6_LINUX_INIT_VERSION = 1.0.6.0
S6_LINUX_INIT_SITE = http://skarnet.org/software/s6-linux-init
S6_LINUX_INIT_LICENSE = ISC
S6_LINUX_INIT_LICENSE_FILES = COPYING
S6_LINUX_INIT_DEPENDENCIES = skalibs s6 execline

S6_LINUX_INIT_CONF_OPTS = \
	$(SHARED_SKALIBS_CONF_OPTS) \
	$(SHARED_EXECLINE_CONF_OPTS) \
	$(SHARED_S6_CONF_OPTS)

define S6_LINUX_INIT_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_LINUX_INIT_CONF_OPTS))
endef

define S6_LINUX_INIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_LINUX_INIT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

HOST_S6_LINUX_INIT_DEPENDENCIES = host-skalibs host-s6 host-execline

HOST_S6_LINUX_INIT_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--libexecdir=/libexec \
	--with-sysdeps=$(HOST_DIR)/lib/skalibs/sysdeps \
	--with-include=$(HOST_DIR)/include \
	--with-dynlib=$(HOST_DIR)/lib \
	--disable-static \
	--enable-shared \
	--disable-allstatic

define HOST_S6_LINUX_INIT_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_S6_LINUX_INIT_CONF_OPTS))
endef

define HOST_S6_LINUX_INIT_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_S6_LINUX_INIT_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install-dynlib install-bin
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
