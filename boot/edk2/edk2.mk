EDK2_VERSION = edk2-stable202002
EDK2_SITE = https://github.com/tianocore/edk2
EDK2_SITE_METHOD = git
EDK2_LICENSE = BSD-2-Clause
EDK2_LICENSE_FILE = License.txt
EDK2_DEPENDENCIES = host-python3 edk2-platforms

# While it's not encouraged to use git submodules with Buildroot,
# the EDK2 setup is rather special, so we're resorting to using its
# own submodules for this.
EDK2_GIT_SUBMODULES = YES

EDK2_INSTALL_IMAGES = YES

# Build variables
EDK2_ARCH = AARCH64
EDK2_BUILD_TYPE = RELEASE
EDK2_TOOLCHAIN_TYPE = GCC5

# Package and platform variables
EDK2_PACKAGE_NAME = ARM/VExpressPkg
EDK2_PLATFORM_NAME = ArmVExpress-FVP-AArch64
EDK2_FD_NAME = FVP_AARCH64_EFI

# Make variables
EDK2_MAKE_OPTS += -C $(@D)/BaseTools
EDK2_MAKE_TARGETS += \
$(EDK2_TOOLCHAIN_TYPE)_$(EDK2_ARCH)_PREFIX="$(TARGET_CROSS)" \
build -a $(EDK2_ARCH) -t $(EDK2_TOOLCHAIN_TYPE) -p Platform/$(EDK2_PACKAGE_NAME)/$(EDK2_PLATFORM_NAME).dsc -b $(EDK2_BUILD_TYPE) all

EDK2_BUILD_PLATFORMS_PATH = $(BUILD_DIR)/edk2-platforms-$(EDK2_PLATFORMS_VERSION)

define EDK2_BUILD_CMDS
	export WORKSPACE=$(EDK2_BUILD_PLATFORMS_PATH) && \
	export PACKAGES_PATH=$(@D):$(EDK2_BUILD_PLATFORMS_PATH) && \
	export PYTHON_COMMAND=$(HOST_DIR)/bin/python3 && \
	source $(@D)/edksetup.sh && \
	$(TARGET_MAKE_ENV) $(MAKE) $(EDK2_MAKE_OPTS) && $(EDK2_MAKE_TARGETS)
endef

define EDK2_INSTALL_IMAGES_CMDS
	cp \
	$(EDK2_BUILD_PLATFORMS_PATH)/Build/$(EDK2_PLATFORM_NAME)/$(EDK2_BUILD_TYPE)_$(EDK2_TOOLCHAIN_TYPE)/FV/$(EDK2_FD_NAME).fd \
	$(BINARIES_DIR)/
endef

$(eval $(generic-package))
