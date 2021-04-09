export THEOS = /var/theos
export ARCHS = arm64 arm64e

THEOS_DEVICE_IP = 10.0.0.26
INSTALL_TARGET_PROCESSES = SpringBoard
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 13.3

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HSAux
HSAux_FILES = HSAuxView.xm HSAuxViewController.m HSAuxPreferencesViewController.mm $(wildcard *.xm *.mm *.m Private/*.m)
HSAux_FRAMEWORKS = UIKit
HSAux_PRIVATE_FRAMEWORKS = MediaRemote Preferences
HSAux_EXTRA_FRAMEWORKS = HSWidgets Svgct
HSAux_INSTALL_PATH = /Library/HSWidgets
HSAux_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
