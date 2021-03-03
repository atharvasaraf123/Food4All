import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AddNgo.dart';

class NGOs extends StatefulWidget {
  @override
  _NGOsState createState() => _NGOsState();
}

class _NGOsState extends State<NGOs> {

  bool ngo=false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ngoCol = FirebaseFirestore.instance.collection('NGO');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkNgo();
  }

  checkNgo()async{
    User user=FirebaseAuth.instance.currentUser;
    DocumentSnapshot ds = await ngoCol.doc(user.uid).get();
    setState(() {
      ngo=ds.exists;
    });
    print(ngo);
  }

  @override
  Widget build(BuildContext context) {
    return ngo?Container(
      child: Text('abc',style: TextStyle(color: Colors.black),),
    ):Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text('No NGO registered yet'),
        GestureDetector(child: Text('Register here'),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>AddNGO()));
        },)
      ],),
    );
  }
}
