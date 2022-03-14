import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_chef/models/cuisine.dart';

class CuisinesListView extends StatelessWidget {
  CuisinesListView({Key? key}) : super(key: key);

  final List<Cuisine> cuisines = [
    Cuisine(
        label: 'American Cuisine',
        image: "assets/images/statue_of_liberty.svg"),
    Cuisine(label: 'British Cuisine', image: "assets/images/london_bridge.svg"),
    Cuisine(label: 'Chinese Cuisine', image: "assets/images/dragon.svg"),
    Cuisine(label: 'French Cuisine', image: "assets/images/eifel_tower.svg"),
    Cuisine(label: 'Indian Cuisine', image: "assets/images/taj-mahal.svg"),
    Cuisine(label: 'Italian Cuisine', image: "assets/images/tower_of_pisa.svg"),
    Cuisine(label: 'Japanese Cuisine', image: "assets/images/tori_gate.svg"),
    Cuisine(label: 'Mexican Cuisine', image: "assets/images/mexico.svg"),
    Cuisine(
        label: 'Middle Eastern Cuisine',
        image: "assets/images/eye_of_horus.svg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 100,
        color: Colors.transparent,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return _buildCard(cuisines[index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 16.0,
            );
          },
          itemCount: cuisines.length,
        ),
      ),
    );
  }

  Widget _buildCard(Cuisine cuisine) {
    return Container(
      height: 40,
      width: 40,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: const Offset(1, 2),
              blurRadius: 5,
              spreadRadius: 1),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              cuisine.image,
              height: 50.0,
              width: 50.0,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              cuisine.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff900B0B)),
            ),
          ),
        ],
      ),
    );
  }
}
