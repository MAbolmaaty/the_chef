import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_chef/models/recipes_manager.dart';
import 'package:the_chef/network/recipe_model.dart';

class RecipeThumbnail extends StatelessWidget {
  final RecipesManager recipesManager;
  final int index;
  final APIRecipe recipe;

  const RecipeThumbnail({
    Key? key,
    required this.recipesManager,
    required this.index,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        recipesManager.recipeItemTapped(index);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: CachedNetworkImage(
              imageUrl: recipe.image,
              fit: BoxFit.cover,
            )),
            const SizedBox(
              height: 10,
            ),
            Text(
              recipe.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Text(
              getTime(recipe.totalTime),
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ),
    );
  }
}
