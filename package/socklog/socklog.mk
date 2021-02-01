################################################################################
#
# socklog
#
################################################################################

SOCKLOG_VERSION = 2.0.3
SOCKLOG_SITE = http://smarden.org/socklog2
SOCKLOG_LICENSE = Public domain
SOCKLOG_LICENSE_FILES = src/alloc.h

SOCKLOG_DIR1 = $(BUILD_DIR)/socklog-$(SOCKLOG_VERSION)/socklog-$(SOCKLOG_VERSION)

define SOCKLOG_CONFIGURE_CMDS
	echo "$(TARGET_CC) $(TARGET_CFLAGS)" > $(SOCKLOG_DIR1)/src/conf-cc
	echo "$(TARGET_CC) $(TARGET_LDFLAGS)" > $(SOCKLOG_DIR1)/src/conf-ld
endef

define SOCKLOG_BUILD_CMDS
	(cd $(SOCKLOG_DIR1); $(TARGET_MAKE_ENV) ./package/compile)
endef

define SOCKLOG_INSTALL_TARGET_CMDS
	$(INSTALL) $(SOCKLOG_DIR1)/command/socklog $(TARGET_DIR)/bin
endef

$(eval $(generic-package))
