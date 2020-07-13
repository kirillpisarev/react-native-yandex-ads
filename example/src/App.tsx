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

	const onInterstitialEvent = React.useCallback((event) => {
		console.log("event", event)
	}, [])

	React.useEffect(() => {
		const interstitialListener = YandexAds.addInterstitialEventListener(
			onInterstitialEvent
		)
		return interstitialListener.remove
	}, [onInterstitialEvent])

	return (
		<View style={styles.container}>
			<TouchableHighlight
				onPress={showInterstitial}
				style={styles.button}
			>
				<Text>Show interstitial</Text>
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
	},
})
