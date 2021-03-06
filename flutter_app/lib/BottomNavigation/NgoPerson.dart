import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/IndivisualView/IndividualHungerSpot.dart';
import 'package:flutter_app/konstants/functions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

import 'IndividualScreen.dart';

class NgoPerson extends StatefulWidget {
  Map<String,List> completeDonation;
  List activeDonation;
  List hungerspot;
  NgoPerson({this.completeDonation,this.hungerspot,this.activeDonation});

  @override
  _NgoPersonState createState() => _NgoPersonState();
}

class _NgoPersonState extends State<NgoPerson> {
  DateTime dateTime=DateTime.now();
  final storage=FlutterSecureStorage();
  double lat;
  double long;
  bool load=true;
  String city;
  int selDate=0;
  String selDate1=DateFormat.MMMMd().format(DateTime.now());

  String format(DateTime dateTime){
    return DateFormat.MMMMd().format(dateTime);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLatLong();

  }

  getLatLong()async{
    city=await storage.read(key: 'city');
    String lat1=(await storage.read(key: 'lat'));
    String long1=(await storage.read(key: 'long'));
    lat=double.parse(lat1);
    long=double.parse(long1);
    setState(() {
      load=false;
    });
  }

  giveDate(String date){
    DateTime dateTime=DateFormat.yMMMEd().add_jm().parse(date);
    return DateFormat.MMMMd().add_jm().format(dateTime);
  }
  giveTime(String date){
    DateTime dateTime=DateFormat.yMMMEd().add_jm().parse(date);
    return DateFormat.jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return load==true?CircularProgressIndicator():Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int pos) {
                          return GestureDetector(
                            onTap: (){
                              setState(() {
                                selDate=pos;
                                selDate1=format(dateTime.add(Duration(days: pos)));
                              });
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  width: 100,
                                  height: 45,
                                  child: Center(
                                    child: Text(
                                      format(dateTime.add(Duration(days: pos))),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: pos!=selDate?Color(0xffffe4e1):Colors.black87,
                                          fontFamily: 'MontserratBold'),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    shape: BoxShape.rectangle,
                                    color: pos==selDate?Color(0xffffe4e1):Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        shrinkWrap: true,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      margin: EdgeInsets.only(left: 15.0),
                      // padding: EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !widget.completeDonation.containsKey(selDate1)||widget.completeDonation[selDate1].length==0? Text(
                            'NO ONGOING DONATIONS',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontFamily: 'MontserratBold'),
                          ):Text(
                            'ONGOING DONATIONS',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontFamily: 'MontserratBold'),
                          ),
                          showAcceptedDonations(),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromRGBO(58, 66, 86, 1.0),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(25.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                child: Text(
                  'AVAILABLE DONATIONS',
                  textAlign: TextAlign.start,
                  style:
                      TextStyle(fontSize: 12.0, fontFamily: 'MontserratBold'),
                ),
              ),
              showAvailableDonations(),
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15.0),
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'HUNGER SPOTS',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                  fontFamily: 'MontserratBold'),
                            ),
                          ),
                          showHungerSpots(),
                        ],
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromRGBO(58, 66, 86, 1.0),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(25.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    //   ListView.builder(itemBuilder: (BuildContext context, int pos) {
    //   return ListTile(
    //     title: Text(widget.donationList[pos]['foodItems']),
    //   );
    // },
    //   itemCount: widget.donationList.length,);
  }



  showAvailableDonations() {
    return Container(
      height: 225,
      margin: EdgeInsets.only(left: 10.0),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int pos) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
              child: Container(
                height: 205,
                width: 180,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_outlined,
                                  size: 20.0,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    giveDate(widget.activeDonation[pos]['dateTime']),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'MontserratBold'),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          widget.activeDonation[pos]['name'],
                          style: TextStyle(
                              fontSize: 15.0, fontFamily: 'MontserratBold'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: [
                            Text(
                              'Food Items : ',
                              style: TextStyle(
                                  fontSize: 12.0, fontFamily: 'MontserratBold'),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.activeDonation[pos]['foodItems'],
                              style: TextStyle(
                                  fontSize: 12.0, fontFamily: 'MontserratReg'),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            size: 16.0,
                          ),
                          SizedBox(width: 5,),
                          Text(
                            '${widget.activeDonation[pos]['minQ']} - ${widget
                                .activeDonation[pos]['maxQ']}',
                            style: TextStyle(
                                fontSize: 12.0, fontFamily: 'MontserratMed'),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SingleChildScrollView(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on_outlined),
                                Text(
          widget.activeDonation[pos]['address'],
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'MontserratMed'),
                                )
                              ],
                            ),
                            scrollDirection: Axis.horizontal,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: MaterialButton(
                                padding: EdgeInsets.all(0.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Interested',
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontFamily: 'MontserratMed'),
                                    ),
                                  ],
                                ),
                                textColor: Color(0xffffe4e1),
                                color: Colors.black,
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext conntext)=>IndividualScreen(data: widget.activeDonation[pos],)));
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
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
                  color: Colors.orangeAccent.withAlpha(100),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount:widget.activeDonation.length,
        shrinkWrap: true,
      ),
    );
  }

  showAcceptedDonations() {
    return Container(
      height: !widget.completeDonation.containsKey(selDate1)||widget.completeDonation[selDate1].length==0?40:190,
      child: !widget.completeDonation.containsKey(selDate1)||widget.completeDonation[selDate1].length==0?Container():Align(
        alignment: Alignment.centerLeft,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int pos) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: Container(
                  height: 175,
                  width: 180,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_outlined,
                                    size: 20.0,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      giveTime(widget.completeDonation[selDate1][pos]['dateTime']),
                                      style: TextStyle(
                                          fontSize: 12.0,
                                          fontFamily: 'MontserratBold'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                // alignment: Alignment.topRight,
                                padding: EdgeInsets.all(5.0),
                                width: 40,
                                height: 25,
                                child: Center(
                                  child: Text(
                                    'Live',
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: Color(0xffffe4e1),
                                        fontFamily: 'MontserratBold'),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3.0)),
                                  shape: BoxShape.rectangle,
                                  color: Colors.black87,
                                ),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Text(
                              widget.completeDonation[selDate1][pos]['name'],
                            style: TextStyle(
                                fontSize: 15.0, fontFamily: 'MontserratBold'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Row(
                            children: [
                              Text(
                                'Food Items : ',
                                style: TextStyle(
                                    fontSize: 12.0, fontFamily: 'MontserratBold'),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                widget.completeDonation[selDate1][pos]['foodItems'],
                                style: TextStyle(
                                    fontSize: 12.0, fontFamily: 'MontserratReg'),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_alt_outlined,
                              size: 16.0,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              ' ${widget.completeDonation[selDate1][pos]['minQ']} - ${widget.completeDonation[selDate1][pos]['maxQ']}',
                              style: TextStyle(
                                  fontSize: 12.0, fontFamily: 'MontserratMed'),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16.0,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              '${distanceBetween1(lat, long, widget.completeDonation[selDate1][pos]['lat'], widget.completeDonation[selDate1][pos]['long'])}',
                              style: TextStyle(
                                  fontSize: 12.0, fontFamily: 'MontserratMed'),
                            )
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined),
                            SizedBox(width: 5,),
                            Text(
                              widget.completeDonation[selDate1][pos]['address'],
                              style: TextStyle(
                                  fontSize: 12.0, fontFamily: 'MontserratMed'),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffffe4e1),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            );
          },
          scrollDirection: Axis.horizontal,
          itemCount: widget.completeDonation[selDate1].length,
          shrinkWrap: true,
        ),
      ),
    );
  }

  showHungerSpots() {
    return Container(
      height: 225,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int pos) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Container(
                padding: EdgeInsets.only(top: 10.0),
                height: 215,
                width: 180,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: Row(
                          children: [
                            Text(
                              'Add: ',
                              style: TextStyle(
                                  fontSize: 12.0, fontFamily: 'MontserratBold'),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              widget.hungerspot[pos]['address'],
                              style: TextStyle(
                                  fontSize: 12.0, fontFamily: 'MontserratMed'),
                            )
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5.0),
                      child: Row(
                        children: [
                          Text(
                            'Spot Type: : ',
                            style: TextStyle(
                                fontSize: 12.0, fontFamily: 'MontserratBold'),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            widget.hungerspot[pos]['hungerSpotType'],
                            style: TextStyle(
                                fontSize: 12.0, fontFamily: 'MontserratReg'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    //
                    // Padding(
                    //     padding: const EdgeInsets.all(5.0),
                    //     child: Wrap(
                    //       spacing: 5.0,
                    //       runSpacing: 5.0,
                    //       children: _choice(),
                    //     )),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.people_alt_outlined,
                            size: 16.0,
                          ),
                          Text(
                            '${widget.hungerspot[pos]['minP']} - ${widget.hungerspot[pos]['maxP']}',
                            style: TextStyle(
                                fontSize: 12.0, fontFamily: 'MontserratMed'),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16.0,
                          ),
                          Text(
                            "${distanceBetween1(lat, long, widget.hungerspot[pos]['lat'], widget.hungerspot[pos]['long'])} km",
                            style: TextStyle(
                                fontSize: 12.0, fontFamily: 'MontserratMed'),
                          )
                        ],
                      ),
                    ),
                    Container(
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
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: RaisedButton(
                          padding: EdgeInsets.all(0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'View',
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontFamily: 'MontserratMed'),
                              ),
                            ],
                          ),
                          textColor: Color(0xffffe4e1),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>IndividualHungerSpot(data: widget.hungerspot[pos],lat:lat,long: long,)));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xffffe4e1),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: widget.hungerspot.length,
        shrinkWrap: true,
      ),
    );
  }

  _choice() {
    return <Widget>[
      Container(
        child: ChoiceChip(
          label: Text("SLUM"),
          labelStyle: TextStyle(
              color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.grey.shade400)),
          elevation: 1.0,
          backgroundColor: Color(0x88ededed),
          selectedColor: Colors.orange.shade600,
          selected: false,
          onSelected: (selected) {
            setState(() {});
          },
        ),
      )
    ];
  }
}
