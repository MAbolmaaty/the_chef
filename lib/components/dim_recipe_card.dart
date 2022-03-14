import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      ],
    ),
  );
}
