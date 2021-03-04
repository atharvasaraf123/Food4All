import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NgoPerson extends StatefulWidget {
  List donationList;

  NgoPerson({this.donationList});

  @override
  _NgoPersonState createState() => _NgoPersonState();
}

class _NgoPersonState extends State<NgoPerson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10.0),
              height: 80,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int pos) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        width: 100,
                        height: 45,
                        child: Center(
                          child: Text(
                            'March 05',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xffffe4e1),
                                fontFamily: 'MontserratBold'),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          shape: BoxShape.rectangle,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                shrinkWrap: true,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xffffe4e1),
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(25.0)),
              ),
            ),
            SizedBox(height: 15.0),
            Container(
              height: 225,
              margin: EdgeInsets.only(left: 10.0),
              child: ListView.builder(
                itemBuilder: (BuildContext context, int pos) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 225,
                        width: 150,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_outlined,size: 20.0,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal:8.0),
                                          child: Text('9:45 AM',style: TextStyle(
                                              fontSize: 12.0,
                                              fontFamily: 'MontserratBold'
                                          ),),
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
                                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                        shape: BoxShape.rectangle,
                                        color: Colors.black87,
                                      ),
                                    ),

                                  ]
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
                itemCount: 5,
                shrinkWrap: true,
              ),
            ),
          ],
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
}
