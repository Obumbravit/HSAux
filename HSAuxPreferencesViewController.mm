#import "HSAuxPreferencesViewController.h"

@implementation HSAuxPreferencesViewController

- (NSArray *)specifiers
{
	if (!_specifiers) _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	return _specifiers;
}

- (void)setmsswitch:(id)value specifier:(PSSpecifier *)specifier
{
	[super setPreferenceValue:value specifier:specifier];
	[self reloadSpecifier:specifier animated:true];
}

@end