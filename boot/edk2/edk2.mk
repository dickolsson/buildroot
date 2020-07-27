################################################################################
#
# edk2
#
################################################################################

EDK2_VERSION = edk2-stable202008
EDK2_SITE = https://github.com/tianocore/edk2
EDK2_SITE_METHOD = git
EDK2_LICENSE = BSD-2-Clause
EDK2_LICENSE_FILE = License.txt
EDK2_DEPENDENCIES = host-python3 host-acpica host-util-linux

# The EDK2 build system is rather special, so we're resorting to using its
# own Git submodules in order to include certain build dependencies.
EDK2_GIT_SUBMODULES = YES

EDK2_INSTALL_IMAGES = YES

ifeq ($(BR2_x86_64),y)
EDK2_ARCH = X64
else ifeq ($(BR2_aarch64),y)
EDK2_ARCH = AARCH64
endif

ifeq ($(BR2_TARGET_EDK2_DEBUG),y)
EDK2_BUILD_TYPE = DEBUG
else
EDK2_BUILD_TYPE = RELEASE
endif

# Packages path.
#
# The EDK2 build system will, for some platforms, depend on binary outputs
# from other bootloader packages. Those dependencies need to be in the path
# for the EDK2 build system, so we define this special directory here.
EDK2_OUTPUT_BASE = $(BINARIES_DIR)/edk2

ifeq ($(BR2_PACKAGE_HOST_EDK2_PLATFORMS),y)
EDK2_PACKAGES_PATH = $(@D):$(EDK2_OUTPUT_BASE):$(HOST_DIR)/share/edk2-platforms
else
EDK2_PACKAGES_PATH = $(@D):$(EDK2_OUTPUT_BASE)
endif

# Platform configuration.
#
# We set the variable EDK_EL2_NAME for platforms that may depend on EDK2 as
# part of booting the EL2 context, like ARM Trusted Firmware (ATF). This way,
# other bootloaders know what binary to build into in their firmware package.
#
# However, some platforms (e.g. QEMU SBSA, Socionext DeveloperBox) are built
# differently where the dependency with ATF is reversed. In these cases EDK2
# will package the firmware package instead.

ifeq ($(BR2_TARGET_EDK2_PLATFORM_OVMF_X64),y)
EDK2_DEPENDENCIES += host-nasm
EDK2_PACKAGE_NAME = OvmfPkg
EDK2_PLATFORM_NAME = OvmfPkgX64
EDK2_BUILD_DIR = OvmfX64

else ifeq ($(BR2_TARGET_EDK2_PLATFORM_ARM_VIRT_QEMU),y)
EDK2_PACKAGE_NAME = ArmVirtPkg
EDK2_PLATFORM_NAME = ArmVirtQemu
EDK2_BUILD_DIR = $(EDK2_PLATFORM_NAME)-$(EDK2_ARCH)

else ifeq ($(BR2_TARGET_EDK2_PLATFORM_ARM_VIRT_QEMU_KERNEL),y)
EDK2_PACKAGE_NAME = ArmVirtPkg
EDK2_PLATFORM_NAME = ArmVirtQemuKernel
EDK2_BUILD_DIR = $(EDK2_PLATFORM_NAME)-$(EDK2_ARCH)
EDK2_EL2_NAME = QEMU_EFI

else ifeq ($(BR2_TARGET_EDK2_PLATFORM_ARM_VEXPRESS_FVP_AARCH64),y)
EDK2_DEPENDENCIES += host-edk2-platforms
EDK2_PACKAGE_NAME = Platform/ARM/VExpressPkg
EDK2_PLATFORM_NAME = ArmVExpress-FVP-AArch64
EDK2_BUILD_DIR = $(EDK2_PLATFORM_NAME)
EDK2_EL2_NAME = FVP_AARCH64_EFI

else ifeq ($(BR2_TARGET_EDK2_PLATFORM_SOCIONEXT_DEVELOPERBOX),y)
EDK2_DEPENDENCIES += host-edk2-platforms host-dtc arm-trusted-firmware
EDK2_PACKAGE_NAME = Platform/Socionext/DeveloperBox
EDK2_PLATFORM_NAME = DeveloperBox
EDK2_BUILD_DIR = $(EDK2_PLATFORM_NAME)
EDK2_EL2_NAME = FVP_AARCH64_EFI
EDK2_PRE_CONFIGURE_HOOKS += EDK2_OUTPUT_SOCIONEXT_DEVELOPERBOX
EDK2_BUILD_ENV += DTC_PREFIX=$(HOST_DIR)/bin/
EDK2_BUILD_OPTS += -D DO_X86EMU=TRUE

