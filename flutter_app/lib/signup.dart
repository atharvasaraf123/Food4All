import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Dashboard.dart';
import 'package:flutter_app/konstants/loaders.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

import 'ResponsiveWidget.dart';
import 'konstants/functions.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}



TextEditingController nameController = TextEditingController();
TextEditingController usernameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController cityController = TextEditingController();
TextEditingController collegeController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController password1Controller = TextEditingController();
TextEditingController ieee = TextEditingController();
TextEditingController registrationController = TextEditingController();

double _height;
double _width;
double _pixelRatio;
bool pict = false;
bool _large;
bool _medium;
bool _obscureText = true;
double lat;
double long;
String pictRegID;
String city;



class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String mail, password, password1, name,phoneNumber;
  bool load=false;
  bool _obscureText = true;
  bool _obscureText1 = true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  getUserLocation() async {
    //call this async method from whereever you need

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
      print(permission);
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
      print('1');
      Position position= await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      print('1');
      final coordinates =
      new Coordinates(position.latitude, position.longitude);
      print(position.latitude);
      var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      print(position.latitude);
      print(addresses);
      var first = addresses.first;
      print(
          ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
      setState(() {
        city = addresses.first.locality;
        cityController.text=city;
      });
    } on PlatformException catch (e) {
      print(e.details);
      print(e.message);
      print(e.code);
      if (e.code == 'PERMISSION_DENIED') {
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
      }
    }catch(e){
      print(e.toString());
    }

  }

  createUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: mail, password: password);
      String uid=userCredential.user.uid;
      // users
      //     .add({
      //   'email': mail, // John Doe
      //   'name': name, //// 42
      // })
      //     .then((value) => print("User Added"))
      //     .catchError((error) => print("Failed to add user: $error"));
      Map<String,dynamic>user={
        'email':mail,
        'name':name,
        'phone':phoneNumber,
        'city':city,
        'lat':lat,
        'long':long
      };
      print(user);
      users.doc(uid).set(user).then((value) {
        setState(() {
          load=false;
        });
      Fluttertoast.showToast(msg: 'Signed Up Successfully');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Dashboard()), (route) => false);
      }).catchError((onError){
        setState(() {
          load=false;
        });
       Fluttertoast.showToast(msg: onError.toString());
    });

    } catch (e) {
      setState(() {
        load=false;
      });
      if (e.toString().toLowerCase().contains('weak_password')) {
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.toString().toLowerCase().contains('email_already_in_use')) {
        setState(() {
          load=false;
        });
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
      } else {
        setState(() {
          load=false;
        });
        Fluttertoast.showToast(msg: 'Try again in sometime');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;
    _pixelRatio = MediaQuery
        .of(context)
        .devicePixelRatio;
    _large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: load==true?spinkit:SafeArea(
        child: Stack(
          children: [
            CustomPaint(
              painter: BackgroundSignUp(),
              child: Stack(
                children: <Widget>[
                  _getBackImage(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(

                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,

                                children: <Widget>[
                                  _getHeader(),
                                  _getTextFields(),
                                  _getSignIn(),
                                  _getBottomRow(context),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _getBackBtn(),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  _getBackImage() {
   return ClipPath(
      clipper: _CustomClipper(),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              image: AssetImage("images/signup.jpeg"),
            )
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

  _getBottomRow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Already a user Sign in here',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Text(
          '',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }

  _getSignIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Sign up',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w500),
        ),
        InkWell(
          onTap: ()async{
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              setState(() {
                load=true;
              });
              await createUser();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical:20.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              radius: 40,
              child: Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  _getTextFields() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: _large ? 12 : (_medium ? 10 : 8),
          child: TextFormField(
            controller: nameController,
            validator: (val) {
              if (val.isEmpty) {
                return 'This field cannot be empty!';
              }
              return null;
            },
            onSaved: (val) => name = val,
            keyboardType: TextInputType.text,
            cursorColor:Colors.orange.shade300,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person,
                  color: Colors.orange.shade300, size: 20),
              hintText: "Name",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none),
            ),
            onChanged: (val) {
              // setState(()=> {
              //   name = val;
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
              } else if (!validateEmail(val)) {
                return 'Enter a valid email!';
              }
              return null;
            },
            onSaved: (val) => mail = val,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.orange.shade300,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email,
                  color: Colors.orange.shade300, size: 20),
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none),
            ),
            onChanged: (val) {
              // setState(() {
              //   email = val;
              // });
            },
          ),
        ),
        SizedBox(height: _height / 30.0),
        Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: _large ? 12 : (_medium ? 10 : 8),
          child: TextFormField(
            validator: (val) => val.length < 6
                ? 'Password must be at least 6 characters long!'
                : null,
            onSaved: (val) => password = val,
            controller: passwordController,
            keyboardType: TextInputType.text,
            cursorColor: Colors.orange.shade300,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                    color: Colors.orange.shade300, size: 20),
                hintText: "Password",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none),
                suffixIcon: IconButton(
                  icon: _obscureText?Icon(Icons.visibility):Icon(Icons.visibility_off),
                  color:Colors.orange.shade300,
                  onPressed: (){
                    setState(() {
                      _obscureText=!_obscureText;
                    });
                  },
                )),

            obscureText: _obscureText,
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
              } else if (val.trim().length<10) {
                return 'Enter a valid phone number!';
              }
              return null;
            },
            onSaved: (val) => phoneNumber = val,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            cursorColor:Colors.orange.shade300,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone,
                  color: Colors.orange.shade300, size: 20),
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
            cursorColor: Colors.orange.shade300,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_city,
                  color: Colors.orange.shade300, size: 20),
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
      ],
    );
  }

  _getHeader() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      alignment: Alignment.bottomLeft,
      child: Text(
        'Create\nAccount',
        style: TextStyle(color: Colors.white, fontSize: 40),
      ),
    );
  }


}


