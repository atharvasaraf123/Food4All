import 'package:flutter/material.dart';
import 'package:flutter_app/IndivisualView/Donation.dart';
import 'package:flutter_app/IndivisualView/body.dart';
import 'package:like_button/like_button.dart';

import 'Donate_Food.dart';

class IndividualScreen extends StatefulWidget {
  @override
  _IndividualScreenState createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {


  List<String> images = [
    "images/ngoCharity2.png",
    "images/fooddonationhand.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AppBackground(),
            Container(
              height: 300,
              child: Column(
                children: [
                  Body(donation: Donation(id: 0, images: images)),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Food Items : ',
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: 'MontserratBold'),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Paneer bhurji,Pav Bhaji,Pani puri',
                          style: TextStyle(
                              fontSize: 16.0, fontFamily: 'MontserratReg'),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            _getBackBtn(),
            _likeButton(),

          ],
        ),
      ),
    );
  }


  _getBackBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
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

  _likeButton() {
    return   Positioned(
      child:  Container(
        width: 40,
        height: 40,
        child: Center(
          child: LikeButton(
            circleColor:
            CircleColor(start: Color(0xFFF44336), end: Color(0xFFF44336)),
            likeBuilder: (bool isLiked) {
              return Icon(
                Icons.favorite,
                size: 30,
                color: isLiked ? Colors.red : Colors.grey,
              );
            },
          ),
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white70),
      ),
      top: 10,
      right: 10,
    );
  }
}
