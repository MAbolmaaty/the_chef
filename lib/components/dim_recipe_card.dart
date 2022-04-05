import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_chef/network/recipe_model.dart';

Widget dimRecipeCard(APIRecipe recipe) {
  return Card(
    elevation: 2.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: CachedNetworkImage(
            imageUrl: recipe.image,
            height: 250,
            width: 250,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
            // 1
            color: Colors.black.withOpacity(0.2),
            // 2
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        Positioned(
            child: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.source,
                style: GoogleFonts.aclonica(
                    color: const Color(0xff900B0B), fontSize: 10),
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(recipe.label,
                  style: GoogleFonts.adventPro(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  )),
            ],
          ),
        )),
        Positioned(
            bottom: 5.0,
            right: 5.0,
            child: Column(
              children: [
                Text(
                  getCalories(recipe.calories),
                  style: GoogleFonts.aleo(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
                Text(
                  getweight(recipe.totalWeight),
                  style: GoogleFonts.aleo(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
        Positioned(
          bottom: 5.0,
          left: 5.0,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const SizedBox(
                width: 2.0,
              ),
              Text(
                getTime(recipe.totalTime),
                style: GoogleFonts.aleo(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
