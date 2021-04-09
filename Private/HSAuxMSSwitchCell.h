#import <Preferences/PSTableCell.h> 

@interface PSControlTableCell : PSTableCell
- (UIControl *)control;
- (void)setTitle:(id)arg1;
@end
@interface PSSwitchTableCell : PSControlTableCell
- (void)setValue:(id)arg1;
- (id)initWithStyle:(int)style reuseIdentifier:(id)identifier specifier:(id)specifier;
- (id)controlValue;
@end

@interface HSAuxMSSwitchCell : PSSwitchTableCell
@end