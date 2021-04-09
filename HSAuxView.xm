#import "HSAuxView.h"

@implementation HSAuxView

- (id)initWithFrame:(CGRect)frame andRadius:(CGFloat)radius
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat frameSection = frame.size.height / 7;
        UIColor * defaultColor = nil;
        if (@available(iOS 12, *)) defaultColor = (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ?  [UIColor lightGrayColor] : [UIColor darkGrayColor];
        else defaultColor = [UIColor grayColor];

        //music updates
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHSAux) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];

        //blur
        self.hsAuxBlur = [NSClassFromString(@"MTMaterialView")materialViewWithRecipe:1 configuration:1];
        self.hsAuxBlur.frame = frame;
        self.hsAuxBlur.userInteractionEnabled = NO;
        [self.hsAuxBlur.layer setDynamicCornerRadius:radius];
        [self addSubview:self.hsAuxBlur];

        //music filler icon
        if (!self.iconBundle) self.iconBundle = @"com.apple.Music";
        if ([%c(SvgctApps) appExistsFromBundle:self.iconBundle]) self.hsAuxMusicIconImage = [%c(SvgctApps) generateAppIconFromBundle:self.iconBundle];
        else self.hsAuxMusicIconImage = [UIImage systemImageNamed:@"music.note"];

        //artwork
        self.hsAuxArtwork = [[UIImageView alloc] initWithImage:self.hsAuxMusicIconImage];
        self.hsAuxArtwork.frame = CGRectMake(frameSection, frameSection, frameSection * 5, frameSection * 5);
        [self.hsAuxArtwork.layer setDynamicCornerRadius:(radius / 7) * 5];
        self.hsAuxArtwork.clipsToBounds = YES;
        self.hsAuxArtwork.userInteractionEnabled = YES;
        self.hsAuxArtwork.tag = 69;
        [self addSubview:self.hsAuxArtwork];

        UITapGestureRecognizer * pauseRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pausePlay:)];
        pauseRecognizer.numberOfTapsRequired = 2;
        [self.hsAuxArtwork addGestureRecognizer:pauseRecognizer];

        //pause blur
	    self.hsAuxPauseBlur = [[UIVisualEffectView alloc]initWithEffect:nil];
        self.hsAuxPauseBlur.frame = CGRectMake(0, 0, self.hsAuxArtwork.frame.size.width, self.hsAuxArtwork.frame.size.height);
        self.hsAuxPauseBlur.userInteractionEnabled = NO;
        [self.hsAuxPauseBlur.layer setDynamicCornerRadius:self.hsAuxArtwork.layer.cornerRadius];
        [self.hsAuxArtwork addSubview:self.hsAuxPauseBlur];

        //pause image
        self.hsAuxPausedImage = [[UIImageView alloc] initWithImage:[[UIImage systemImageNamed:@"pause.circle"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        self.hsAuxPausedImage.tintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        self.hsAuxPausedImage.frame = CGRectMake(self.hsAuxPauseBlur.frame.size.width / 4, self.hsAuxPauseBlur.frame.size.height / 4, self.hsAuxPauseBlur.frame.size.width / 2, self.hsAuxPauseBlur.frame.size.height / 2);
        self.hsAuxPausedImage.hidden = true;
        [[self.hsAuxPauseBlur contentView] addSubview:self.hsAuxPausedImage];

        //title label
        self.hsAuxTitleLabel = [[UILabel alloc] init];
        self.hsAuxTitleLabel.frame = CGRectMake(frameSection * 7, frameSection, frame.size.width - frameSection * 8, (frameSection * 5) / 2);
        self.hsAuxTitleLabel.numberOfLines = 1;
        self.hsAuxTitleLabel.textColor = defaultColor;
        self.hsAuxTitleLabel.backgroundColor = [UIColor clearColor];
        self.hsAuxTitleLabel.text = @"Now";
        self.hsAuxTitleLabel.font = [UIFont systemFontOfSize:self.hsAuxTitleLabel.frame.size.height weight:UIFontWeightSemibold];
        self.hsAuxTitleLabel.userInteractionEnabled = NO;
        [self.hsAuxTitleLabel setMarqueeEnabled:YES];
        [self.hsAuxTitleLabel setMarqueeRunning:NO];
        [self.hsAuxTitleLabel _setLineBreakMode:1];
        [self addSubview:self.hsAuxTitleLabel];

        //subtitle label
        self.hsAuxSubtitleLabel = [[UILabel alloc] init];
        self.hsAuxSubtitleLabel.frame = CGRectMake(frameSection * 7, frameSection + ((frameSection * 5) / 2), frame.size.width - frameSection * 8, (frameSection * 5) / 2);
        self.hsAuxSubtitleLabel.numberOfLines = 1;
        self.hsAuxSubtitleLabel.textColor = defaultColor;
        self.hsAuxSubtitleLabel.backgroundColor = [UIColor clearColor];
        self.hsAuxSubtitleLabel.text = @"Playing";
        self.hsAuxSubtitleLabel.font = [UIFont systemFontOfSize:self.hsAuxSubtitleLabel.frame.size.height];
        self.hsAuxSubtitleLabel.userInteractionEnabled = NO;
        [self.hsAuxSubtitleLabel setMarqueeEnabled:YES];
        [self.hsAuxSubtitleLabel setMarqueeRunning:NO];
        [self.hsAuxSubtitleLabel _setLineBreakMode:1];
        [self addSubview:self.hsAuxSubtitleLabel];
    }
    return self;
}

- (void)updateHSAux
{
    if ([%c(SvgctApps) appExistsFromBundle:self.iconBundle]) self.hsAuxMusicIconImage = [%c(SvgctApps) generateAppIconFromBundle:self.iconBundle];
    else self.hsAuxMusicIconImage = [UIImage systemImageNamed:@"music.note"];
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) 
    {
        NSDictionary * dict=(__bridge NSDictionary *)(information);
        NSString * trackTitle = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle];

        UIColor * defaultColor = nil;
        if (@available(iOS 12, *)) defaultColor = (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ?  [UIColor lightGrayColor] : [UIColor darkGrayColor];
        else defaultColor = [UIColor grayColor];

        if (!trackTitle)
        {
            self.hsAuxPlaying = false;
            [UIView transitionWithView:self.hsAuxArtwork duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.hsAuxArtwork.image = self.hsAuxMusicIconImage;
            } completion:^(BOOL finished) {}];
            [UIView transitionWithView:self.hsAuxTitleLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.hsAuxTitleLabel.text = @"Now";
                [self.hsAuxTitleLabel setMarqueeRunning:NO];
                self.hsAuxTitleLabel.textColor = defaultColor;
            } completion:^(BOOL finished) {}];
            [UIView transitionWithView:self.hsAuxSubtitleLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.hsAuxSubtitleLabel.text = @"Playing";
                [self.hsAuxSubtitleLabel setMarqueeRunning:NO];
                self.hsAuxSubtitleLabel.textColor = defaultColor;
            } completion:^(BOOL finished) {}];
        }
        else
        {
            self.hsAuxPlaying = true;
            NSData * artworkData = [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];
            UIImage * nowPlayingArtwork = [UIImage imageWithData:artworkData];
            UIColor * musicColor = nil;
            if (self.hsAuxTitleLabel.tag == 1 || self.hsAuxSubtitleLabel.tag == 1) musicColor = [%c(SvgctColors) getMainColourInImage:nowPlayingArtwork atIndex:-1 withDetail:1];
            [UIView transitionWithView:self.hsAuxArtwork duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.hsAuxArtwork.image = nowPlayingArtwork;
            } completion:nil];
            [UIView transitionWithView:self.hsAuxTitleLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.hsAuxTitleLabel.text = [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle];
                [self.hsAuxTitleLabel setMarqueeRunning:YES];
                self.hsAuxTitleLabel.textColor = (self.hsAuxTitleLabel.tag == 1) ? musicColor : defaultColor;
            } completion:^(BOOL finished) {}];
            [UIView transitionWithView:self.hsAuxSubtitleLabel duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                self.hsAuxSubtitleLabel.text = [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist];
                [self.hsAuxSubtitleLabel setMarqueeRunning:YES];
                self.hsAuxSubtitleLabel.textColor = (self.hsAuxSubtitleLabel.tag == 1) ? musicColor : defaultColor;
            } completion:^(BOOL finished) {}];
        }
    });
}

