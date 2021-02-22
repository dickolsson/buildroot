################################################################################
#
# s6-networking
#
################################################################################

S6_NETWORKING_VERSION = 2.4.0.0
S6_NETWORKING_SITE = http://skarnet.org/software/s6-networking
S6_NETWORKING_LICENSE = ISC
S6_NETWORKING_LICENSE_FILES = COPYING
S6_NETWORKING_INSTALL_STAGING = YES
S6_NETWORKING_DEPENDENCIES = skalibs execline s6 s6-dns

S6_NETWORKING_CONF_OPTS = \
	$(SHARED_SKALIBS_CONF_OPTS) \
	$(SHARED_EXECLINE_CONF_OPTS) \
	$(SHARED_S6_CONF_OPTS) \
	$(SHARED_S6_DNS_CONF_OPTS)

ifeq ($(BR2_PACKAGE_LIBRESSL),y)
S6_NETWORKING_CONF_OPTS += --enable-ssl=libressl
S6_NETWORKING_DEPENDENCIES += libressl
else ifeq ($(BR2_PACKAGE_BEARSSL),y)
S6_NETWORKING_CONF_OPTS += --enable-ssl=bearssl
S6_NETWORKING_DEPENDENCIES += bearssl
endif

define S6_NETWORKING_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_NETWORKING_CONF_OPTS))
endef

define S6_NETWORKING_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_NETWORKING_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define S6_NETWORKING_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

$(eval $(generic-package))
