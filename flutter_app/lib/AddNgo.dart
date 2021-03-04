import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:location/location.dart';

class AddNGO extends StatefulWidget {
  @override
  _AddNGOState createState() => _AddNGOState();
}

class _AddNGOState extends State<AddNGO> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;
  Animation<double> _fadeAnimation;
  TextEditingController _addressController = TextEditingController();
  String address;
  String name;
  String add;
  String phone;
  String city;
  User _user;
  int capacity = 0;
  final _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ngoCol = FirebaseFirestore.instance.collection('NGO');

  addNgo() async {
    String uid = _user.uid;
    Map<String, dynamic> ngo = {
      'name': name,
      'address': add,
      'phone': phone,
      'capacity': capacity,
      'uid':uid,
      'city':city
    };
    print(ngo);
    ngoCol.doc(uid).set(ngo).then((value) {
      Fluttertoast.showToast(msg: 'NGO registered');
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Dashboard()));
    }).catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
  }

  getUserLocation() async {
    //call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    LocationData currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    setState(() {
      address = addresses.first.toString();
      _addressController.text = addresses.first.addressLine;
      city = addresses.first.locality;
    });
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(-0.05, 0))
        .animate(_controller);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  playAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: [
          AppBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFFea9b72),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                iconSize: 24,
                              ),
                            ),
                            color: Colors.white,
                            shape: CircleBorder(),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Please fill the following form',
                    style: TextStyle(
                        fontFamily: 'MontserratSemi',
                        color: Colors.black,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'This field cannot be empty!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'NGO Name',
                      labelStyle: TextStyle(
                        fontFamily: 'MontserratMed',
                        color: Colors.grey.shade500,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'MontserratMed',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'This field cannot be empty!';
                      }
                      return null;
                    },
                    controller: _addressController,
                    readOnly: true,
                    onSaved: (val) {
                      setState(() {
                        add = val;
                      });
                    },
                      onTap: ()async{
                        await getUserLocation();
                      },
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () async {
                          await getUserLocation();
                        },
                        icon: Icon(
                          Icons.location_searching_outlined,
                          color: Color(0xFFea9b72),
                        ),
                      ),
                      labelText: 'NGO Address',
                      labelStyle: TextStyle(
                        fontFamily: 'MontserratMed',
                        color: Colors.grey.shade500,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'MontserratMed',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'This field cannot be empty!';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        phone = val;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'NGO contact number',
                      labelStyle: TextStyle(
                        fontFamily: 'MontserratMed',
                        color: Colors.grey.shade500,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontFamily: 'MontserratMed',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'NGO Capacity',
                    style: TextStyle(
                        fontFamily: 'MontserratMed',
                        color: Colors.black,
                        fontSize: 15),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Text(
                        capacity.toString(),
                        style: TextStyle(
                          fontFamily: 'MontserratBold',
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        ' people',
                        style: TextStyle(
                          fontFamily: 'MontserratMed',
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      inactiveTrackColor: Colors.grey.shade400,
                      activeTrackColor: Color(0xFFea9b72),
                      thumbColor: Colors.orange.shade400,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 12.0,
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 30,
                      ),
                      overlayColor: Color(0x29EB1555),
                    ),
                    child: Slider(
                      divisions: 10,
                      value: capacity.toDouble(),
                      min: 0,
                      max: 500,
                      onChanged: (double newhieght) {
                        setState(() {
                          capacity = newhieght.round();
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            addNgo();
                          }
                        },
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(colors: [
                                Color(0xFFea9b72),
                                Color(0xFFff9e33)
                              ])),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Center(
                                child: Text(
                              'Register',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'MontserratSemi'),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AppBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        final height = constraint.maxHeight;
        final width = constraint.maxWidth;

        return Stack(
          children: <Widget>[
            Container(
              color: Color(0xFFE4E6F1),
            ),
            Positioned(
              left: -(height / 2 - width / 2),
              bottom: height * 0.25,
              child: Container(
                height: height,
                width: height,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.3)),
              ),
            ),
            Positioned(
              left: width * 0.15,
              top: -width * 0.5,
              child: Container(
                height: width * 1.6,
                width: width * 1.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            ),
            Positioned(
              right: -width * 0.2,
              top: -50,
              child: Container(
                height: width * 0.6,
                width: width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
