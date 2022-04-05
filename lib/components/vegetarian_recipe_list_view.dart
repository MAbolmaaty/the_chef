import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:the_chef/components/dim_recipe_card.dart';
import 'package:the_chef/network/model_response.dart';
import 'package:the_chef/network/recipe_model.dart';
import 'package:the_chef/network/recipe_service.dart';

class VegetarianRecipeListView extends StatefulWidget {
  const VegetarianRecipeListView({Key? key}) : super(key: key);

  @override
  State<VegetarianRecipeListView> createState() =>
      _VegetarianRecipeListViewState();
}

class _VegetarianRecipeListViewState extends State<VegetarianRecipeListView> {
  List<APIHits> recipeList = [];
  int currentCount = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🥦 Vegetarian Recipes',
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontSize: 20)),
          const SizedBox(
            height: 16,
          ),
          _buildRecipeLoader(context),
        ],
      ),
    );
  }

  Widget _buildRecipeLoader(BuildContext context) {
    return FutureBuilder<Response<Result<APIRecipeQuery>>>(
        future: RecipeService.create().queryRecipes(
          "vegetarian",
          0,
          5,
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

            //loading = false;

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

            // inErrorState = false;
            currentCount = query.count;
            // hasMore = query.more;
            recipeList.clear();
            recipeList.addAll(query.hits);

            // if (query.to < currentEndPosition) {
            //   currentEndPosition = query.to;
            // }

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
    return Container(
      height: 250,
      color: Colors.transparent,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return _buildRecipeCard(recipeListContext, hits, index);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 16,
            );
          },
          itemCount: hits.length),
    );
  }

  Widget _buildRecipeCard(
      BuildContext topLevelContext, List<APIHits> hits, int index) {
    final recipe = hits[index].recipe;
    return GestureDetector(
      onTap: () {},
      child: dimRecipeCard(recipe),
    );
  }
}
