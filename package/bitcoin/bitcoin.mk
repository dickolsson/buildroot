################################################################################
#
# bitcoin
#
################################################################################

BITCOIN_VERSION = 0.19.1
BITCOIN_SITE = https://bitcoincore.org/bin/bitcoin-core-$(BITCOIN_VERSION)
BITCOIN_AUTORECONF = YES
BITCOIN_LICENSE = MIT
BITCOIN_LICENSE_FILES = COPYING
BITCOIN_DEPENDENCIES = host-pkgconf boost openssl libevent
BITCOIN_CONF_OPTS = \
	--disable-bench \
	--disable-tests \
	--with-boost-libdir=$(STAGING_DIR)/usr/lib/ \
	--without-gui

ifeq ($(BR2_aarch64),y)
BITCOIN_MAKE_OPTS += \
	HOST=aarch64-linux-gnu \
	NO_QT=1 \
	LDFLAGS=-static-libstdc++
BITCOIN_CONF_OPTS += --enable-reduce-exports
endif

ifeq ($(BR2_PACKAGE_LIBMINIUPNPC),y)
BITCOIN_DEPENDENCIES += libminiupnpc
BITCOIN_CONF_OPTS += --with-miniupnpc
else
BITCOIN_CONF_OPTS += --without-miniupnpc
endif

ifeq ($(BR2_PACKAGE_ZEROMQ),y)
BITCOIN_DEPENDENCIES += zeromq
BITCOIN_CONF_OPTS += --with-zmq
else
BITCOIN_CONF_OPTS += --without-zmq
endif

ifeq ($(BR2_PACKAGE_BITCOIN_ENABLE_WALLET),y)
BITCOIN_DEPENDENCIES += berkeleydb
else
BITCOIN_CONF_OPTS += --disable-wallet
endif

ifneq ($(BR2_PACKAGE_BITCOIN_ENABLE_HARDENING),y)
BITCOIN_CONF_OPTS += --disable-hardening
endif

$(eval $(autotools-package))
