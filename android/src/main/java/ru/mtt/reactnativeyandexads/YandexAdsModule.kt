package ru.mtt.reactnativeyandexads

import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import com.yandex.mobile.ads.AdRequest
import com.yandex.mobile.ads.AdRequestError
import com.yandex.mobile.ads.InterstitialAd
import com.yandex.mobile.ads.InterstitialEventListener
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
		interstitialAd.interstitialEventListener = object : InterstitialEventListener {

			override fun onInterstitialLoaded() {
				interstitialAd.show()
				sendEvent("interstitial", buildEventParams("onInterstitialLoaded", adId))
			}

			override fun onInterstitialFailedToLoad(error: AdRequestError?) {
				val params = buildEventParams("onInterstitialFailedToLoad", adId)
				if (error != null) {
					val payload = Arguments.createMap()
					payload.putString("errorMessage", error.toString())
					payload.putInt("errorCode", error.code)
					params.putMap("payload", payload)
				}
				sendEvent("interstitial", params)
			}

			override fun onInterstitialShown() {
				sendEvent("interstitial", buildEventParams("onInterstitialShown", adId))
			}

			override fun onInterstitialDismissed() {
				sendEvent("interstitial", buildEventParams("onInterstitialDismissed", adId))
			}

			override fun onAdClosed() {
				sendEvent("interstitial", buildEventParams("onAdClosed", adId))
			}

			override fun onAdLeftApplication() {
				sendEvent("interstitial", buildEventParams("onAdLeftApplication", adId))
			}

			override fun onAdOpened() {
				sendEvent("interstitial", buildEventParams("onAdOpened", adId))
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
		rewardedAd.setRewardedAdEventListener(object : RewardedAdEventListener() {

			override fun onAdFailedToLoad(error: AdRequestError?) {
				val params = buildEventParams("onAdFailedToLoad", adId)
				if (error != null) {
					val payload = Arguments.createMap()
					payload.putString("errorMessage", error.toString())
					payload.putInt("errorCode", error.code)
					params.putMap("payload", payload)
				}
				sendEvent("rewarded", params)
			}

			override fun onAdDismissed() {
				sendEvent("rewarded", buildEventParams("onAdDismissed", adId))
			}

			override fun onRewarded(reward: Reward) {
				val params = buildEventParams("onRewarded", adId)
				val payload = Arguments.createMap()
				payload.putString("rewardType", reward.type)
				payload.putInt("rewardAmount", reward.amount)
				params.putMap("payload", payload)
				sendEvent("rewarded", params)
			}

			override fun onAdShown() {
				sendEvent("rewarded", buildEventParams("onAdShown", adId))
			}

			override fun onAdLoaded() {
				sendEvent("rewarded", buildEventParams("onAdLoaded", adId))
				rewardedAd.show()
			}

			override fun onAdClosed() {
				sendEvent("rewarded", buildEventParams("onAdClosed", adId))
			}

			override fun onAdLeftApplication() {
				sendEvent("rewarded", buildEventParams("onAdLeftApplication", adId))
			}

			override fun onAdOpened() {
				sendEvent("rewarded", buildEventParams("onAdOpened", adId))
			}

		})

		rewardedAd.loadAd(adRequest)
	}


}