- (void)pausePlay:(id)sender
{
    UITapGestureRecognizer * tapRecognizer = (UITapGestureRecognizer *)sender;
    MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean isPlayingNow)
    {
        [UIView transitionWithView:self.hsAuxPauseBlur duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.hsAuxPauseBlur.effect = (isPlayingNow) ? [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular] : nil;
        }
        completion:^(BOOL finished)
        {
            if ([tapRecognizer.view tag] == 69)
            {
                if (isPlayingNow) MRMediaRemoteSendCommand(kMRPause, nil);
                else MRMediaRemoteSendCommand(kMRPlay, nil);
            }
        }];
        [UIView transitionWithView:self.hsAuxPausedImage duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.hsAuxPausedImage.hidden = (isPlayingNow) ? false : true;
        }
        completion:nil];
    });
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    CGFloat frameSection = frame.size.height / 7;

    [UIView animateWithDuration:1.0 animations:^{
        self.hsAuxBlur.frame = frame;
        self.hsAuxArtwork.frame = CGRectMake(frameSection, frameSection, frameSection * 5, frameSection * 5);
        self.hsAuxPauseBlur.frame = CGRectMake(0, 0, self.hsAuxArtwork.frame.size.width, self.hsAuxArtwork.frame.size.height);
        self.hsAuxPausedImage.frame = CGRectMake(self.hsAuxPauseBlur.frame.size.width / 4, self.hsAuxPauseBlur.frame.size.height / 4, self.hsAuxPauseBlur.frame.size.width / 2, self.hsAuxPauseBlur.frame.size.height / 2);
        self.hsAuxTitleLabel.frame = CGRectMake(frameSection * 7, frameSection, frame.size.width - frameSection * 8, (frameSection * 5) / 2);
        self.hsAuxTitleLabel.font = [UIFont systemFontOfSize:self.hsAuxTitleLabel.frame.size.height weight:UIFontWeightSemibold];
        self.hsAuxSubtitleLabel.frame = CGRectMake(frameSection * 7, frameSection + ((frameSection * 5) / 2), frame.size.width - frameSection * 8, (frameSection * 5) / 2);
        self.hsAuxSubtitleLabel.font = [UIFont systemFontOfSize:self.hsAuxSubtitleLabel.frame.size.height];
    }];
}

- (void)traitCollectionDidChange:(id)arg1
{
    [super traitCollectionDidChange:arg1];

    UIColor * defaultColor = nil;
    if (@available(iOS 12, *)) defaultColor = (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) ?  [UIColor lightGrayColor] : [UIColor darkGrayColor];
    else defaultColor = [UIColor grayColor];

    if (!self.hsAuxPlaying)
    {
        self.hsAuxTitleLabel.textColor = defaultColor;
        self.hsAuxSubtitleLabel.textColor = defaultColor;
    }
}

@end