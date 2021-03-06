import 'package:android_intent/android_intent.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/BottomNavigation/Add_Hunger_Spot.dart';
import 'package:flutter_app/BottomNavigation/NGOs.dart';
import 'package:flutter_app/BottomNavigation/Settings.dart';
import 'package:flutter_app/size_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'BottomNavigation/Donate_Food.dart';
import 'login.dart';
import 'package:geolocator/geolocator.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: MyHomePage(),
      // debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State {


  String city="";
  final storage=FlutterSecureStorage();
  bool load=true;

  openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  getUserLocation() async {
    if (await storage.containsKey(key: 'city')){
      city=await storage.read(key: 'city');
      print('hello');
      setState(() {
        load=false;
      });
    } else {
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
          ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first
              .subAdminArea},${first.addressLine}, ${first.featureName},${first
              .thoroughfare}, ${first.subThoroughfare}');
      setState(() {
        city = addresses.first.locality;
      });
      await storage.write(key: 'city', value: city);
      setState(() {
        load=false;
      });
    }
  }

  int currentIndex=0;
  BuildContext context;

  @override
  void initState() {
    super.initState();

    getUserLocation();
  }

  logout()async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>Login()), (route) => false);
  }

  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }



  SpeedDial _speedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 24.0),
      curve: Curves.easeInBack,
      backgroundColor: Colors.orange.shade700,
      heroTag: 'add',
      children: [
        SpeedDialChild(
          backgroundColor: Colors.orange.shade400,
          child: Image.asset('images/fooddonationhand.png',fit: BoxFit.contain,height: 24,width: 24,),
          label: 'Donate Food',
          labelBackgroundColor: Colors.grey.shade400,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Donate_Food())),
        ),
        SpeedDialChild(
          backgroundColor: Colors.orange.shade400,
          child: Icon(Icons.add_a_photo),
          label: 'Add Hunger Spot',
          labelBackgroundColor: Colors.grey.shade400,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Add_Hunger_Spot())),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    List<Widget>list=[
      Container(),
      NGOs(city: city,),
      Settings()
    ];

    this.context=context;

    return load?CircularProgressIndicator():Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          actions: [
            Text(city)
          ],
          title: Text('Food Donation'),
          centerTitle: true,
        ),
        floatingActionButton: _speedDial(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          opacity: 0.2,
          backgroundColor: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
          currentIndex: currentIndex,
          hasInk: true,
          inkColor: Colors.black12,
          hasNotch: true,
          fabLocation: BubbleBottomBarFabLocation.end,
          onTap: changePage,
          items: [
            BubbleBottomBarItem(
              backgroundColor: Colors.orangeAccent,
              icon: Icon(
                Icons.dashboard,
                color: Colors.black87,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.orangeAccent,
              ),
              title: Text('Dashboard'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.orangeAccent,
              icon: Icon(
                Icons.account_balance_sharp,
                color: Colors.black87,
              ),
              activeIcon: Icon(
                Icons.account_balance_sharp,
                color: Colors.orangeAccent,
              ),
              title: Text('NGOs'),
            ),
            BubbleBottomBarItem(
              backgroundColor: Colors.orangeAccent,
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.black87,
              ),
              activeIcon: Icon(
                Icons.settings_outlined,
                color: Colors.orangeAccent,
              ),
              title: Text('Settings'),
            ),
          ],
        ),
        body: list[currentIndex]);
  }
}
