EDK2_VERSION = edk2-stable202005
EDK2_SITE = https://github.com/tianocore/edk2
EDK2_SITE_METHOD = git
EDK2_LICENSE = BSD-2-Clause
EDK2_LICENSE_FILE = License.txt
EDK2_DEPENDENCIES = host-python3 host-acpica

# The EDK2 build system is rather special, so we're resorting to using its
# own Git submodules in order to include certain build dependencies.
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

# EDk2 can be built with CLANG or GCC >= 5. But since Buildroot currently
# only support GCC toolchains this option is assumed for now.
EDK2_TOOLCHAIN_TYPE = GCC5

# Packages path.
#
# The EDK2 build system will, for some platforms, depend on binary outputs
# from other bootloader packages. Those dependencies need to be in the path
# for the EDK2 build system, so we define this special directory here.
EDK2_OUTPUT_BASE = $(BINARIES_DIR)/edk2

ifeq ($(BR2_PACKAGE_HOST_EDK2_PLATFORMS),y)
EDK2_PACKAGES_PATH = $(@D):$(EDK2_OUTPUT_BASE):$(BUILD_DIR)/host-edk2-platforms-$(EDK2_PLATFORMS_VERSION)
else
EDK2_PACKAGES_PATH = $(@D):$(EDK2_OUTPUT_BASE)
endif

# Platform name configuration.
#
# Defining EDK2_FD_NAME is important. This variable may be used by other
# bootloaders (e.g. ATF) as they build firmware packages based on this file.
#
# However, the case of the QEMU SBSA platform is a bit unique as there are
# different implicit assumptions on how this firmware should be packaged
# and executed with ATF and the SBSA reference machine for QEMU.

ifeq ($(BR2_TARGET_EDK2_PLATFORM_ARM_VIRT_QEMU),y)
EDK2_PACKAGE_NAME = ArmVirtPkg
EDK2_PLATFORM_NAME = ArmVirtQemu
EDK2_FD_NAME = QEMU_EFI

else ifeq ($(BR2_TARGET_EDK2_PLATFORM_ARM_VIRT_QEMU_KERNEL),y)
EDK2_PACKAGE_NAME = ArmVirtPkg
EDK2_PLATFORM_NAME = ArmVirtQemuKernel
EDK2_FD_NAME = QEMU_EFI

else ifeq ($(BR2_TARGET_EDK2_PLATFORM_ARM_VEXPRESS_FVP_AARCH64),y)
EDK2_DEPENDENCIES += host-edk2-platforms
EDK2_PACKAGE_NAME = Platform/ARM/VExpressPkg
EDK2_PLATFORM_NAME = ArmVExpress-FVP-AArch64
EDK2_FD_NAME = FVP_AARCH64_EFI

else ifeq ($(BR2_TARGET_EDK2_PLATFORM_QEMU_SBSA),y)
EDK2_DEPENDENCIES += host-edk2-platforms arm-trusted-firmware
EDK2_PACKAGE_NAME = Platform/Qemu/SbsaQemu
EDK2_PLATFORM_NAME = SbsaQemu
EDK2_PRE_CONFIGURE_HOOKS += EDK2_OUTPUT_QEMU_SBSA
endif

# This will create the package path structure that EDK2 expect when building
# flash devices for QEMU SBSA.
define EDK2_OUTPUT_QEMU_SBSA
	mkdir -p $(EDK2_OUTPUT_BASE)/Platform/Qemu/Sbsa && \
	ln -srf $(BINARIES_DIR)/{bl1.bin,fip.bin} $(EDK2_OUTPUT_BASE)/Platform/Qemu/Sbsa/
endef

# Make build variables.
EDK2_MAKE_OPTS += -C $(@D)/BaseTools
EDK2_MAKE_TARGETS += \
$(EDK2_TOOLCHAIN_TYPE)_$(EDK2_ARCH)_PREFIX="$(TARGET_CROSS)" \
build -a $(EDK2_ARCH) -t $(EDK2_TOOLCHAIN_TYPE) -b $(EDK2_BUILD_TYPE) \
-p $(EDK2_PACKAGE_NAME)/$(EDK2_PLATFORM_NAME).dsc $(EDK2_BUILD_OPTS) all

define EDK2_BUILD_CMDS
	export WORKSPACE=$(@D) && \
	export PACKAGES_PATH=$(EDK2_PACKAGES_PATH) && \
	export PYTHON_COMMAND=$(HOST_DIR)/bin/python3 && \
	export IASL_PREFIX=$(BUILD_DIR)/host-acpica-$(ACPICA_VERSION)/generate/unix/bin/ && \
	mkdir -p $(EDK2_OUTPUT_BASE) && \
	source $(@D)/edksetup.sh && \
	$(TARGET_MAKE_ENV) $(MAKE) $(EDK2_MAKE_OPTS) && $(EDK2_MAKE_TARGETS)
endef

# Location of the compiled flash device files is not consistent between
# platform descriptions. So this install command have to test for the two
# different locations.
EDK2_FV1 = $(@D)/Build/$(EDK2_PLATFORM_NAME)/$(EDK2_BUILD_TYPE)_$(EDK2_TOOLCHAIN_TYPE)/FV
EDK2_FV2 = $(@D)/Build/$(EDK2_PLATFORM_NAME)-$(EDK2_ARCH)/$(EDK2_BUILD_TYPE)_$(EDK2_TOOLCHAIN_TYPE)/FV

define EDK2_INSTALL_IMAGES_CMDS
	if test -d $(EDK2_FV1); then \
		cp $(EDK2_FV1)/*.fd $(BINARIES_DIR)/; \
	elif test -d $(EDK2_FV2); then \
		cp $(EDK2_FV2)/*.fd $(BINARIES_DIR)/; \
	fi
endef

$(eval $(generic-package))
