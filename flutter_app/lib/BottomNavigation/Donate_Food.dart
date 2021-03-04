import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Dashboard.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class Donate_Food extends StatefulWidget {
  @override
  _Donate_FoodState createState() => _Donate_FoodState();
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}

class _Donate_FoodState extends State<Donate_Food> {
  DateTime selectedDateTime;
  TextEditingController dateController = TextEditingController();

  TextEditingController _addressController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference userCol = FirebaseFirestore.instance.collection('users');
  CollectionReference dona = FirebaseFirestore.instance.collection('donation');

  List<File> image = [];
  bool pressed = false;
  final imagePicker = ImagePicker();

  var gradesRange = RangeValues(0, 500);
  double capacitymin = 0;
  double capacitymax = 500;

  String address;
  String name;
  String add;
  String foodItems;
  String phone;
  String city;
  final _formKey = GlobalKey<FormState>();
  List url;

  Future getImage() async {
    final imageTemp = await imagePicker.getImage(source: ImageSource.camera,imageQuality:60);
    setState(() {
      image.add(File(imageTemp.path));
    });
  }

  donateFood(BuildContext context)async{
    User user=FirebaseAuth.instance.currentUser;
    CollectionReference donation=userCol.doc(user.uid).collection('donations');
    url=List();
    for(int i=0;i<image.length;i++){
      // await storage.ref(basename(image[i].path)).putFile(image[i]).then((val)async{
      //   String s=await storage.ref(basename(image[i].path)).getDownloadURL();
      //   print(s);
      //   url.add(s);
      // });
      await storage.ref().child(basename(image[i].path)).putFile(image[i]).then((val)async{
        String s=await storage.ref(basename(image[i].path)).getDownloadURL();
        print(s);
        url.add(s);
      });
    }
    DocumentSnapshot ds=await userCol.doc(user.uid).get();
    String name=ds.data()['name'];
    Map<String,dynamic>mapp={
      'name':name,
      'uid':user.uid,
      'address':add,
      'foodItems':foodItems,
      'dateTime':dateController.text.toString().trim(),
      'minQ':capacitymin.ceil(),
      'maxQ':capacitymax.ceil(),
      'url':url
    };
    await donation.add(mapp).then((value)async{
      await dona.add(mapp).then((value) {
        Fluttertoast.showToast(msg: 'Donations added');
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Dashboard()));
      }).catchError((onError){
        Fluttertoast.showToast(msg: 'Something went wrong');
      });
    }).catchError((onError){
      Fluttertoast.showToast(msg: 'Something went wrong');
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
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: [
            AppBackground(),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Donate Food Details',
                            style: TextStyle(
                              fontFamily: 'MontserratBold',
                              color: Colors.orange,
                              fontSize: 25
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'This field cannot be empty!';
                            }
                            return null;
                          },
                          controller: _addressController,
                          onSaved: (val) {
                            setState(() {
                              add = val;
                            });
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () async {
                                await getUserLocation();
                              },
                              icon: Icon(
                                Icons.location_searching_outlined,
                              ),
                            ),
                            labelText: 'Preferred Address',
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          onSaved: (val) {
                            setState(() {
                              foodItems = val;
                            });
                          },
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'This field cannot be empty!';
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontFamily: 'MontserratMed',
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Food Item(s)',
                              labelStyle: TextStyle(
                                fontFamily: 'MontserratMed',
                                color: Colors.grey.shade500,
                              ),
                              suffixIcon: Icon(Icons.fastfood)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'This field cannot be empty!';
                            }
                            return null;
                          },
                          controller: dateController,
                          onTap: () => setState(() {
                            pressed = true;

                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true, onChanged: (date) {
                              // print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              selectedDateTime = date;
                              dateController.text = DateFormat.yMMMEd().add_jm().format(date);
                            }, currentTime: DateTime(2020, 01, 01, 12, 00, 00));
                          }),
                          style: TextStyle(
                            fontFamily: 'MontserratMed',
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Preferred Time',
                              labelStyle: TextStyle(
                                fontFamily: 'MontserratMed',
                                color: Colors.grey.shade500,
                              ),
                              suffixIcon: Icon(Icons.calendar_today)),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              'Quantity: 500 people',
                              style: TextStyle(
                                fontFamily: 'MontserratMed',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            capacitymin.ceil().toString(),
                            style: TextStyle(
                              fontFamily: 'MontserratBold',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            ' - ',
                            style: TextStyle(
                              fontFamily: 'MontserratMed',
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            capacitymax.ceil().toString(),
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
                      RangeSlider(
                        min: 0,
                        max: 500,
                        divisions: 50,
                        values: gradesRange,
                        onChanged: (RangeValues value) {
                          setState(() {
                            gradesRange = value;
                            capacitymin = gradesRange.start;
                            capacitymax = gradesRange.end;
                          });
                        },
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Photos',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 100,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              _showImages(),
                              _addNewImage(),
                            ],
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 35.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: ()async{
                              if(_formKey.currentState.validate()){
                                _formKey.currentState.save();
                                await donateFood(context);
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
                                  'Submit',
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBackBtn() {
    return Positioned(
      top: 35,
      left: 25,
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
    );
  }

  _getTextFields() {}

  _showImages() {
    // if(image.length!=0)
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: image.length,
        itemBuilder: (BuildContext context, int position) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Container(
              // width: 100,
              // height: 100,
              child: image[position] == null
                  ? Text('null')
                  : Image.file(image[position],fit: BoxFit.contain,),
            ),
          );
        },
      ),
    );
  }

  _addNewImage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        dashPattern: [6, 2],
        strokeWidth: 2,
        color: Colors.orange.shade600,
        child: Container(
          height: 100,
          width: 60,
          child: IconButton(
            onPressed: getImage,
            icon: Icon(Icons.add),
            // onPressed: ,
          ),
        ),
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
