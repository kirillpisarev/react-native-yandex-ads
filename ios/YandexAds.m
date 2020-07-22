#import "YandexAds.h"
#import <YandexMobileAds/YandexMobileAds.h>

@interface YandexAds () <YMAInterstitialDelegate, YMARewardedAdDelegate>

@property (nonatomic, strong) YMAInterstitialController *interstitialAd;

@property (nonatomic, strong) YMARewardedAd *rewardedAd;

@end

@implementation YandexAds
{
  bool hasListeners;
}

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
    NSDictionary* params = [self buildEventParamsForType:@"interstitialDidLoadAd" andAdId:nil];
    [self lazySendEventWithName:@"interstitial" body:params];
}

- (void)interstitialDidFailToLoadAd:(YMAInterstitialController *)interstitial error:(NSError *)error
{
    NSDictionary* params = [self buildEventParamsForType:@"interstitialDidFailToLoadAd" andAdId:nil];
    NSMutableDictionary* mutableParams = [params mutableCopy];
    [mutableParams setValue:@{
        @"errorMessage": [error description],
        @"errorCode": [@([error code]) stringValue]
    } forKey:@"payload"];
    [self lazySendEventWithName:@"interstitial" body:[mutableParams copy]];
}

- (void)interstitialWillLeaveApplication:(YMAInterstitialController *)interstitial {
    NSDictionary* params = [self buildEventParamsForType:@"interstitialWillLeaveApplication" andAdId:nil];
    [self lazySendEventWithName:@"interstitial" body:params];
}

- (void)interstitialDidFailToPresentAd:(YMAInterstitialController *)interstitial error:(NSError *)error
{
    NSDictionary* params = [self buildEventParamsForType:@"interstitialDidFailToPresentAd" andAdId:nil];
    NSMutableDictionary* mutableParams = [params mutableCopy];
    [mutableParams setValue:@{
        @"errorMessage": [error description],
        @"errorCode": [@([error code]) stringValue]
    } forKey:@"payload"];
    [self lazySendEventWithName:@"interstitial" body:[mutableParams copy]];
}

- (void)interstitialWillAppear:(YMAInterstitialController *)interstitial {
    NSDictionary* params = [self buildEventParamsForType:@"interstitialWillAppear" andAdId:nil];
    [self lazySendEventWithName:@"interstitial" body:params];
}

- (void)interstitialDidAppear:(YMAInterstitialController *)interstitial
{
    NSDictionary* params = [self buildEventParamsForType:@"interstitialDidAppear" andAdId:nil];
    [self lazySendEventWithName:@"interstitial" body:params];
}

- (void)interstitialWillDisappear:(YMAInterstitialController *)interstitial {
    NSDictionary* params = [self buildEventParamsForType:@"interstitialWillDisappear" andAdId:nil];
    [self lazySendEventWithName:@"interstitial" body:params];
}

- (void)interstitialDidDisappear:(YMAInterstitialController *)interstitial
{
    NSDictionary* params = [self buildEventParamsForType:@"interstitialDidDisappear" andAdId:nil];
    [self lazySendEventWithName:@"interstitial" body:params];
}

- (void)interstitialWillPresentScreen:(UIViewController *)webBrowser {
    NSDictionary* params = [self buildEventParamsForType:@"interstitialWillPresentScreen" andAdId:nil];
    [self lazySendEventWithName:@"interstitial" body:params];
}

#pragma mark - YMARewardedAdDelegate

- (void)rewardedAd:(YMARewardedAd *)rewardedAd didReward:(id<YMAReward>)reward
{
    NSDictionary* params = [self buildEventParamsForType:@"rewardedAd:didReward" andAdId:nil];
    NSMutableDictionary* mutableParams = [params mutableCopy];
    [mutableParams setValue:@{
        @"rewardType": [reward type],
        @"rewardAmount": [@([reward amount]) stringValue]
    } forKey:@"payload"];
    [self lazySendEventWithName:@"rewarded" body:[mutableParams copy]];
}

-(void)rewardedAdDidLoadAd:(YMARewardedAd *)rewardedAd
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    [rewardedAd presentFromViewController:rootViewController];
    NSDictionary* params = [self buildEventParamsForType:@"rewardedAdDidLoadAd" andAdId:nil];
    [self lazySendEventWithName:@"rewarded" body:params];
}

- (void)rewardedAdDidFailToLoadAd:(YMARewardedAd *)rewardedAd error:(NSError *)error
{
    NSDictionary* params = [self buildEventParamsForType:@"rewardedAdDidFailToLoadAd" andAdId:nil];
    NSMutableDictionary* mutableParams = [params mutableCopy];
    [mutableParams setValue:@{
        @"errorMessage": [error description],
        @"errorCode": [@([error code]) stringValue]
    } forKey:@"payload"];
    [self lazySendEventWithName:@"rewarded" body:[mutableParams copy]];
}

- (void)rewardedAdWillLeaveApplication:(YMARewardedAd *)rewardedAd {
    NSDictionary* params = [self buildEventParamsForType:@"rewardedAdWillLeaveApplication" andAdId:nil];
    [self lazySendEventWithName:@"rewarded" body:params];
}

- (void)rewardedAdDidFailToPresentAd:(YMARewardedAd *)rewardedAd error:(NSError *)error
{
    NSDictionary* params = [self buildEventParamsForType:@"rewardedAdDidFailToPresentAd" andAdId:nil];
    NSMutableDictionary* mutableParams = [params mutableCopy];
    [mutableParams setValue:@{
        @"errorMessage": [error description],
        @"errorCode": [@([error code]) stringValue]
    } forKey:@"payload"];
    [self lazySendEventWithName:@"rewarded" body:[mutableParams copy]];
}

- (void)rewardedAdWillAppear:(YMARewardedAd *)rewardedAd {
    NSDictionary* params = [self buildEventParamsForType:@"rewardedAdWillAppear" andAdId:nil];
    [self lazySendEventWithName:@"rewarded" body:params];
}

- (void)rewardedAdDidAppear:(YMARewardedAd *)rewardedAd
{
    NSDictionary* params = [self buildEventParamsForType:@"rewardedAdDidAppear" andAdId:nil];
    [self lazySendEventWithName:@"rewarded" body:params];
}

- (void)rewardedAdWillDisappear:(YMARewardedAd *)rewardedAd {
    NSDictionary* params = [self buildEventParamsForType:@"rewardedAdWillDisappear" andAdId:nil];
    [self lazySendEventWithName:@"rewarded" body:params];
}

- (void)rewardedAdDidDisappear:(YMARewardedAd *)rewardedAd
{
    NSDictionary* params = [self buildEventParamsForType:@"rewardedAdDidDisappear" andAdId:nil];
    [self lazySendEventWithName:@"rewarded" body:params];
}

- (void)rewardedAd:(YMARewardedAd *)rewardedAd willPresentScreen:(UIViewController *)viewController {
    NSDictionary* params = [self buildEventParamsForType:@"rewardedAd:willPresentScreen" andAdId:nil];
    [self lazySendEventWithName:@"rewarded" body:params];
}


#pragma mark - Utility

-(NSDictionary*) buildEventParamsForType:(nonnull NSString*)type andAdId:(nullable NSString*)adId
{
    return @{
        @"type": type,
        @"adId": adId?: [NSNull null]
    };
}

- (void)lazySendEventWithName:(NSString *)eventName body:(id)body {
    if (hasListeners) {
        [self sendEventWithName:eventName body:body];
    }
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

-(void)startObserving {
    hasListeners = YES;
}

-(void)stopObserving {
    hasListeners = NO;
}

@end
