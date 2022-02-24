import 'package:flutter/material.dart';
import 'package:the_chef/api/mock_fooderlick_service.dart';
import 'package:the_chef/components/components.dart';
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
                TodayRecipeListView(recipes: snapshot.data?.todayRecipes ?? []),
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
