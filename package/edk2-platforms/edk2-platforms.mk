EDK2_PLATFORMS_VERSION = 608d71ec939692eace78e6b4b2a44ea7b6e75927
EDK2_PLATFORMS_SITE = $(call github,tianocore,edk2-platforms,$(EDK2_PLATFORMS_VERSION))
EDK2_PLATFORMS_LICENSE = BSD-2-Clause
EDK2_PLATFORMS_LICENSE_FILE = License.txt

$(eval $(host-generic-package))
