################################################################################
#
# s6-dns
#
################################################################################

S6_DNS_VERSION = 2.3.5.0
S6_DNS_SITE = http://skarnet.org/software/s6-dns
S6_DNS_LICENSE = ISC
S6_DNS_LICENSE_FILES = COPYING
S6_DNS_INSTALL_STAGING = YES
S6_DNS_DEPENDENCIES = skalibs

S6_DNS_CONF_OPTS = \
	$(SHARED_SKALIBS_CONF_OPTS)

# SHARED_S6_DNS_CONF_OPTS can be used by dependant packages.
ifeq ($(BR2_SLASHPACKAGE),y)
SHARED_S6_DNS_CONF_OPTS = \
	--with-include=$(call slashpackage,web,s6-dns)/include \
	--with-dynlib=$(call slashpackage,web,s6-dns)/library.so \
	--with-lib=$(call slashpackage,web,s6-dns)/library
else
SHARED_S6_DNS_OPTS = \
	--with-lib=$(STAGING_DIR)/lib/s6-dns
endif

define S6_DNS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_DNS_CONF_OPTS))
endef

define S6_DNS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_DNS_REMOVE_STATIC_LIB_DIR
	rm -rf $(TARGET_DIR)/usr/lib/s6-dns
endef

S6_DNS_POST_INSTALL_TARGET_HOOKS += S6_DNS_REMOVE_STATIC_LIB_DIR

define S6_DNS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define S6_DNS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

$(eval $(generic-package))
