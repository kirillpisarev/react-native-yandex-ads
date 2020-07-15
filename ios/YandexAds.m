#import "YandexAds.h"
#import <YandexMobileAds/YandexMobileAds.h>

@interface YandexAds () <YMAInterstitialDelegate, YMARewardedAdDelegate>

@property (nonatomic, strong) YMAInterstitialController *interstitialAd;

@property (nonatomic, strong) YMARewardedAd *rewardedAd;

@end

@implementation YandexAds

RCT_EXPORT_MODULE()

#pragma mark - Exports

RCT_REMAP_METHOD(showInterstitialAd,
                 showInterstitialAdForBlockId:(nonnull NSString*)blockId withAdId:(nullable NSString*)adId)
{
    self.interstitialAd = [[YMAInterstitialController alloc] initWithBlockID:blockId];
    self.interstitialAd.delegate = self;
    [self.interstitialAd load];
}

RCT_REMAP_METHOD(showRewardedAd,
                 showRewardedAdForBlockId:(nonnull NSString*)blockId
                  forUserId:(nullable NSString*) userId
                 withAdId:(nullable NSString*)adId)
{
    self.rewardedAd = [[YMARewardedAd alloc] initWithBlockID:blockId];
    self.rewardedAd.delegate = self;
    if (userId != nil) {
        self.rewardedAd.userID = userId;
    }
    [self.rewardedAd load];
}

#pragma mark - YMAInterstitialDelegate

-(void)interstitialDidLoadAd:(YMAInterstitialController *)interstitial
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [interstitial presentInterstitialFromViewController:rootViewController];
}

-(void)rewardedAdDidLoadAd:(YMARewardedAd *)rewardedAd {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rewardedAd presentFromViewController:rootViewController];
}

#pragma mark - Setup

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
