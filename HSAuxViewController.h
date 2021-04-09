#import <HSWidgets/HSWidgetViewController.h>
#import "HSAuxView.h"

@interface HSAuxViewController : HSWidgetViewController
@property (nonatomic, strong) HSAuxView * hsAuxView;
- (void)updateHSAuxSettingsIsInitial:(bool)initial isKey:(NSString *)key;
@end
