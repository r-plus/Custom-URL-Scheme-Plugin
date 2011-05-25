#import <Preferences/Preferences.h>

@interface CustomActionMenuPluginListController: PSListController {
}
@end

@implementation CustomActionMenuPluginListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Custom" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
