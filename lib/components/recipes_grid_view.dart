import 'package:flutter/material.dart';
import 'package:the_chef/components/components.dart';
import 'package:the_chef/models/models.dart';
import 'package:the_chef/network/recipe_model.dart';

class RecipesGridView extends StatelessWidget {
  final List<APIHits> recipes;

  const RecipesGridView({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 0.0,
      ),
      child: GridView.builder(
          itemCount: recipes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (context, index) {
            final recipe = recipes[index].recipe;
            return RecipeThumbnail(recipe: recipe);
          }),
    );
  }
}
