EDK2_PLATFORMS_VERSION = dac18ca517819a2116158c3a0b692eb14e297af5
EDK2_PLATFORMS_SITE = $(call github,tianocore,edk2-platforms,$(EDK2_PLATFORMS_VERSION))
EDK2_PLATFORMS_LICENSE = BSD-2-Clause
EDK2_PLATFORMS_LICENSE_FILE = License.txt

$(eval $(generic-package))
