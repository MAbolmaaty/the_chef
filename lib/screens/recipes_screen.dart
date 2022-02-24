import 'package:flutter/material.dart';
import 'package:the_chef/api/mock_fooderlick_service.dart';
import 'package:the_chef/components/components.dart';

import '../models/models.dart';

class RecipesScreen extends StatelessWidget {
  final exploreService = MockFooderlickService();

  RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: exploreService.getRecipes(),
      builder: (context, AsyncSnapshot<List<SimpleRecipe>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return RecipesGridView(recipes: snapshot.data ?? []);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
