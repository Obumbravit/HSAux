@import UIKit;
#import "Private/CALayer.h"
#import "MediaRemote.h"

//blur
@interface MTMaterialView : UIView
+ (id)materialViewWithRecipe:(long long)arg1 configuration:(long long)arg2;
@end

//marquee
@interface UILabel (HSAux)
- (void)setMarqueeEnabled:(BOOL)arg1;
- (void)setMarqueeRunning:(BOOL)arg1;
- (void)_setLineBreakMode:(long long)arg1;
@end

@interface SvgctApps : NSObject
+ (UIImage *)generateAppIconFromBundle:(NSString *)bundle;
+ (bool)appExistsFromBundle:(NSString *)bundle;
@end

@interface SvgctColors : NSObject
+ (UIColor *)getMainColourInImage:(UIImage *)image atIndex:(int)colorIndex withDetail:(int)detail;
@end

@interface HSAuxView : UIView
@property (nonatomic, assign) NSString * iconBundle;
@property (nonatomic, strong) MTMaterialView * hsAuxBlur;
@property (nonatomic, strong) UIImage * hsAuxMusicIconImage;
@property (nonatomic, strong) UIImageView * hsAuxArtwork;
@property (nonatomic, strong) UIVisualEffectView * hsAuxPauseBlur;
@property (nonatomic, strong) UIImageView * hsAuxPausedImage;
@property (nonatomic, strong) UILabel * hsAuxTitleLabel;
@property (nonatomic, strong) UILabel * hsAuxSubtitleLabel;
@property (nonatomic, assign) BOOL hsAuxPlaying;
- (id)initWithFrame:(CGRect)frame andRadius:(CGFloat)radius;
- (void)updateHSAux;
- (void)pausePlay:(id)sender;
@end