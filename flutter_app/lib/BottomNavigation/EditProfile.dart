import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:location/location.dart';
import 'package:path/path.dart' as path;

class EditProfile extends StatefulWidget {
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {





  CollectionReference userCol = FirebaseFirestore.instance.collection('users');
  String name="";
  String email="";
  String phone="";
  String profileUrl="";
  bool load=true;
  String city="";
  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController cityController=TextEditingController();
  final imagePicker = ImagePicker();
  File _file;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;


  getUserLocation() async {
    //call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      print('1');
      myLocation = await location.getLocation();
      print('1');
      final coordinates =
      new Coordinates(myLocation.latitude, myLocation.longitude);
      var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(
          ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
      setState(() {
        cityController.text=addresses.first.locality;
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

  updateProfile()async{
    String uid=FirebaseAuth.instance.currentUser.uid;
    print(name);
    print(nameController.text.toString());
    print(phone);
    print(phoneController.text.toString());
    String s;
    Map<String,dynamic>mapp=Map();
    if(name!=nameController.text.toString()){
      mapp['name']=nameController.text.toString();
    }
    if(phone!=phoneController.text.toString()){
      mapp['phone']=phoneController.text.toString();
    }
    if(city!=cityController.text.toString()){
      mapp['phone']=cityController.text.toString();
    }
    if(_file!=null){
      await storage.ref().child(path.basename(_file.path)).putFile(_file).then((val)async{
        s=await storage.ref(path.basename(_file.path)).getDownloadURL();
        print(s);
      });
      mapp['profileUrl']=s;

    }
    await userCol.doc(FirebaseAuth.instance.currentUser.uid).update(mapp).then((value){
      Fluttertoast.showToast(msg: 'Profile Updated');
      Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>Dashboard()));
    });
  }

  Widget _profileText() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        'Profile',
        style: TextStyle(
          fontSize: 35.0,
          letterSpacing: 1.5,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future getImage() async {
    final imageTemp = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _file=File(imageTemp.path);
    });
  }

  Widget _circleAvatar() {
    return GestureDetector(
      onTap: ()async{
        await getImage();
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.width / 2,
        padding: EdgeInsets.all(10.0),

        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5),

          shape: BoxShape.circle,
          color: Colors.white,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: _file!=null?FileImage(_file):profileUrl==null||profileUrl.isEmpty?AssetImage('images/placeholder.jpg'):NetworkImage(profileUrl),
          ), // Decoration image
        ), // Box decoration
      ),
    ); // Container
  }

  Widget _textFormField({
    String hintText,
    IconData icon,
    TextEditingController controller,
    bool edit=false,
  }) {
    return Material(
      elevation: 4,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: TextField(
        readOnly: edit,
        controller: controller,
        onTap: hintText=='City'?()async{
          await getUserLocation();
    }:null,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              letterSpacing: 2,
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
            filled: true,
            fillColor: Colors.white30),
      ),
    );
  }

  Widget _textFormFieldCalling() {
    return Container(
      // height: 420,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical:12.0,horizontal: 10.0),
            child: _textFormField(hintText: 'Name', icon: Icons.person,controller: nameController),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:12.0,horizontal: 10.0),
            child: _textFormField(hintText: 'Email', icon: Icons.email,controller: emailController,edit: true),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:12.0,horizontal: 10.0),
            child: _textFormField(
              hintText: 'Contact Number',
              icon: Icons.phone,
              controller: phoneController
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical:12.0,horizontal: 10.0),
            child: _textFormField(
                hintText: 'City',
                icon: Icons.location_city,
                controller: cityController,
              edit: true
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap:_file!=null||name!=nameController.text.toString()||phone!=phoneController.text.toString()? ()async{
                await updateProfile();
              }:null,
              child: Container(
                width: MediaQuery.of(context).size.width/1.9,
                decoration: BoxDecoration(
                  color: Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                    gradient: _file!=null||name!=nameController.text.toString()||phone!=phoneController.text.toString()? LinearGradient(colors: [
                      Color(0xffff6600),
                      Color(0xffff8400),
                    ]):null),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20),
                  child: Center(
                      child: Text(
                        'Update',
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
        ],
      ),
    );
  }
  _backButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10,left: 10.0),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  getUserInfo()async{
    String uid=FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot ds=await userCol.doc(uid).get();
    if(ds.exists){
      Map<String,dynamic>mapp=ds.data();
      name=mapp['name'].toString().capitalize();
      if(name==null)name="";
     nameController.text=name;
      email=mapp['email'];
      emailController.text=email;
      phone=mapp['phone'];
      if(phone==null)phone="";
      phoneController.text=phone;
      city=mapp['city'];
      if(city==null)city="";
      cityController.text=city;
      profileUrl=mapp['profileUrl'];
      print(name);
      setState(() {
        load=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Stack(
            // alignment: Alignment.center,
            children: [
              CustomPaint(
                child: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
                painter: HeaderCurvedContainer(),
              ),
              _backButton(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _profileText(),
                  _circleAvatar(),
                  _textFormFieldCalling()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }




}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.orange;
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 250.0, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}