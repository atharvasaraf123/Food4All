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
        child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
      child: Container(
        child: Container(
          height: 150,
          child: Swiper(
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
          ),
        ),
      ),
    ));
  }

  Widget Image1(dynamic image) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.purple[700].withOpacity(0.8), BlendMode.dstATop),
          image: AssetImage(image),
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }
}
