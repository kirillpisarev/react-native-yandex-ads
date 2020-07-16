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
    NSDictionary* params = [self buildEventParamsForType:@"onLoad" andAdId:nil];
    [self sendEventWithName:@"interstitial" body:params];
}

- (void)interstitialDidFailToLoadAd:(YMAInterstitialController *)interstitial error:(NSError *)error
{
    NSDictionary* params = [self buildEventParamsForType:@"failToLoad" andAdId:nil];
    NSMutableDictionary* mutableParams = [params mutableCopy];
    [mutableParams setValue:@{@"error": [error description]} forKey:@"payload"];
    [self sendEventWithName:@"interstitial" body:[mutableParams copy]];
}

- (void)interstitialDidFailToPresentAd:(YMAInterstitialController *)interstitial error:(NSError *)error
{
    NSDictionary* params = [self buildEventParamsForType:@"failToLoad" andAdId:nil];
    NSMutableDictionary* mutableParams = [params mutableCopy];
    [mutableParams setValue:@{@"error": [error description]} forKey:@"payload"];
    [self sendEventWithName:@"interstitial" body:[mutableParams copy]];
}

- (void)interstitialDidAppear:(YMAInterstitialController *)interstitial
{
    NSDictionary* params = [self buildEventParamsForType:@"onShown" andAdId:nil];
    [self sendEventWithName:@"interstitial" body:params];
}

- (void)interstitialDidDisappear:(YMAInterstitialController *)interstitial
{
    NSDictionary* params = [self buildEventParamsForType:@"onDismiss" andAdId:nil];
    [self sendEventWithName:@"interstitial" body:params];
}

#pragma mark - YMARewardedAdDelegate

-(void)rewardedAdDidLoadAd:(YMARewardedAd *)rewardedAd
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rewardedAd presentFromViewController:rootViewController];
    NSDictionary* params = [self buildEventParamsForType:@"onLoad" andAdId:nil];
    [self sendEventWithName:@"rewarded" body:params];
}

- (void)rewardedAdDidFailToLoadAd:(YMARewardedAd *)rewardedAd error:(NSError *)error
{
    NSDictionary* params = [self buildEventParamsForType:@"failToLoad" andAdId:nil];
    NSMutableDictionary* mutableParams = [params mutableCopy];
    [mutableParams setValue:@{@"error": [error description]} forKey:@"payload"];
    [self sendEventWithName:@"rewarded" body:[mutableParams copy]];
}

- (void)rewardedAdDidFailToPresentAd:(YMARewardedAd *)rewardedAd error:(NSError *)error
{
    NSDictionary* params = [self buildEventParamsForType:@"failToLoad" andAdId:nil];
    NSMutableDictionary* mutableParams = [params mutableCopy];
    [mutableParams setValue:@{@"error": [error description]} forKey:@"payload"];
    [self sendEventWithName:@"rewarded" body:[mutableParams copy]];
}

- (void)rewardedAdDidAppear:(YMARewardedAd *)rewardedAd
{
    NSDictionary* params = [self buildEventParamsForType:@"onShown" andAdId:nil];
    [self sendEventWithName:@"rewarded" body:params];
}

- (void)rewardedAdDidDisappear:(YMARewardedAd *)rewardedAd
{
    NSDictionary* params = [self buildEventParamsForType:@"onDismiss" andAdId:nil];
    [self sendEventWithName:@"rewarded" body:params];
}

- (void)rewardedAd:(YMARewardedAd *)rewardedAd didReward:(id<YMAReward>)reward
{
    NSDictionary* params = [self buildEventParamsForType:@"onRewarded" andAdId:nil];
    [self sendEventWithName:@"rewarded" body:params];
}

#pragma mark - Utility

-(NSDictionary*) buildEventParamsForType:(nonnull NSString*)type andAdId:(nullable NSString*)adId
{
    return @{
        @"type": type,
        @"adId": adId?: [NSNull null]
    };
}

#pragma mark - Setup

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"interstitial", @"rewarded"];
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
