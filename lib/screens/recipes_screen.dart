import 'package:flutter/material.dart';
import 'package:the_chef/api/mock_fooderlick_service.dart';
import 'package:the_chef/components/components.dart';

import '../models/models.dart';

class RecipesScreen extends StatelessWidget {
  final exploreService = MockFooderlickService();

  RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchCard(),
        Expanded(
          child: FutureBuilder(
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
          ),
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
                // startSearch(searchTextController.text);

                // final currentFocus = FocusScope.of(context);
                // if (!currentFocus.hasPrimaryFocus) {
                //   currentFocus.unfocus();
                // }
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
                    // if (!previousSearches.contains(value)) {
                    //   previousSearches.add(value);
                    //   savePreviousSearches();
                    // }
                  },
                  //controller: searchTextController,
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
}
