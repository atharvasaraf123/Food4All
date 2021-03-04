import 'package:flutter/material.dart';

class NgoPerson extends StatefulWidget {
  List donationList;

  NgoPerson({this.donationList});

  @override
  _NgoPersonState createState() => _NgoPersonState();
}

class _NgoPersonState extends State<NgoPerson> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (BuildContext context, int pos) {
      return ListTile(
        title: Text(widget.donationList[pos]['foodItems']),
      );
    },
      itemCount: widget.donationList.length,);
  }
}
