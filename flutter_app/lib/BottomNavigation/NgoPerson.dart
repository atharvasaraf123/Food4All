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
    return Scaffold(



      body: Container(


        child: Column(

          children: [

            Container(
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.pink.shade100,
                border: Border(
                  // bottom: BorderRadius
                )

              ),
            )

          ],





        ),

      ),

    ) ;

    //   ListView.builder(itemBuilder: (BuildContext context, int pos) {
    //   return ListTile(
    //     title: Text(widget.donationList[pos]['foodItems']),
    //   );
    // },
    //   itemCount: widget.donationList.length,);
  }
}
