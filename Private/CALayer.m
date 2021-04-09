#import "CALayer.h"

@implementation CALayer (DynamicCornerRadius)

- (void)setDynamicCornerRadius:(CGFloat)radius
{
    self.cornerRadius = radius;
    if (@available(iOS 13.0, *)) self.cornerCurve = kCACornerCurveContinuous;
    else self.continuousCorners = YES;
}

@end