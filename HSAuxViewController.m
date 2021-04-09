#import "HSAuxViewController.h"

@implementation HSAuxViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[[NSOperationQueue currentQueue] addOperationWithBlock:^{
		self.hsAuxView = [[HSAuxView alloc] initWithFrame:[self calculatedFrame] andRadius:self.cornerRadius];
		[self.view addSubview:self.hsAuxView];
		self.hsAuxView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.hsAuxView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
		[self.hsAuxView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
		[self.hsAuxView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
		[self.hsAuxView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
		[self updateHSAuxSettingsIsInitial:true isKey:nil];
	}];
}

+ (HSWidgetSize)minimumSize
{
	return HSWidgetSizeMake(1, 2); // least amount of rows and cols the widget needs
}

- (BOOL)isAccessoryTypeEnabled:(AccessoryType)accessoryType
{
	if (accessoryType == AccessoryTypeExpand)
	{
		HSWidgetSize finalExpandedSize = HSWidgetSizeAdd(self.widgetFrame.size, 1, 2);
		return [self containsSpaceToExpandOrShrinkToWidgetSize:finalExpandedSize];
	}
	else if (accessoryType == AccessoryTypeShrink)
	{
		return self.widgetFrame.size.numRows > 1 && self.widgetFrame.size.numCols > 2;
	}

	// anything else we don't support but let super class handle it incase new accessory types are added
	return [super isAccessoryTypeEnabled:accessoryType];
}

- (void)accessoryTypeTapped:(AccessoryType)accessoryType
{
	if (accessoryType == AccessoryTypeExpand)
	{
		HSWidgetSize finalExpandSize = HSWidgetSizeAdd(self.widgetFrame.size, 1, 2);
		[self updateForExpandOrShrinkToWidgetSize:finalExpandSize];
		[self.hsAuxView setFrame:self.hsAuxView.frame];
	}
	else if (accessoryType == AccessoryTypeShrink)
	{
		HSWidgetSize finalShrinkSize = HSWidgetSizeAdd(self.widgetFrame.size, -1, -2);
		[self updateForExpandOrShrinkToWidgetSize:finalShrinkSize];
		[self.hsAuxView setFrame:self.hsAuxView.frame];
	}
}

- (void)setRequestedSize:(CGSize)size
{
	[super setRequestedSize:size];
}

- (void)setWidgetOptionValue:(id<NSCoding>)object forKey:(NSString *)key
{
	[super setWidgetOptionValue:object forKey:key];
	[self updateHSAuxSettingsIsInitial:false isKey:key];
}

- (void)updateHSAuxSettingsIsInitial:(bool)initial isKey:(NSString *)key
{
	if ([key isEqualToString:@"aColor"] || initial) self.hsAuxView.hsAuxTitleLabel.tag = ([widgetOptions[@"aColor"] boolValue]) ?: ([widgetOptions[@"aColor"] boolValue]);// : 0;
	if ([key isEqualToString:@"bColor"] || initial) self.hsAuxView.hsAuxSubtitleLabel.tag = ([widgetOptions[@"bColor"] boolValue]) ?: ([widgetOptions[@"bColor"] boolValue]);// : 0;
	if ([key isEqualToString:@"icon"] || initial) self.hsAuxView.iconBundle = ([widgetOptions[@"icon"] boolValue]) ? @"com.spotify.client" : @"com.apple.Music";
	[self.hsAuxView updateHSAux];
}

@end