SDKVERSION = latest
include theos/makefiles/common.mk

BUNDLE_NAME = Custom
Custom_FILES = Custom.m CustomActionMenuPluginListController.m
Custom_INSTALL_PATH = /Library/ActionMenu/Plugins/
Custom_FRAMEWORKS = UIKit
Custom_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

#internal-stage::
#	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
#	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Custom.plist$(ECHO_END)
