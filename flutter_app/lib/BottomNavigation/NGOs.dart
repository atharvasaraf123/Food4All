import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AddNgo.dart';
import 'package:flutter_app/BottomNavigation/NgoPerson.dart';

class NGOs extends StatefulWidget {
  @override
  _NGOsState createState() => _NGOsState();
}

class _NGOsState extends State<NGOs> {
  bool ngo = false;
  bool load = true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ngoCol = FirebaseFirestore.instance.collection('NGO');
  CollectionReference donCol =
      FirebaseFirestore.instance.collection('donation');
  List list;
  List donationList;
  Map<String,List>cities;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkNgo();
  }

  getDonationList() async {
    await donCol.get().then((value) {
      setState(() {
        donationList = value.docs;
        load = false;
      });
    });
  }

  checkNgo() async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await ngoCol.doc(user.uid).get();
    ngo = ds.exists;
    print(ngo);
    if (!ngo) {
      list = List();
      await ngoCol.get().then((value) {
        list = value.docs;
        cities=Map();
        for(int i=0;i<list.length;i++){
          if(list[i]==null)continue;
          if(cities.containsKey(list[i]['city'])){
            cities[list[i]['city']].add(list[i]);
          }else{
            cities[list[i]['city']]=List();
            cities[list[i]['city']].add(list[i]);
          }
        }
        // value.docs.forEach((element) {
        //   list.add(element);
        // });
        setState(() {
          load=false;
        });
      });
    } else {
      await getDonationList();
    }
    print(list);
  }

  final planetThumbnail = new Container(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    alignment: FractionalOffset.centerLeft,
    child: CircleAvatar(
      backgroundImage: AssetImage("images/ngoCharity2.png"),
      radius: 45,
    ),
  );



  @override
  Widget build(BuildContext context) {
    return load == true
        ? Center(child: CircularProgressIndicator())
        : ngo
            ? NgoPerson(donationList: donationList,)
            : ListView(
                children: [
                  ListView.builder(
                    itemBuilder: (BuildContext context, int pos) {
                      return Container(
                          margin: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 16.0,
                            left: 24.0,
                            right: 24.0,
                          ),
                          child: new Stack(
                            children: <Widget>[
                              Container(
                                height: 130.0,
                                margin: new EdgeInsets.only(left: 46.0),
                                decoration: new BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFF512F).withOpacity(0.5),
                                        Color(0xffFFE000).withOpacity(0.5),
                                      ]),
                                  // color: new Color(0xFF333366),
                                  shape: BoxShape.rectangle,
                                  borderRadius: new BorderRadius.circular(8.0),
                                  boxShadow: <BoxShadow>[
                                    new BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10.0,
                                      offset: new Offset(0.0, 10.0),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  margin:
                                      EdgeInsets.only(left: 50.0, right: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        list[pos]['name'].toString(),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontFamily: 'MontserratBold'),
                                      ),
                                      Text(
                                        "Address:- ${list[pos]['address'].toString()}",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Color(0xfff0f8ff),
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.people,
                                                color: Color(0xff041E42),
                                                size: 20.0,
                                              ),
                                              Text(
                                                " ${list[pos]['capacity'].toString()}",
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'MontserratMed'),
                                              ),
                                            ],
                                          ),
                                          // Row(
                                          //
                                          //   children: [
                                          //     Icon(
                                          //       Icons.location,
                                          //       color: Color(0xff041E42),
                                          //       size: 20.0,
                                          //     ),
                                          //     Text(
                                          //       " ${list[pos]['capacity'].toString()}",
                                          //       style: TextStyle(
                                          //           fontSize: 13.0,
                                          //           color: Colors.white,
                                          //           fontFamily: 'MontserratMed'),
                                          //     ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.call,
                                            color: Color(0xff041E42),
                                            size: 20.0,
                                          ),
                                          Text(
                                            " ${list[pos]['phone'].toString()}",
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.white,
                                                fontFamily: 'MontserratMed'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              planetThumbnail,
                            ],
                          ));

                      //   ListTile(
                      //   title: Text(list[pos]['name'].toString()),
                      //   subtitle: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //           "Address:- ${list[pos]['address'].toString()}"),
                      //       Text(
                      //           "Capacity:- ${list[pos]['capacity'].toString()}"),
                      //       Text("Phone:- ${list[pos]['phone'].toString()}"),
                      //     ],
                      //   ),
                      // );
                    },
                    itemCount: list.length,
                    shrinkWrap: true,
                  ),
                  Center(child: Text('No NGO registered yet')),
                  GestureDetector(
                      child: Center(child: Text('Register here')),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => AddNGO()));
                      }),
                ],
              );
  }
}