class BackgroundSignIn extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.grey.shade100;
    canvas.drawPath(mainBackground, paint);

    // Path blueWave = Path();
    // blueWave.lineTo(sw, 0);
    // blueWave.lineTo(sw, sh * 0.5);
    // blueWave.quadraticBezierTo(sw * 0.5, sh * 0.45, sw * 0.2, 0);
    // blueWave.close();
    // paint.color = Colors.lightBlue.shade300;
    // canvas.drawPath(blueWave, paint);

    // Path greyWave = Path();
    // greyWave.lineTo(sw, 0);
    // greyWave.lineTo(sw, sh * 0.1);
    // greyWave.cubicTo(
    //     sw * 0.95, sh * 0.15, sw * 0.65, sh * 0.15, sw * 0.6, sh * 0.38);
    // greyWave.cubicTo(sw * 0.52, sh * 0.52, sw * 0.05, sh * 0.45, 0, sh * 0.4);
    // greyWave.close();
    // paint.color = Colors.grey.shade800;
    // canvas.drawPath(greyWave, paint);

    Path yellowWave = Path();
    yellowWave.lineTo(sw * 0.7, 0);
    yellowWave.cubicTo(
        sw * 0.6, sh * 0.05, sw * 0.27, sh * 0.01, sw * 0.18, sh * 0.12);
    yellowWave.quadraticBezierTo(sw * 0.12, sh * 0.2, 0, sh * 0.2);
    yellowWave.close();
    paint.color = Colors.orange.shade300;
    canvas.drawPath(yellowWave, paint);

    Path yellowWaveBottom = Path();
    yellowWaveBottom.moveTo(sw * 0.3, sh);
    yellowWaveBottom.cubicTo(
        sw * 0.4, sh * 0.95, sw * 0.73, sh * 0.99, sw * 0.82, sh * 0.88);
    yellowWaveBottom.quadraticBezierTo(sw * 0.88, sh * 0.8, sw, sh * 0.8);
    yellowWaveBottom.lineTo(sw, sh);
    yellowWaveBottom.close();
    paint.color = Colors.orange.shade300;
    canvas.drawPath(yellowWaveBottom, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class BackgroundSignUp extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();


    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = Colors.white;
    canvas.drawPath(mainBackground, paint);

    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.65);
    blueWave.cubicTo(sw * 0.8, sh * 0.8, sw * 0.55, sh * 0.8, sw * 0.45, sh);
    blueWave.lineTo(0, sh);
    blueWave.close();
    paint.color = Colors.orange;
    canvas.drawPath(blueWave, paint);

    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.3);
    greyWave.cubicTo(sw * 0.65, sh * 0.45, sw * 0.25, sh * 0.35, 0, sh * 0.5);
    greyWave.close();
    paint.color = Colors.grey.shade800;
    canvas.drawPath(greyWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}



class _CustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double heightDelta = size.height / 2.2;
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();
    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.3);
    greyWave.cubicTo(sw * 0.65, sh * 0.45, sw * 0.25, sh * 0.35, 0, sh * 0.5);
    greyWave.close();
    paint.color = Colors.grey.shade800;
    // canvas.drawImage( Image(image: AssetImage("images/signup.jpeg")), offset, paint);
    // canvas.drawPath(greyWave, paint);
    return greyWave;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


