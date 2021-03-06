import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/konstants/ProfileListItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../AddNgo.dart';
import '../login.dart';
import 'EditProfile.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  CollectionReference userCol = FirebaseFirestore.instance.collection('users');
  String name="";
  String email="";
  String profileUrl="";
  bool load=true;
  double per=0;
  final storage=FlutterSecureStorage();


  logout()async{
    await FirebaseAuth.instance.signOut();
    await storage.deleteAll();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>Login()), (route) => false);
  }

  getUserData()async{
    String uid=FirebaseAuth.instance.currentUser.uid;

    DocumentSnapshot ds=await userCol.doc(uid).get();
    if(ds.exists){
      Map<String,dynamic>mapp=ds.data();
      name=mapp['name'].toString().capitalize();
      email=mapp['email'];
      profileUrl=mapp['profileUrl'];
      print(profileUrl);
      print(name);
      if(profileUrl==null){
        setState(() {
          per=0.8;
        });
      }else{
        setState(() {
          per=1;
        });
      }
      setState(() {
        load=false;
      });
    }else{
      print("Data Doesn't exists");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return load?Center(child: CircularProgressIndicator()):ScreenUtilInit(
      designSize: Size(360, 690),
      allowFontScaling: false,
      builder: () => Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              AppBackground(),
              SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.0),
                              height: 230,
                              width: 180,
                              child: Card(
                                color:Color(0xffF0FFFF),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Card(
                                    elevation: 10.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                    side: BorderSide(
                                      color:Colors.blue.shade100,
                                      width: 0.2
                                    )
                                    ),
                                    // child: profileUrl==null||profileUrl.isEmpty?Image.asset(
                                    //   'images/placeholder.jpg',
                                    //   fit: BoxFit.fitHeight,
                                    // ):Image.network(profileUrl),
                                    child: CachedNetworkImage(
                                      imageUrl: profileUrl,
                                      placeholder: (context, url) => Image.asset('images/placeholder.jpg',),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 35.0),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        // Text('Profile', style: TextStyle(
                                        //     fontFamily: 'MontserratBold',
                                        //     color: Colors.grey.shade700,
                                        //     fontSize: 16),),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 3.0,left: 3.0),
                                          child: Text(
                                            name,
                                            style: TextStyle(
                                                fontFamily: 'MontserratBold',
                                                color: Colors.grey.shade700,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0,left: 3.0),
                                          child: Text(
                                            email,
                                            style: TextStyle(
                                                fontFamily: 'MontserratMed',
                                                color: Colors.grey.shade700,
                                                fontSize: 13),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(top:10.0),
                                          child: LinearPercentIndicator(
                                            width:
                                                MediaQuery.of(context).size.width/2.5,
                                            animation: true,
                                            lineHeight: 14.0,
                                            animationDuration: 1500,
                                            percent: per,
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            linearGradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: [
                                                Color(0xe1ec9f05),
                                                Color(0xdaff4e00)
                                              ],
                                            ),
                                            // progressColor: Colors.green,
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0,horizontal: 3.0),
                                          child: Text(
                                            '${per*100} % Profile Completed',
                                            style: TextStyle(
                                                fontFamily: 'MontserratReg',
                                                color: Colors.grey.shade700,
                                                fontSize: 13),
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0,horizontal: 3.0),
                                          child: OutlineButton(
                                            borderSide: BorderSide(
                                                color: Colors.orangeAccent,
                                                width: 1,
                                                style: BorderStyle.solid),
                                            child: Text(
                                              "Edit Profile",
                                              style: TextStyle(fontSize: 15.0),
                                            ),
                                            highlightedBorderColor: Colors.red,
                                            splashColor: Colors.deepOrange,
                                            highlightColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            onPressed: () {

                                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>EditProfile()));

                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)),

                          color: Colors.white
                        ),

                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Card(
                                color: Colors.transparent,
                                elevation: 10.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)),

                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xffEC9F05),
                                        Color(0xffFF4E00)
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Ongoing\nDonations',
                                          style: TextStyle(
                                              fontFamily: 'MontserratBold',
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.call_made,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              height: 100,
                            ),
                            Container(
                              child: Card(
                                color: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0)),
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xffEC9F05),
                                        Color(0xffFF4E00)
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Completed\nDonations',
                                          style: TextStyle(
                                              fontFamily: 'MontserratBold',
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.done,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                elevation: 10.0,
                              ),
                              height: 100,
                            ),
                          ],
                        ),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(10.0)),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,

                            colors: [
                              Color(0xffffffff).withOpacity(1),
                              Colors.grey.shade200,
                            ],
                          ),
                        ),

                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 300,
                        child: ListView(
                          children: <Widget>[
                            ProfileListItem(
                              icon: Icons.help,
                              text: 'Research',
                            ),
                            ProfileListItem(
                              icon: Icons.help_outline,
                              text: 'Help & Support',
                            ),
                            ProfileListItem(
                              icon: LineAwesomeIcons.user_plus,
                              text: 'Invite a Friend',
                            ),
                            GestureDetector(
                              onTap: ()async{
                                await logout();
                              },
                              child: ProfileListItem(
                                icon:Icons.logout,
                                text: 'Logout',
                                hasNavigation: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
