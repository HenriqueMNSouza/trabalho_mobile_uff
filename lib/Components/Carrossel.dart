import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carrossel {
  Widget carrossel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
      ),
      items: [
        Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage('images/pf1.jpg'),
                fit: BoxFit.cover,
              )),
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage('images/pf2.jpg'),
                fit: BoxFit.cover,
              )),
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage('images/pf3.jpg'),
                fit: BoxFit.cover,
              )),
        )
      ],
    );
  }
}
