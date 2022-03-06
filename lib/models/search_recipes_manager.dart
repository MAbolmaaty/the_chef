import 'package:flutter/material.dart';

class SearchRecipesManager extends ChangeNotifier {
  bool _searchScreen = false;

  bool get searchScreen => _searchScreen;

  void tapOnSearch(bool selected) {
    _searchScreen = selected;
    notifyListeners();
  }
}
