import { NativeModules } from 'react-native';

type YandexAdsType = {
  multiply(a: number, b: number): Promise<number>;
};

const { YandexAds } = NativeModules;

export default YandexAds as YandexAdsType;
