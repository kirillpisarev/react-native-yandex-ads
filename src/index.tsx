import {
	NativeEventEmitter,
	NativeModules,
	EmitterSubscription,
} from "react-native"

type YandexAdsEvent = {
	type: string
	adId?: string
	payload?: any
}

type YandexAdsType = {
	showInterstitialAd(blockId: string, adId?: string | null): void

	addInterstitialEventListener(
		listener: (event: YandexAdsEvent) => void
	): EmitterSubscription

	showRewardedAd(
		blockId: string,
		userId?: string | null,
		adId?: string | null
	): void

	addRewardedEventListener(
		listener: (event: YandexAdsEvent) => void
	): EmitterSubscription
}

const { YandexAds } = NativeModules

const YandexAdsModule: YandexAdsType = {
	showInterstitialAd: (blockId, adId = null) => {
		YandexAds.showInterstitialAd(blockId, adId)
	},

	addInterstitialEventListener: (listener) => {
		const eventEmitter = new NativeEventEmitter(YandexAds)
		return eventEmitter.addListener("interstitial", listener)
	},

	showRewardedAd: (blockId, userId = null, adId = null) => {
		YandexAds.showRewardedAd(blockId, userId, adId)
	},

	addRewardedEventListener: (listener) => {
		const eventEmitter = new NativeEventEmitter(YandexAds)
		return eventEmitter.addListener("rewarded", listener)
	},
}

export default YandexAdsModule
