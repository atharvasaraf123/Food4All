import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/signup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as path;
import '../Dashboard.dart';
import 'Donate_Food.dart';

class Add_Hunger_Spot extends StatefulWidget {
  @override
  _Add_Hunger_SpotState createState() => _Add_Hunger_SpotState();
}

class _Add_Hunger_SpotState extends State<Add_Hunger_Spot> {
  String address;
  String name;
  String add;
  String phone;
  String city;
  TextEditingController _addressController = TextEditingController();

  var gradesRange = RangeValues(0, 500);
  double capacitymin = 0;
  double capacitymax = 500;
  final _formKey = GlobalKey<FormState>();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  List<File> image = [];
  bool pressed = false;
  final imagePicker = ImagePicker();
  CollectionReference userCol = FirebaseFirestore.instance.collection('users');
  CollectionReference hungerspot = FirebaseFirestore.instance.collection('hungerspot');
  List url;

  List<String> chipList = ["Platform", "Orphanage", "SlumArea"];
  String selectedChoice = "";


  _buildChoiceList() {
    List<Widget> choices = List();
    chipList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(4.0),
        child: ChoiceChip(
          label: Text(item),
          labelStyle: selectedChoice == item
              ? TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold)
              : TextStyle(
              color: Colors.black,
              fontSize: 14.0,
              fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: Colors.grey.shade400)),
          elevation: 5.0,
          backgroundColor: Color(0x88ededed),
          selectedColor: Colors.orange.shade600,
          selected: selectedChoice == item,
          onSelected: (selected) {
            setState(() {
              selectedChoice = item;
            });
          },
        ),
      ));
    });
    return choices;
  }

  addHungerSpot(BuildContext context)async{
    User user=FirebaseAuth.instance.currentUser;
    CollectionReference donation=userCol.doc(user.uid).collection('hungerspot');
    url=List();
    for(int i=0;i<image.length;i++){
      // await storage.ref(basename(image[i].path)).putFile(image[i]).then((val)async{
      //   String s=await storage.ref(basename(image[i].path)).getDownloadURL();
      //   print(s);
      //   url.add(s);
      // });
      await storage.ref().child(path.basename(image[i].path)).putFile(image[i]).then((val)async{
        String s=await storage.ref(path.basename(image[i].path)).getDownloadURL();
        print(s);
        url.add(s);
      });
    }
    Map<String,dynamic>mapp={
      'address':add,
      'hungerSpotType':selectedChoice,
     'minP':capacitymin.ceil(),
      'maxP':capacitymax.ceil(),
      'url':url,
      'lat':lat,
      'long':long
    };
    await donation.add(mapp).then((value)async{
      await hungerspot.add(mapp).then((value) {
        Fluttertoast.showToast(msg: 'Hunger Spot added');
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Dashboard()));
      }).catchError((onError){
        Fluttertoast.showToast(msg: 'Something went wrong');
      });
    }).catchError((onError){
      Fluttertoast.showToast(msg: 'Something went wrong');
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AppBackground(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  _backButton(),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        color: Colors.white.withOpacity(0.8),
                        elevation: 5.0,
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  height: 50.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'ADD HUNGER SPOT',
                                    style: TextStyle(
                                        fontFamily: 'MontserratBold',
                                        color: Colors.white,
                                        fontSize: 25),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),



                                Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 25.0, left: 15.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Huger Spot Location',
                                            style: TextStyle(
                                                fontFamily: 'MontserratBold',
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
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
                                              contentPadding: EdgeInsets.all(0.0),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Colors.grey.shade500,
                                                width: 1.0,
                                              )),
                                              prefixIcon: IconButton(
                                                onPressed: () async {
                                                  await getUserLocation();
                                                },
                                                icon: Icon(
                                                  Icons.my_location_outlined,
                                                ),
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: () async {
                                                  //  await getUserLocation();
                                                },
                                                icon: Icon(Icons.edit),
                                              )),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'MontserratMed',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      horizontalLine(50),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),



                                Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, left: 15.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Huger Spot Type',
                                            style: TextStyle(
                                                fontFamily: 'MontserratBold',
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Wrap(
                                              spacing: 5.0,
                                              runSpacing: 5.0,
                                              children: _buildChoiceList(),
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      horizontalLine(50),
                                    ],
                                  ),
                                ),



                                Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 25.0, left: 15.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Population',
                                            style: TextStyle(
                                                fontFamily: 'MontserratBold',
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
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
                                      SizedBox(
                                        height: 10,
                                      ),
                                      horizontalLine(50),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, left: 15.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Add Images',
                                            style: TextStyle(
                                                fontFamily: 'MontserratBold',
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          height: 100,
                                          padding: EdgeInsets.symmetric(horizontal: 10.0),
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

                                      SizedBox(
                                        height: 10,
                                      ),
                                      horizontalLine(50),
                                    ],
                                  ),
                                ),






                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0, vertical: 35.0),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: ()async{
                                        if(_formKey.currentState.validate()){
                                          _formKey.currentState.save();
                                          await addHungerSpot(context);
                                        }

                                      },
                                      child: Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            gradient: LinearGradient(colors: [
                                              Color(0xFFff9e33),
                                              Color(0xFFff9b72),
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
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget horizontalLine(double padding) => Container(
        width: MediaQuery.of(context).size.width - padding,
        height: 1.0,
        color: Colors.black26.withOpacity(.2),
      );

  _backButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
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
    );
  }

  Future getImage() async {
    final imageTemp = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      image.add(File(imageTemp.path));
    });
  }

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

  getUserLocation() async {
    //call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
      lat=myLocation.latitude;
      long=myLocation.longitude;
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


}

