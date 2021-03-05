import 'package:flutter/material.dart';

class IndividualScreen extends StatefulWidget {
  @override
  _IndividualScreenState createState() => _IndividualScreenState();
}

class _IndividualScreenState extends State<IndividualScreen> {

  Widget _images(){
    return Container(
      child: Stack(
        children: <Widget>[
          Image.asset("images/shoe_blue.png",), //This
          // should be a paged
          // view.
          Positioned(child:_getBackBtn(),top: 0,),
          Positioned(child: FloatingActionButton(
              elevation: 2,
              child:Image.asset("images/heart_icon_disabled.png",
                width: 30,
                height: 30,),
              backgroundColor: Colors.white,
              onPressed: (){}
          ),
            bottom: 0,
            right: 20,
          ),

        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }


  _getBackBtn() {
    return Positioned(
      top: 35,
      left: 25,
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
      ),
    );
  }



  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.asset(widget.product.images[index]),
      ),
    );
  }



}
