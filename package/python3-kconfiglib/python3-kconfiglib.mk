################################################################################
#
# python3-kconfiglib
#
################################################################################

PYTHON3_KCONFIGLIB_VERSION = 14.1.0
PYTHON3_KCONFIGLIB_SOURCE = kconfiglib-$(PYTHON3_KCONFIGLIB_VERSION).tar.gz
PYTHON3_KCONFIGLIB_SITE = https://files.pythonhosted.org/packages/59/29/d557718c84ef1a8f275faa4caf8e353778121beefbe9fadfa0055ca99aae
PYTHON3_KCONFIGLIB_SETUP_TYPE = setuptools
PYTHON3_KCONFIGLIB_LICENSE = ICS
PYTHON3_KCONFIGLIB_LICENSE_FILES = LICENSE.txt
HOST_PYTHON3_KCONFIGLIB_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
