import 'package:flutter/material.dart';
import 'package:the_chef/api/mock_fooderlick_service.dart';
import 'package:the_chef/components/components.dart';
import 'package:the_chef/components/cuisines_list_view.dart';
import 'package:the_chef/components/vegetarian_recipe_list_view.dart';
import 'package:the_chef/models/explore_data.dart';

class ExploreScreen extends StatelessWidget {
  final mockService = MockFooderlickService();

  ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: mockService.getExploreData(),
        builder: (context, AsyncSnapshot<ExploreData> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView(
              scrollDirection: Axis.vertical,
              children: [
                const SizedBox(
                  height: 2.0,
                ),
                CuisinesListView(),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                  height: 5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                        0.1,
                        0.4,
                        0.7,
                        0.9,
                      ],
                          colors: [
                        Color(0x70616161),
                        Color(0x50616161),
                        Color(0x20616161),
                        Color(0x20616161),
                      ])),
                ),
                const SizedBox(
                  height: 2.0,
                ),
                const VegetarianRecipeListView(),
                const SizedBox(
                  height: 16.0,
                ),
                FriendPostListView(
                    friendPosts: snapshot.data?.friendPosts ?? []),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
