import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_chef/models/fooderlich_pages.dart';
import 'package:the_chef/network/recipe_model.dart';

class RecipeDetail extends StatefulWidget {
  final APIRecipe recipe;

  static MaterialPage page({required APIRecipe recipe}) {
    return MaterialPage(
        name: FooderlichPages.recipeItemDetails,
        key: ValueKey(FooderlichPages.recipeItemDetails),
        child: RecipeDetail(
          recipe: recipe,
        ));
  }

  const RecipeDetail({Key? key, required this.recipe}) : super(key: key);

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  int _sliderVal = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.label),
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          SizedBox(
              height: 300,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: widget.recipe.image,
                fit: BoxFit.cover,
              )),
          const SizedBox(
            height: 4,
          ),
          Text(
            widget.recipe.label,
            style: const TextStyle(fontSize: 18),
          ),
          Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(7.0),
                  itemCount: widget.recipe.ingredients.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ingredient = widget.recipe.ingredients[index];
                    return Text('${ingredient.name} ${ingredient.weight}');
                  })),
          Slider(
            min: 1,
            max: 10,
            divisions: 10,
            label: '${_sliderVal * widget.recipe.calories} servings',
            value: _sliderVal.toDouble(),
            onChanged: (newValue) {
              setState(() {
                _sliderVal = newValue.round();
              });
            },
            activeColor: Colors.green,
            inactiveColor: Colors.black,
          ),
        ],
      )),
    );
  }
}
