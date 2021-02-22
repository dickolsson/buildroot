################################################################################
#
# bmake
#
################################################################################

BMAKE_VERSION = 20210206
BMAKE_SITE = http://www.crufty.net/ftp/pub/sjg
BMAKE_LICENSE = BSD-3-Clause
BMAKE_LICENSE_FILES = LICENSE
BMAKE_DEPENDENCIES = mksh

BMAKE_CONF_OPTS = \
	--with-defshell=/bin/mksh \
	$(SHARED_STATIC_LIBS_OPTS)

define BMAKE_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(BMAKE_CONF_OPTS))
endef

define BMAKE_BUILD_CMDS
	(cd $(@D); sh ./make-bootstrap.sh)
endef

define BMAKE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/bmake $(TARGET_DIR)/bin/bmake
	mkdir -p $(TARGET_DIR)/share/mk
	sh $(@D)/mk/install-mk $(TARGET_DIR)/share/mk
endef

HOST_BMAKE_DEPENDENCIES = host-mksh
HOST_BMAKE_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--with-defshell=$(HOST_DIR)/bin/mksh

define HOST_BMAKE_CONFIGURE_CMDS
	(cd $(@D); $(HOST_CONFIGURE_OPTS) ./configure $(HOST_BMAKE_CONF_OPTS))
endef

define HOST_BMAKE_BUILD_CMDS
	(cd $(@D); sh ./make-bootstrap.sh)
endef

define HOST_BMAKE_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/bmake $(HOST_DIR)/bin/bmake
	mkdir -p $(HOST_DIR)/share/mk
	sh $(@D)/mk/install-mk $(HOST_DIR)/share/mk
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
