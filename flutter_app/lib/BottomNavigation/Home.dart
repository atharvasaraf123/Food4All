import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
      child: Container(
          child: ListView.builder(
        itemBuilder: (BuildContext context, int pos) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 350,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _circleAvatar(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Donor name',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black87,
                                  fontFamily: 'MontserratBold',
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                'City name',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black87,
                                  fontFamily: 'MontserratMed',
                                ),
                                textAlign: TextAlign.start,
                              ),

                            ],

                          ),
                        ),
                      ],
                    ),
                  ),

                  // _displayText(),
                  _showImage(5),
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.orangeAccent.withAlpha(50),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
          );
        },
        itemCount: 5,
      )),
    );
  }

  Widget Image1(dynamic image) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
              Colors.purple[700].withOpacity(0.8), BlendMode.dstATop),
          image: AssetImage(image),
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        // border: Border.all(color: Colors.grey, width: 0.2)
      ),
    );
  }

  _showImage(int count) {
    return Container(
      alignment: Alignment.center,
      height: 250,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Swiper(
        itemCount: count,
        autoplay: true,
        //set width of image
        duration: 500,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Image1("images/picture0.jpg");
            //create Image1() function
          } else if (index == 1) {
            return Image1("images/picture1.jpg");
          } else if (index == 2) {
            return Image1("images/picture2.jpg");
          } else if (index == 3) {
            return Image1("images/picture3.jpg");
          } else {
            return Image1("images/picture5.jpg");
          }
        },
      ),
    );
  }

  _displayText() {
    return Container(
      padding: EdgeInsets.all(10.0),
    );
  }
}

Widget _circleAvatar() {
  return Container(
    width: 40,
    height: 40,
    padding: EdgeInsets.all(10.0),

    decoration: BoxDecoration(
      border: Border.all(color: Colors.red, width: 1),

      shape: BoxShape.circle,
      color: Colors.white,
      image: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage('images/vaibhav.jpeg'),
      ), // Decoration image
    ), // Box decoration
  ); // Container
}
/*
*  Container(
          height: 170,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.all(
                  //     Radius.circular(10.0)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xffffffff).withOpacity(0.4),
                      Color(0x00000000).withOpacity(0.001),
                    ],
                  ),
                ),
              ),
              Swiper(
                itemCount: 5,
                viewportFraction: 0.5,
                scale: 0.5,
                autoplay: true,
                //set width of image

                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Image1("images/picture0.jpg");
                    //create Image1() function
                  } else if (index == 1) {
                    return Image1("images/picture1.jpg");
                  } else if (index == 2) {
                    return Image1("images/picture2.jpg");
                  } else if (index == 3) {
                    return Image1("images/picture3.jpg");
                  } else {
                    return Image1("images/picture5.jpg");
                  }
                },
              )
            ],
          ),
        ),
* */
