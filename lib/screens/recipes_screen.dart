import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';

import 'package:the_chef/components/components.dart';
import 'package:the_chef/network/model_response.dart';
import 'package:the_chef/network/recipe_model.dart';
import 'package:the_chef/network/recipe_service.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  List<APIHits> recipeList = [];
  int currentCount = 0;
  late TextEditingController searchTextController;
  final ScrollController _scrollController = ScrollController();
  int position = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController(text: 'chocolate');
    _scrollController
      ..addListener(() {
        final triggerFetchMoreSize =
            0.7 * _scrollController.position.maxScrollExtent;

        if (_scrollController.position.pixels > triggerFetchMoreSize) {
          if (position < 100 && !loading) {
            setState(() {
              loading = true;
            });
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSearchCard(),
        Expanded(
          child: _buildRecipeLoader(context),
        ),
      ],
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
                startSearch();
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
                      border: InputBorder.none, hintText: ''),
                  autofocus: false,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (value) {
                    startSearch();
                    // if (!previousSearches.contains(value)) {
                    //   previousSearches.add(value);
                    //   savePreviousSearches();
                    // }
                  },
                  controller: searchTextController,
                )),
                // PopupMenuButton<String>(
                //     icon: const Icon(
                //       Icons.arrow_drop_down,
                //       //color: lightGrey,
                //     ),
                //     onSelected: (String value) {
                //       // searchTextController.text = value;
                //       // startSearch(searchTextController.text);
                //     },
                //     itemBuilder: (BuildContext context) {
                //       return previousSearches
                //           .map<CustomDropdownMenuItem<String>>((String value) {
                //         return CustomDropdownMenuItem<String>(
                //           text: value,
                //           value: value,
                //           callback: () {
                //             setState(() {
                //               previousSearches.remove(value);
                //               Navigator.pop(context);
                //             });
                //           },
                //         );
                //       }).toList();
                //     })
              ],
            )),
          ],
        ),
      ),
    );
  }

  void startSearch() {
    setState(() {
      recipeList.clear();
      currentCount = 0;
      position = 0;
    });
  }

  Widget _buildRecipeLoader(BuildContext context) {
    return FutureBuilder<Response<Result<APIRecipeQuery>>>(
        future: RecipeService.create().queryRecipes(
          searchTextController.text.trim(),
          position,
          position + 20,
        ),
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
              // if (snapshot.data?.error != null &&
              //     snapshot.data?.error is LinkedHashMap) {
              //   final map = snapshot.data?.error as LinkedHashMap;
              //   errorMessage = map['message'];
              // }
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
              //inErrorState = true;
              return _buildRecipeList(context, recipeList);
            }

            final query = (result as Success).value;

            position = query.to;
            currentCount = query.count;
            recipeList.addAll(query.hits);

            return _buildRecipeList(context, recipeList);
          } else {
            if (currentCount == 0) {
              return const Center(
                child: SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    color: Color(0xff900B0B),
                    strokeWidth: 2.0,
                  ),
                ),
              );
            } else {
              return _buildRecipeList(context, recipeList);
            }
          }
        });
  }

  Widget _buildRecipeList(BuildContext recipeListContext, List<APIHits> hits) {
    // final size = MediaQuery.of(context).size;
    // const itemHeight = 310;
    // final itemWidth = size.width / 2;
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 0.0,
      ),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          controller: _scrollController,
          itemBuilder: (context, index) {
            final recipe = hits[index].recipe;
            return RecipeThumbnail(recipe: recipe);
          },
          itemCount: hits.length),
    );
  }
}
