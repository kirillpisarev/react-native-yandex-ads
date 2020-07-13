import {
	NativeEventEmitter,
	NativeModules,
	EmitterSubscription,
} from "react-native"

type YandexAdsType = {
	showInterstitialAd(blockId: string, adId?: string | null): void
	addInterstitialEventListener(
		listener: (...args: any[]) => void
	): EmitterSubscription
}

const { YandexAds } = NativeModules

export default {
	showInterstitialAd: (blockId, adId = null) =>
		YandexAds.showInterstitialAd(blockId, adId),
	addInterstitialEventListener: (listener) => {
		const eventEmitter = new NativeEventEmitter(YandexAds)
		return eventEmitter.addListener("interstitial", listener)
	},
} as YandexAdsType
