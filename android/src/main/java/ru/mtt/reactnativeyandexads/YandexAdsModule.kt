package ru.mtt.reactnativeyandexads

import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import com.yandex.mobile.ads.AdRequest
import com.yandex.mobile.ads.AdRequestError
import com.yandex.mobile.ads.InterstitialAd
import com.yandex.mobile.ads.InterstitialEventListener.SimpleInterstitialEventListener
import com.yandex.mobile.ads.rewarded.Reward
import com.yandex.mobile.ads.rewarded.RewardedAd
import com.yandex.mobile.ads.rewarded.RewardedAdEventListener


class YandexAdsModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

	private val reactContext: ReactApplicationContext = reactContext

	override fun getName(): String {
		return "YandexAds"
	}

	private fun sendEvent(eventName: String, params: WritableMap) {
		reactContext
			.getJSModule(RCTDeviceEventEmitter::class.java)
			.emit(eventName, params)
	}

	private fun buildEventParams(type: String, adId: String? = null): WritableMap {
		val params = Arguments.createMap()
		params.putString("type", type)
		params.putString("adId", adId)
		return params
	}

	@ReactMethod
	fun showInterstitialAd(blockId: String, adId: String? = null) {
		val interstitialAd = InterstitialAd(reactContext)
		val adRequest = AdRequest.Builder().build()
		interstitialAd.blockId = blockId
		interstitialAd.interstitialEventListener = object : SimpleInterstitialEventListener() {
			override fun onInterstitialLoaded() {
				interstitialAd.show()
				sendEvent("interstitial", buildEventParams("onLoad", adId))
			}

			override fun onInterstitialFailedToLoad(error: AdRequestError?) {
				val params = buildEventParams("failToLoad", adId)
				val payload = Arguments.createMap()
				payload.putString("error", error.toString())
				params.putMap("payload", payload)
				sendEvent("interstitial", params)
			}

			override fun onInterstitialShown() {
				sendEvent("interstitial", buildEventParams("onShown", adId))
			}

			override fun onInterstitialDismissed() {
				sendEvent("interstitial", buildEventParams("onDismiss", adId))
			}

		}
		interstitialAd.loadAd(adRequest)
	}

	@ReactMethod
	fun showRewardedAd(blockId: String, userId: String? = null, adId: String? = null) {
		val rewardedAd = RewardedAd(reactContext)
		val adRequest = AdRequest.Builder().build()
		rewardedAd.blockId = blockId
		if (userId != null) {
			rewardedAd.setUserId(userId)
		}
		rewardedAd.setRewardedAdEventListener(object : RewardedAdEventListener.SimpleRewardedAdEventListener() {
			override fun onAdFailedToLoad(p0: AdRequestError?) {
				val params = buildEventParams("failToLoad", adId)
				val payload = Arguments.createMap()
				payload.putString("error", p0.toString())
				params.putMap("payload", payload)
				sendEvent("rewarded", params)
			}

			override fun onAdDismissed() {
				sendEvent("rewarded", buildEventParams("onDismiss", adId))
			}

			override fun onRewarded(p0: Reward) {
				sendEvent("rewarded", buildEventParams("onRewarded", adId))
			}

			override fun onAdShown() {
				sendEvent("rewarded", buildEventParams("onShown", adId))
			}

			override fun onAdLoaded() {
				sendEvent("rewarded", buildEventParams("onDismiss", adId))
				rewardedAd.show()
			}

		})

		rewardedAd.loadAd(adRequest)
	}


}
