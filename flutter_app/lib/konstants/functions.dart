


import 'package:geolocator/geolocator.dart';

double distanceBetween1(double lat1,double long1,double lat2,double long2){
  return Geolocator.distanceBetween(lat1, long1, lat2, long2);
}