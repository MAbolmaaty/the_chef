import 'package:flutter/material.dart';

class CuisinesListView extends StatelessWidget {
  CuisinesListView({Key? key}) : super(key: key);

  final List<String> cuisines = [
    'American Cuisine',
    'British Cuisine',
    'Chinese Cuisine',
    'French Cuisine',
    'Indian Cuisine',
    'Italian Cuisine',
    'Japanese Cuisine',
    'Mexican Cuisine',
    'Middle Eastern Cuisine',
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

  Widget _buildCard(String cuisine) {
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
      child: Center(
        child: Text(
          cuisine,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: Color(0xff900B0B)),
        ),
      ),
    );
  }
}
