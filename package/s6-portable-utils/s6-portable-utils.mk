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
	--with-sysdeps=$(STAGING_DIR)/usr/lib/skalibs/sysdeps \
	--with-include=$(STAGING_DIR)/include \
	--with-dynlib=$(STAGING_DIR)/lib \
	--with-lib=$(STAGING_DIR)/usr/lib/skalibs \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)

define S6_PORTABLE_UTILS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_PORTABLE_UTILS_CONF_OPTS))
endef

define S6_PORTABLE_UTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

S6_PORTABLE_UTILS_POSIX_FULL = \
	basename cut dirname env false head mkdir mkfifo nice sleep true
S6_PORTABLE_UTILS_POSIX_PART = \
	cat echo expr ln ls seq sort sync tail test touch
S6_PORTABLE_UTILS_POSIX_ALT = chmod chown grep

S6_PORTABLE_UTILS_RENAME = \
	$(if $(BR2_PACKAGE_S6_PORTABLE_UTILS_RENAME_POSIX_FULL), \
		$(S6_PORTABLE_UTILS_POSIX_FULL)) \
	$(if $(BR2_PACKAGE_S6_PORTABLE_UTILS_RENAME_POSIX_PART), \
		$(S6_PORTABLE_UTILS_POSIX_PART)) \
	$(if $(BR2_PACKAGE_S6_PORTABLE_UTILS_RENAME_POSIX_ALT), \
		$(S6_PORTABLE_UTILS_POSIX_ALT))

define S6_PORTABLE_UTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
	$(foreach util,$(S6_PORTABLE_UTILS_RENAME), \
		mv -f $(TARGET_DIR)/bin/s6-$(util) $(TARGET_DIR)/bin/$(util);)
endef

$(eval $(generic-package))
