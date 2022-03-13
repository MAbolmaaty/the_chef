import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:chopper/chopper.dart';
import '../../network/model_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_chef/colors.dart';
import 'package:the_chef/models/fooderlich_pages.dart';
import 'package:the_chef/network/recipe_model.dart';
import 'package:the_chef/network/recipe_service.dart';
import 'package:the_chef/screens/recipes/recipe_card.dart';
import 'package:the_chef/screens/recipes/recipe_details.dart';
import 'package:the_chef/widgets/custom_dropdown.dart';

class RecipeList extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
        name: FooderlichPages.SearchRecipesPath,
        key: ValueKey(FooderlichPages.SearchRecipesPath),
        child: RecipeList());
  }

  const RecipeList({Key? key}) : super(key: key);

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  static const String prefSearchKey = 'previousSearches';

  late TextEditingController searchTextController;
  final ScrollController _scrollController = ScrollController();
  List<APIHits> currentSearchList = [];
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 20;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  List<String> previousSearches = <String>[];
  //APIRecipeQuery? _currentRecipes1 = null;

  @override
  void initState() {
    super.initState();
    //loadRecipes();
    getPreviousSearches();
    searchTextController = TextEditingController(text: '');
    _scrollController
      ..addListener(() {
        final triggerFetchMoreSize =
            0.7 * _scrollController.position.maxScrollExtent;

        if (_scrollController.position.pixels > triggerFetchMoreSize) {
          if (hasMore &&
              currentEndPosition < currentCount &&
              !loading &&
              !inErrorState) {
            setState(() {
              loading = true;
              currentStartPosition = currentEndPosition;
              currentEndPosition =
                  min(currentStartPosition + pageCount, currentCount);
            });
          }
        }
      });
  }

  // Future<APIRecipeQuery> getRecipeData(String query, int from, int to) async {
  //   final recipeJson = await RecipeService().getRecipes(query, from, to);
  //   final recipeMap = json.decode(recipeJson);
  //   return APIRecipeQuery.fromJson(recipeMap);
  // }

  // Future loadRecipes() async {
  //   final jsonString =
  //       await rootBundle.loadString('assets/sample_data/recipes1.json');
  //   setState(() {
  //     _currentRecipes1 = APIRecipeQuery.fromJson(jsonDecode(jsonString));
  //   });
  // }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void savePreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(prefSearchKey, previousSearches);
  }

  void getPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(prefSearchKey)) {
      final searches = prefs.getStringList(prefSearchKey);
      if (searches != null) {
        previousSearches = searches;
      } else {
        previousSearches = <String>[];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fooderlich',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _buildSearchCard(),
              _buildRecipeLoader(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                startSearch(searchTextController.text);

                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              icon: const Icon(Icons.search),
            ),
            const SizedBox(
              width: 6.0,
            ),
            Expanded(
                child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Search'),
                  autofocus: false,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    if (!previousSearches.contains(value)) {
                      previousSearches.add(value);
                      savePreviousSearches();
                    }
                  },
                  controller: searchTextController,
                )),
                PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: lightGrey,
                    ),
                    onSelected: (String value) {
                      searchTextController.text = value;
                      startSearch(searchTextController.text);
                    },
                    itemBuilder: (BuildContext context) {
                      return previousSearches
                          .map<CustomDropdownMenuItem<String>>((String value) {
                        return CustomDropdownMenuItem<String>(
                          text: value,
                          value: value,
                          callback: () {
                            setState(() {
                              previousSearches.remove(value);
                              Navigator.pop(context);
                            });
                          },
                        );
                      }).toList();
                    })
              ],
            )),
          ],
        ),
      ),
    );
  }

  void startSearch(String value) {
    setState(() {
      currentSearchList.clear();
      currentCount = 0;
      currentEndPosition = pageCount;
      currentStartPosition = 0;
      hasMore = true;
      value = value.trim();

      if (!previousSearches.contains(value)) {
        previousSearches.add(value);
        savePreviousSearches();
      }
    });
  }

  Widget _buildRecipeLoader(BuildContext context) {
    if (searchTextController.text.length < 3) {
      return Container();
    }

    return FutureBuilder<Response<Result<APIRecipeQuery>>>(
        future: RecipeService.create().queryRecipes(
            searchTextController.text.trim(),
            currentStartPosition,
            currentEndPosition),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.3,
                ),
              );
            }

            loading = false;

            if (false == snapshot.data?.isSuccessful) {
              var errorMessage = 'Problems getting data';
              if (snapshot.data?.error != null &&
                  snapshot.data?.error is LinkedHashMap) {
                final map = snapshot.data?.error as LinkedHashMap;
                errorMessage = map['message'];
              }
              return Center(
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18.0),
                ),
              );
            }

            final result = snapshot.data?.body;

            if (result == null || result is Error) {
              inErrorState = true;
              return _buildRecipeList(context, currentSearchList);
            }

            final query = (result as Success).value;

            inErrorState = false;
            currentCount = query.count;
            hasMore = query.more;
            currentSearchList.addAll(query.hits);

            if (query.to < currentEndPosition) {
              currentEndPosition = query.to;
            }

            return _buildRecipeList(context, currentSearchList);
          } else {
            if (currentCount == 0) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return _buildRecipeList(context, currentSearchList);
            }
          }
        });
  }

  Widget _buildRecipeList(BuildContext recipeListContext, List<APIHits> hits) {
    final size = MediaQuery.of(context).size;
    const itemHeight = 310;
    final itemWidth = size.width / 2;

    return Flexible(
        child: GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            itemCount: hits.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildRecipeCard(recipeListContext, hits, index);
            }));
  }

  Widget _buildRecipeCard(
      BuildContext topLevelContext, List<APIHits> hits, int index) {
    final recipe = hits[index].recipe;
    return GestureDetector(
      onTap: () {
        Navigator.push(topLevelContext, MaterialPageRoute(builder: (context) {
          return const RecipeDetails();
        }));
      },
      child: recipeCard(recipe),
    );
  }
}