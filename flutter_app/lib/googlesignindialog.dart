import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Dashboard.dart';
import 'package:flutter_app/ResponsiveWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import 'konstants/functions.dart';
class googlesignindialog extends StatefulWidget {
  @override
  _googlesignindialogState createState() => _googlesignindialogState();
}

class _googlesignindialogState extends State<googlesignindialog> {

  String phoneNumber;
  String city;
  TextEditingController cityController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  final _formKey = GlobalKey<FormState>();
  CollectionReference userCol = FirebaseFirestore.instance.collection('users');

  getUserLocation() async {
    //call this async method from whereever you need

    LocationData myLocation;
    String error;
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        await openLocationSetting();
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return Future.error(
              'Location permissions are permanently denied, we cannot request permissions.');
        }

        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error(
              'Location permissions are denied');
        }
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position position= await Geolocator.getCurrentPosition();
      final coordinates =
      new Coordinates(position.latitude, position.longitude);
      var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(
          ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
      setState(() {
        city = addresses.first.locality;
        cityController.text=city;
      });
    } on PlatformException catch (e) {
      print(e.code);
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }catch(e){
      print(e.toString());
    }

  }

  addData()async{
    Map<String,dynamic>mapp=Map();
    mapp['city']=city;
    mapp['phone']=phoneNumber;
    await userCol.doc(FirebaseAuth.instance.currentUser.uid).update(mapp).then((value){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>Dashboard()), (route) => false);
    }).catchError((onError){
      Fluttertoast.showToast(msg: onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery
        .of(context)
        .size
        .height;
   double _width = MediaQuery
        .of(context)
        .size
        .width;
    double _pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    bool _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    bool _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
            return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                      height: 250.0,
                      child: Center(
                        child: Scaffold(
                          body: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  elevation: _large ? 12 : (_medium ? 10 : 8),
                                  child: TextFormField(
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'This field cannot be empty!';
                                      } else if (val.trim().length<10) {
                                        return 'Enter a valid phone number!';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => phoneNumber = val,
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    cursorColor: Color(0xff0aa9d7),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.phone,
                                          color: Color(0xff0aa9d7), size: 20),
                                      hintText: "Phone Number",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: BorderSide.none),
                                    ),
                                    onChanged: (val) {
                                      // setState(() {
                                      //   phoneNumber = val;
                                      // });
                                    },
                                  ),
                                ),
                                SizedBox(height: _height / 30.0),
                                Material(
                                  borderRadius: BorderRadius.circular(10.0),
                                  elevation: _large ? 12 : (_medium ? 10 : 8),
                                  child: TextFormField(
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'This field cannot be empty!';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => city = val,
                                    controller: cityController,
                                    keyboardType: TextInputType.phone,
                                    cursorColor: Color(0xff0aa9d7),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.location_city,
                                          color: Color(0xff0aa9d7), size: 20),
                                      hintText: "City",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: BorderSide.none),
                                    ),
                                    readOnly: true,
                                    onTap: ()async{
                                      await getUserLocation();
                                    },
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: GestureDetector(
                                    onTap: () async {
                                      print('hi');
                                      if(_formKey.currentState.validate()){
                                        _formKey.currentState.save();
                                        await addData();
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFea9b72),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(5.0)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Center(
                                          child: Text(
                                            'CONFIRM',
                                            style: TextStyle(
                                              color: Color(0xFFF0F0F0),
                                              fontSize: 14,
                                              fontFamily: 'MontserratSemi',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
              );
            },
            );

  }
}
