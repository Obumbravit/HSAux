#import "HSAuxMSSwitchCell.h"

@implementation HSAuxMSSwitchCell

-(id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier
{
	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

	if (self)
	{
		[((UISwitch *)[self control]) setOnTintColor:[UIColor clearColor]];
		[((UISwitch *)[self control]) setThumbTintColor:([[self controlValue] boolValue] == true) ? [UIColor greenColor] : [UIColor redColor]];
	}

	return self;
}

- (void)setValue:(id)arg1
{
	[super setValue:arg1];
	[self setTitle:([arg1 boolValue] == true) ? @"Spotify" : @"Music"];
	[((UISwitch *)[self control]) setThumbTintColor:([arg1 boolValue] == true) ? [UIColor systemGreenColor] : [UIColor systemPinkColor]];
}

@end