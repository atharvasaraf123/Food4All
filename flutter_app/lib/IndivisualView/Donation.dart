import 'package:flutter/material.dart';

class Donation {
  final int id;
  // final String title, description;
  final List<String> images;
  // final List<Color> colors;
  // final double rating, price;
  final bool isFavourite, isPopular;

  Donation({
    @required this.id,
    @required this.images,
    // @required this.colors,
    // this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    // @required this.title,
    // @required this.price,
    // @required this.description,
  });
}

// Our demo Products


const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