else ifeq ($(BR2_TARGET_EDK2_PLATFORM_SOLIDRUN_ARMADA80X0MCBIN),y)
EDK2_DEPENDENCIES += host-edk2-platforms host-dtc
EDK2_PACKAGE_NAME = Platform/SolidRun/Armada80x0McBin
EDK2_PLATFORM_NAME = Armada80x0McBin
EDK2_BUILD_DIR = $(EDK2_PLATFORM_NAME)-$(EDK2_ARCH)
EDK2_EL2_NAME = ARMADA_EFI
EDK2_BUILD_ENV += DTC_PREFIX=$(HOST_DIR)/bin/
EDK2_BUILD_OPTS += -D INCLUDE_TFTP_COMMAND

else ifeq ($(BR2_TARGET_EDK2_PLATFORM_QEMU_SBSA),y)
EDK2_DEPENDENCIES += host-edk2-platforms arm-trusted-firmware
EDK2_PACKAGE_NAME = Platform/Qemu/SbsaQemu
EDK2_PLATFORM_NAME = SbsaQemu
EDK2_BUILD_DIR = $(EDK2_PLATFORM_NAME)
EDK2_PRE_CONFIGURE_HOOKS += EDK2_OUTPUT_QEMU_SBSA
endif

# Workspace setup.
#
# For some platforms we need to prepare the EDK2 workspace and link to the
# ARM Trusted Firmware (ATF) binaries. This will enable EDK2 to bundle ATF
# into its firmware package.

define EDK2_OUTPUT_SOCIONEXT_DEVELOPERBOX
	mkdir -p $(EDK2_OUTPUT_BASE)/Platform/Socionext/DeveloperBox
	$(ARM_TRUSTED_FIRMWARE_DIR)/tools/fiptool/fiptool create \
		--tb-fw $(BINARIES_DIR)/bl31.bin \
		--soc-fw $(BINARIES_DIR)/bl31.bin \
		--scp-fw $(BINARIES_DIR)/bl31.bin \
		$(EDK2_OUTPUT_BASE)/Platform/Socionext/DeveloperBox/fip_all_arm_tf.bin
endef

define EDK2_OUTPUT_QEMU_SBSA
	mkdir -p $(EDK2_OUTPUT_BASE)/Platform/Qemu/Sbsa
	ln -srf $(BINARIES_DIR)/{bl1.bin,fip.bin} $(EDK2_OUTPUT_BASE)/Platform/Qemu/Sbsa/
endef

# Make and build options.
#
# Due to the uniquely scripted build system for EDK2 we need to export most
# build environment variables so that they are available across edksetup.sh,
# make, the build command, and other subordinate build scripts within EDK2.

EDK2_MAKE_ENV += \
	EXTRA_LDFLAGS="$(HOST_LDFLAGS)" \
	EXTRA_OPTFLAGS="$(HOST_CPPFLAGS)"

EDK2_BUILD_ENV += \
	WORKSPACE=$(@D) \
	PACKAGES_PATH=$(EDK2_PACKAGES_PATH) \
	PYTHON_COMMAND=$(HOST_DIR)/bin/python3 \
	IASL_PREFIX=$(HOST_DIR)/bin/ \
	NASM_PREFIX=$(HOST_DIR)/bin/ \
	GCC5_$(EDK2_ARCH)_PREFIX=$(TARGET_CROSS)

EDK2_BUILD_OPTS += \
	-t GCC5 \
	-n `nproc` \
	-a $(EDK2_ARCH) \
	-b $(EDK2_BUILD_TYPE) \
	-p $(EDK2_PACKAGE_NAME)/$(EDK2_PLATFORM_NAME).dsc

define EDK2_BUILD_CMDS
	mkdir -p $(EDK2_OUTPUT_BASE)
	export $(EDK2_BUILD_ENV) && \
	unset ARCH && \
	source $(@D)/edksetup.sh && \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/BaseTools $(EDK2_MAKE_ENV) && \
	build $(EDK2_BUILD_OPTS) all
endef

define EDK2_INSTALL_IMAGES_CMDS
	cp -f $(@D)/Build/$(EDK2_BUILD_DIR)/$(EDK2_BUILD_TYPE)_GCC5/FV/*.fd $(BINARIES_DIR)
endef

$(eval $(generic-package))
