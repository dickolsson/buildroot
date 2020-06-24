EDK2_VERSION = edk2-stable202002
EDK2_SITE = https://github.com/tianocore/edk2
EDK2_SITE_METHOD = git
EDK2_LICENSE = BSD-2-Clause
EDK2_LICENSE_FILE = License.txt
EDK2_DEPENDENCIES = host-python3

# While it's not encouraged to use git submodules with Buildroot,
# the EDK2 setup is rather special, so we're resorting to using its
# own submodules for this.
EDK2_GIT_SUBMODULES = YES

EDK2_INSTALL_IMAGES = YES

ifeq ($(BR2_aarch64),y)
EDK2_ARCH = AARCH64
endif

ifeq ($(BR2_TARGET_EDK2_DEBUG),y)
EDK2_BUILD_TYPE = DEBUG
else
EDK2_BUILD_TYPE = RELEASE
endif

# TODO: Set correct value depending on toolchain.
EDK2_TOOLCHAIN_TYPE = GCC5

# Workspace configuration.
ifeq ($(BR2_TARGET_EDK2_PLATFORMS),y)
EDK2_PACKAGES_PATH = $(@D):$(BUILD_DIR)/edk2-platforms-$(EDK2_PLATFORMS_VERSION)
else
EDK2_PACKAGES_PATH = $(@D)
endif

# Package configuration.
ifeq ($(BR2_TARGET_EDK2_PACKAGE_ARM_VIRT),y)
EDK2_PACKAGE_NAME = ArmVirtPkg
else ifeq ($(BR2_TARGET_EDK2_PACKAGE_ARM_VEXPRESS),y)
EDK2_DEPENDENCIES += edk2-platforms
EDK2_PACKAGE_NAME = Platform/ARM/VExpressPkg
else ifeq ($(BR2_TARGET_EDK2_PACKAGE_CUSTOM),y)
EDK2_PACKAGE_NAME = $(call qstrip,$(BR2_TARGET_EDK2_PACKAGE_CUSTOM_NAME))
endif

# Platform configuration.
ifeq ($(BR2_TARGET_EDK2_PLATFORM_ARM_VIRT_QEMU),y)
EDK2_PLATFORM_NAME = ArmVirtQemu
EDK2_FD_NAME = QEMU_EFI
else ifeq ($(BR2_TARGET_EDK2_PLATFORM_ARM_VIRT_XEN),y)
EDK2_PLATFORM_NAME = ArmVirtXen
EDK2_FD_NAME = XEN_EFI
else ifeq ($(BR2_TARGET_EDK2_PLATFORM_ARM_VEXPRESS_FVP_AARCH64),y)
EDK2_PLATFORM_NAME = ArmVExpress-FVP-AArch64
EDK2_FD_NAME = FVP_AARCH64_EFI
EDK2_BUILD_OPTS += -D DT_SUPPORT
else ifeq ($(BR2_TARGET_EDK2_PLATFORM_CUSTOM),y)
EDK2_PLATFORM_NAME = $(call qstrip,$(BR2_TARGET_EDK2_PLATFORM_CUSTOM_NAME))
EDK2_FD_NAME = $(call qstrip,$(BR2_TARGET_EDK2_FD_CUSTOM_NAME))
endif

# Make variables
EDK2_MAKE_OPTS += -C $(@D)/BaseTools
EDK2_MAKE_TARGETS += \
$(EDK2_TOOLCHAIN_TYPE)_$(EDK2_ARCH)_PREFIX="$(TARGET_CROSS)" \
build -a $(EDK2_ARCH) -t $(EDK2_TOOLCHAIN_TYPE) -p $(EDK2_PACKAGE_NAME)/$(EDK2_PLATFORM_NAME).dsc -b $(EDK2_BUILD_TYPE) $(EDK2_BUILD_OPTS) all

# TODO: Is the WORKSPACE environment variable necessary?
define EDK2_BUILD_CMDS
	export WORKSPACE=$(@D) && \
	export PACKAGES_PATH=$(EDK2_PACKAGES_PATH) && \
	export PYTHON_COMMAND=$(HOST_DIR)/bin/python3 && \
	source $(@D)/edksetup.sh && \
	$(TARGET_MAKE_ENV) $(MAKE) $(EDK2_MAKE_OPTS) && $(EDK2_MAKE_TARGETS)
endef

# TODO: Simplify this
define EDK2_INSTALL_IMAGES_CMDS
	if test -d $(@D)/Build/$(EDK2_PLATFORM_NAME); then \
		cp \
		$(@D)/Build/$(EDK2_PLATFORM_NAME)/$(EDK2_BUILD_TYPE)_$(EDK2_TOOLCHAIN_TYPE)/FV/$(EDK2_FD_NAME).fd \
		$(BINARIES_DIR)/; \
	elif test -d $(@D)/Build/$(EDK2_PLATFORM_NAME)-$(EDK2_ARCH); then \
		cp \
		$(@D)/Build/$(EDK2_PLATFORM_NAME)-$(EDK2_ARCH)/$(EDK2_BUILD_TYPE)_$(EDK2_TOOLCHAIN_TYPE)/FV/$(EDK2_FD_NAME).fd \
		$(BINARIES_DIR)/; \
	fi
endef

$(eval $(generic-package))
