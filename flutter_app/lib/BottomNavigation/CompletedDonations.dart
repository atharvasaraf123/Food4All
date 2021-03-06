import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CompletedDonations extends StatefulWidget {
  @override
  _CompletedDonationsState createState() => _CompletedDonationsState();
}

class _CompletedDonationsState extends State<CompletedDonations> {
  bool load=true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference donCol =
  FirebaseFirestore.instance.collection('donation');
  List don;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOngoingDonation();
  }

  bool isBefore(String date){
    return DateFormat.yMMMEd().add_jm().parse(date).isBefore(DateTime.now());
  }

  giveDate(String date){
    DateTime dateTime=DateFormat.yMMMEd().add_jm().parse(date);
    return DateFormat.MMMMEEEEd().format(dateTime);
  }

  getOngoingDonation()async{
    String uid=FirebaseAuth.instance.currentUser.uid;
    don=List();
    await donCol.get().then((value){
      List list=value.docs;
      for(int i=0;i<list.length;i++){
        if(list[i]['completed']==false && list[i]['uid']==uid &&isBefore(list[i]['dateTime'])){
          don.add(list[i]);
        }
      }
      setState(() {
        load=false;
      });
    }).catchError((onError){
      Fluttertoast.showToast(msg: "Something went wrong");
      setState(() {
        load=false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return don.length==0?Scaffold(
        appBar: AppBar(title: Text('Completed Donations',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: 'MontserratSemi',
        ),),),
        body: Center(child: Text('No Completed donations',style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          fontFamily: 'MontserratSemi',
        ),))):Scaffold(
      appBar: AppBar(title: Text('Completed Donations'),),
      body: ListView.builder(itemBuilder: (BuildContext context,int pos){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(
                title: Text('Name :${don[pos]['name']}',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'MontserratReg',
                ),),
                subtitle:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Address :${don[pos]['address']}',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'MontserratReg',
                    ),),
                    SizedBox(height: 5,),
                    Text('Date :${giveDate(don[pos]['dateTime'])}',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'MontserratReg',
                    ),),
                    SizedBox(height: 5,),
                    Text('Food Items : ${(don[pos]['foodItems'])}',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'MontserratReg',
                    ),),
                  ],
                ),
              ),
              Divider(thickness: 1.3,color: Colors.grey,)
            ],
          ),
        );
      },
        itemCount: don.length,),
    );
  }
}
