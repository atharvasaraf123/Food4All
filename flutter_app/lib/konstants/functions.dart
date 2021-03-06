


import 'package:android_intent/android_intent.dart';
import 'package:geolocator/geolocator.dart';

int distanceBetween1(double lat1,double long1,double lat2,double long2){
  return (Geolocator.distanceBetween(lat1, long1, lat2, long2)/1000).floor();
}

openLocationSetting() async {
  final AndroidIntent intent = new AndroidIntent(
    action: 'android.settings.LOCATION_SOURCE_SETTINGS',
  );
  await intent.launch();
}