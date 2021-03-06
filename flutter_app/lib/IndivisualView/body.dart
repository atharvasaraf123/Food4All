import 'package:flutter/material.dart';
import 'package:flutter_app/IndivisualView/Donation_images.dart';

import 'Donation.dart';

class Body extends StatelessWidget {
  final Donation donation;

  const Body({Key key, @required this.donation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Donation_images(donation: donation);
  }
}
