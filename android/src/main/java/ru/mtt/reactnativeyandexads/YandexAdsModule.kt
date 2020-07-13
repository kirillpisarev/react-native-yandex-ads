package ru.mtt.reactnativeyandexads

import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import com.yandex.mobile.ads.AdRequest
import com.yandex.mobile.ads.AdRequestError
import com.yandex.mobile.ads.InterstitialAd
import com.yandex.mobile.ads.InterstitialEventListener.SimpleInterstitialEventListener


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

  @ReactMethod
  fun showInterstitialAd(blockId: String, adId: String? = null) {
    val interstitialAd = InterstitialAd(reactContext)
    val adRequest = AdRequest.Builder().build()
    interstitialAd.blockId = blockId
    interstitialAd.interstitialEventListener = object : SimpleInterstitialEventListener() {
      override fun onInterstitialLoaded() {
        interstitialAd.show()
        val params = Arguments.createMap()
        params.putString("type", "onLoaded")
        params.putString("adId", adId)
        sendEvent("interstitial", params)
      }

      override fun onInterstitialFailedToLoad(error: AdRequestError?) {
        super.onInterstitialFailedToLoad(error)
        val params = Arguments.createMap()
        params.putString("type", "failToLoad")
        params.putString("adId", adId)
        sendEvent("interstitial", params)
      }

      override fun onInterstitialShown() {
        super.onInterstitialShown()
        val params = Arguments.createMap()
        params.putString("type", "onShown")
        params.putString("adId", adId)
        sendEvent("interstitial", params)
      }

      override fun onInterstitialDismissed() {
        super.onInterstitialDismissed()
        val params = Arguments.createMap()
        params.putString("type", "onDismiss")
        params.putString("adId", adId)
        sendEvent("interstitial", params)
      }

    }
    interstitialAd.loadAd(adRequest)
  }


}
