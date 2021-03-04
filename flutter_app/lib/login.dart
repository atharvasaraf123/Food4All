import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/signup.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Dashboard.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _mail,_password;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  bool ieeeMenber = false;
  double _height;
  double _width;
  double _pixelRatio;
  bool pict = false;
  bool _large;
  bool _medium;
  String pictRegID;





  signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      String uid=userCredential.user.uid;
      // users
      //     .add({
      //   'email': mail, // John Doe
      //   'name': name, //// 42
      // })
      //     .then((value) => print("User Added"))
      //     .catchError((error) => print("Failed to add user: $error"));
      User user1=userCredential.user;
      Map<String, dynamic>user;
      if(user1.phoneNumber!=null&&user1.phoneNumber.isNotEmpty) {
       user = {
          'email': user1.email,
          'name': user1.displayName,
          'phone': user1.phoneNumber
        };
      }else{
        user = {
          'email': user1.email,
          'name': user1.displayName,
        };
      }
      users.doc(uid).set(user).then((value) {
        Fluttertoast.showToast(msg: 'Signed Up Successfully');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Dashboard()), (route) => false);
      }).catchError((onError){
        Fluttertoast.showToast(msg: onError.toString());
      });
    }catch(e){
      print(e.toString());
    }
  }

  login()async{
    try {
      print(_mail);
      print(_password);
      UserCredential authResult=await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "$_mail",
          password: "$_password"
      );
      Fluttertoast.showToast(msg: 'Logged in');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Dashboard()), (route) => false);
    } catch (e) {
      if (e.toString().toLowerCase().contains('user_not_found')) {
        Fluttertoast.showToast(msg:'No user found for that email.');
      } else if (e.toString().toLowerCase().contains('wrong-password')) {
        Fluttertoast.showToast(msg:'Wrong password provided for that user.');
      }else{
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }
  // signInWithFacebook()async{
  //   try {
  //     // by default the login method has the next permissions ['email','public_profile']
  //     AccessToken accessToken = await FacebookAuth.instance.login();
  //     print(accessToken.toJson());
  //     // get the user data
  //     final userData = await FacebookAuth.instance.getUserData();
  //     print(userData);
  //   } on FacebookAuthException catch (e) {
  //     switch (e.errorCode) {
  //       case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
  //         print("You have a previous login operation in progress");
  //         break;
  //       case FacebookAuthErrorCode.CANCELLED:
  //         print("login cancelled");
  //         break;
  //       case FacebookAuthErrorCode.FAILED:
  //         print("login failed");
  //         break;
  //     }
  //   }
  // }
  Widget horizontalLine() => Container(
    width:MediaQuery.of(context).size.width/4,
    height: 1.0,
    color: Colors.black26.withOpacity(.2),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLogIn();
  }

  getLogIn()async{

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

    return  Scaffold(
      body: SafeArea(
        child: CustomPaint(
          painter: BackgroundSignIn(),
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(
                    //   height: 155.0,
                    //   child: Image.asset(
                    //     "assets/logo.png",
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                    SizedBox(height: 145.0),
                    Material(
                      borderRadius: BorderRadius.circular(25.0),
                      elevation: _large ? 12 : (_medium ? 10 : 8),
                      child: TextFormField(
                        onSaved:(val){
                          setState(() {
                            _mail=val;
                          });
                        },
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Color(0xff0aa9d7),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email,
                              color: Color(0xff0aa9d7), size: 20),
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
                // TextFormField(
                //   obscureText: false,
                //   decoration: InputDecoration(
                //       contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                //       hintText: "Email",
                //       border:
                //       OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                //   validator: (val) {
                //     if (val.isEmpty) {
                //       return 'This field cannot be empty!';
                //     } else if (!validateEmail(val)) {
                //       return 'Enter a valid email!';
                //     }
                //     return null;
                //   },
                //   onSaved: (val) => _mail = val,
                // ),
                    SizedBox(height: 25.0),

                    Material(
                      borderRadius: BorderRadius.circular(25.0),
                      elevation: _large ? 12 : (_medium ? 10 : 8),
                      child: TextFormField(
                        onSaved:(val){
                          setState(() {
                            _password=val;
                          });
                        },
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        cursorColor: Color(0xff0aa9d7),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock,
                                color: Color(0xff0aa9d7), size: 20),
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              color: Color(0xff0aa9d7),
                            )),
                        onChanged: (val) {
                          // setState(() {
                          //   password = val;
                          // });
                        },
                        obscureText: _obscureText,
                      ),
                    ),
                    SizedBox(height: _height / 30.0),


                    // Row(
                //   children: [
                //     Expanded(
                //       child: TextFormField(
                //       obscureText: _obscureText,
                //         decoration: InputDecoration(
                //             contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                //             hintText: "Password",
                //             border:
                //             OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                //
                //         validator: (val) => val.length < 6
                //             ? 'Password must be at least 6 characters long!'
                //             : null,
                //         onChanged: (val) => _password = val,
                //
                //       ),
                //     ),
                //     IconButton(
                //       icon: Icon(
                //         _obscureText
                //             ? Icons.visibility_off
                //             : Icons.visibility,
                //         color:
                //         Colors.black,
                //       ),
                //       onPressed: () {
                //         setState(() {
                //           _obscureText = !_obscureText;
                //         });
                //       },
                //     ),
                //   ],
                // ),
                    SizedBox(
                      height: 35.0,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.orangeAccent.shade400,
                      child: MaterialButton(

                        minWidth: MediaQuery.of(context).size.width*0.6,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: ()async{
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            await login();
                          }
                        },
                        child: Text("Login",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    _getBottomRow(context),

                    SizedBox(
                      height: 30.0,
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        horizontalLine(),
                        Text(" Social Login ",
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: "Poppins-Medium")),
                        horizontalLine()
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SignInButtonBuilder(
                            text: 'Google',
                            mini: true,
                            shape: CircleBorder(),
                            icon: FontAwesomeIcons.google,
                            backgroundColor: Colors.red.shade900,
                            onPressed: () async {
                              await signInWithGoogle();
                              // try {
                              //   FirebaseUser user =
                              //   await auth.handleGoogleSignIn(context);
                              //   validateUser(context, user);
                              // }catch(e){
                              //   print('GoogleError');
                              //   print(e.toString());
                              // }
                            },
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          SignInButtonBuilder(
                            text: 'FaceBook',
                            mini: true,
                            shape: CircleBorder(),
                            icon: FontAwesomeIcons.facebook,
                            onPressed: () async {
                              await signInWithGoogle();
                              // try {
                              //   FirebaseUser user =
                              //   await auth.handleGoogleSignIn(context);
                              //   validateUser(context, user);
                              // }catch(e){
                              //   print('GoogleError');
                              //   print(e.toString());
                              // }
                            },
                            backgroundColor: Colors.blue,
                          ),
                          SizedBox(
                            width: 5,
                          ),

//                           Text(
//                             'Login with Google',
// //                                style: GoogleFonts.openSans(),
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold),
//                           ),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
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


  _getBottomRow(context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>SignUp()));
          },
          child: Text(
            'Dont have account Sign up here' ,
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


}
