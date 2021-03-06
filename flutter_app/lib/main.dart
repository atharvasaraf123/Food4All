import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Dashboard.dart';
import 'package:flutter_app/OnBoarding/Intro_page.dart';
import 'package:flutter_app/size_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'googlesignindialog.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:

  final storage=FlutterSecureStorage();
  Future initialise(BuildContext context) async {

    await Firebase.initializeApp();
    CollectionReference userCol =
        FirebaseFirestore.instance.collection('users');
    if (FirebaseAuth.instance.currentUser != null) {
      DocumentSnapshot ds =
          await userCol.doc(FirebaseAuth.instance.currentUser.uid).get();
      if (!ds.exists) {
        return IntroPage();
      }
      Map<String, dynamic> mapp = ds.data();
      if (mapp.containsKey('city')) {
        print('dash');
        return MyHomePage();
      } else {
        return googlesignindialog();
      }
    } else {
      return IntroPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Donation',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),

      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            // Initialize FlutterFire:
            future: initialise(context),
            builder: (context, snapshot) {
              // Check for errors
              SizeConfig().init(context);

              print('abc${snapshot.data}');
              if (snapshot.hasError) {
                return Text("SomethingWentWrong",
                    textDirection: TextDirection.ltr);
              }

              // Once complete, show your application
              if (snapshot.connectionState == ConnectionState.done) {
                // print(snapshot.data);
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>snapshot.data), (route) => false);
                return snapshot.data;
              }

              // Otherwise, show something whilst waiting for initialization to complete
              return Text("Loading", textDirection: TextDirection.ltr);
            },
          ),
        ),
      ),
    );
  }
}
