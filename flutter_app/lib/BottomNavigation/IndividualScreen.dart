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
        child: Container(
          child: Stack(
            children: [
              AppBackground(),
              _getBackBtn(),
              // _likeButton(),
              Column(
                children: [
                  Body(donation: Donation(id: 0, images: images)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 10.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          'Posted By',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'MontserratBold'),
                                          textAlign: TextAlign.center,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  size: 20.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    child: Text(
                                                      'Name',
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontFamily:
                                                              'MontserratBold'),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.call,
                                                  size: 20.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    child: Text(
                                                      '999999999',
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontFamily:
                                                              'MontserratBold'),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xffdddddd),
                                          Color(0xffffffff)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              'Food Items : ',
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'MontserratBold'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Paneer bhurji,Pav Bhaji,Pani puri',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily:
                                                          'MontserratReg'),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xffdddddd),
                                            Color(0xffffffff)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  size: 22.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    child: Text(
                                                      'location distance',
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontFamily:
                                                              'MontserratBold'),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Icon(
                                                  Icons.location_city,
                                                  size: 22.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    child: Text(
                                                      'Spot Type',
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontFamily:
                                                              'MontserratBold'),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Icon(
                                                  Icons.people_alt_rounded,
                                                  size: 22.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    child: Text(
                                                      '150-200',
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontFamily:
                                                              'MontserratBold'),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xffdddddd),
                                          Color(0xffffffff)
                                        ],
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25.0, vertical: 35.0),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: InkWell(
                                        // onTap: ()async{
                                        //   if(_formKey.currentState.validate()){
                                        //     _formKey.currentState.save();
                                        //     await donateFood(context);
                                        //   }
                                        // },
                                        child: Container(
                                          width: 150,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              gradient: LinearGradient(colors: [
                                                Color(0xFFea9b72),
                                                Color(0xFFff9e33)
                                              ])),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Center(
                                                child: Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontStyle: FontStyle.normal,
                                                      fontFamily: 'MontserratSemi'),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0)),
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [],
              ),
            ],
          ),
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
    return Positioned(
      child: Container(
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
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.white70),
      ),
      top: 10,
      right: 10,
    );
  }
}
