# react-native-yandex-ads

ReactNative port for Yandex Mobile Ads SDK

## Installation

1. `npm install react-native-yandex-ads --save` or `yarn add react-native-yandex-ads`
2. If React Native version <= 0.59: \
  `react-native link react-native-yandex-ads`
3. iOS only
  * if `${PROJECT_DIR}/ios/Podfile` exists: \
  `npx pod-install`
  * if `${PROJECT_DIR}/ios/Podfile` don't exists: \
  [Setup Yandex Mobile Ads SDK](https://yandex.ru/dev/mobile-ads/) and placed frameworks at `${PROJECT_DIR}/ios/Frameworks`

## Usage

```js

import YandexAds from "react-native-yandex-ads"

YandexAds.showInterstitialAd("R-M-DEMO-400x240-context")
YandexAds.showRewardedAd("R-M-DEMO-rewarded-client-side-rtb", "some-user-id")

YandexAds.addInterstitialEventListener((event) => console.log(event))
YandexAds.addRewardedEventListener((event) => console.log(event))

```

For comprehensive usage example see `example/src/App.tsx`

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
