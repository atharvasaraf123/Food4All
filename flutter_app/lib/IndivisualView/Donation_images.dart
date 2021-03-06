import 'package:flutter/material.dart';
import 'package:flutter_app/konstants/Constansts.dart';

import '../size_config.dart';
import 'Donation.dart';

class Donation_images extends StatefulWidget {
  const Donation_images({
    Key key,
    @required this.donation,
  }) : super(key: key);

  final Donation donation;

  @override
  _Donation_imagesState createState() => _Donation_imagesState();
}

class _Donation_imagesState extends State<Donation_images> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 20.0),
      child: Column(
        children: [
          SizedBox(
            width: getProportionateScreenWidth(238),
            child: AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: widget.donation.id.toString(),
                child: Image.asset(widget.donation.images[selectedImage]),
              ),
            ),
          ),
          // SizedBox(height: getProportionateScreenWidth(20)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(widget.donation.images.length,
                    (index) => buildSmallProductPreview(index)),
              ],
            ),
          )
        ],
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
        child: Image.asset(widget.donation.images[index]),
      ),
    );
  }
}
