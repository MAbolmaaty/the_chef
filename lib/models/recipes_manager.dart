import 'package:flutter/material.dart';
import 'package:the_chef/network/recipe_model.dart';

class RecipesManager extends ChangeNotifier {
  List<APIHits> _recipes = [];
  int _selectedIndex = -1;

  List<APIHits> get recipes => List.unmodifiable(_recipes);
  int get selectedIndex => _selectedIndex;

  set recipes(List<APIHits> newRecipes) => _recipes = newRecipes;

  void recipeItemTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
