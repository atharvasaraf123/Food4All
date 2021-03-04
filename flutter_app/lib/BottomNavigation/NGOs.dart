import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AddNgo.dart';

class NGOs extends StatefulWidget {
  @override
  _NGOsState createState() => _NGOsState();
}

class _NGOsState extends State<NGOs> {
  bool ngo = false;
  bool load = true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ngoCol = FirebaseFirestore.instance.collection('NGO');
  CollectionReference donCol = FirebaseFirestore.instance.collection('donation');
  List list;
  List donationList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkNgo();
  }

  getDonationList()async{
    await donCol.get().then((value){
      setState(() {
        donationList=value.docs;
        load=false;
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
        // value.docs.forEach((element) {
        //   list.add(element);
        // });
      });
    }else{
      await getDonationList();
    }
    print(list);
  }

  @override
  Widget build(BuildContext context) {
    return load == true
        ? CircularProgressIndicator()
        : ngo
            ? ListView.builder(itemBuilder: (BuildContext context,int pos){
              return ListTile(
                title: Text(),
              );
    })
            : ListView(
                children: [
                  ListView.builder(
                    itemBuilder: (BuildContext context, int pos) {
                      return ListTile(
                        title: Text(list[pos]['name'].toString()),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "Address:- ${list[pos]['address'].toString()}"),
                            Text(
                                "Capacity:- ${list[pos]['capacity'].toString()}"),
                            Text("Phone:- ${list[pos]['phone'].toString()}"),
                          ],
                        ),
                      );
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
