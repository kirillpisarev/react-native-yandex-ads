import * as React from "react"
import { StyleSheet, View, Text, TouchableHighlight } from "react-native"
import YandexAds from "react-native-yandex-ads"

export default function App() {
	const showInterstitial = React.useCallback(() => {
		YandexAds.showInterstitialAd(
			"R-M-DEMO-400x240-context",
			Math.random() + ""
		)
	}, [])

	const showRewarded = React.useCallback(() => {
		YandexAds.showRewardedAd(
			"R-M-DEMO-rewarded-client-side-rtb",
			Math.random() + ""
		)
	}, [])

	const onInterstitialEvent = React.useCallback((event) => {
		console.log("event", event)
	}, [])

	const onRewardedEvent = React.useCallback((event) => {
		console.log("event", event)
	}, [])

	React.useEffect(() => {
		const interstitialListener = YandexAds.addInterstitialEventListener(
			onInterstitialEvent
		)
		const rewardedListener = YandexAds.addRewardedEventListener(
			onRewardedEvent
		)
		return () => {
			interstitialListener.remove()
			rewardedListener.remove()
		}
	}, [onInterstitialEvent, onRewardedEvent])

	return (
		<View style={styles.container}>
			<TouchableHighlight
				onPress={showInterstitial}
				style={styles.button}
			>
				<Text>Show interstitial</Text>
			</TouchableHighlight>

			<TouchableHighlight onPress={showRewarded} style={styles.button}>
				<Text>Show rewarded</Text>
			</TouchableHighlight>
		</View>
	)
}

const styles = StyleSheet.create({
	container: {
		flex: 1,
		alignItems: "stretch",
		justifyContent: "center",
		marginHorizontal: "5%",
	},
	button: {
		backgroundColor: "cyan",
		justifyContent: "center",
		alignItems: "center",
		paddingVertical: 10,
		marginVertical: 10,
	},
})
