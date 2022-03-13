//import 'package:http/http.dart';

import 'package:chopper/chopper.dart';
import 'package:the_chef/network/model_converter.dart';
import 'package:the_chef/network/model_response.dart';
import 'package:the_chef/network/recipe_model.dart';

part 'recipe_service.chopper.dart';

const String apiKey = '63b51ac7e8137d65249c12896476b838	';
const String apiId = 'a26756e9';
const String apiUrl = 'https://api.edamam.com';

// class RecipeService {
//   Future getData(String url) async {
//     print('Calling url: $url');

//     final response = await get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       return response.body;
//     } else {
//       print(response.statusCode);
//     }
//   }

//   Future<dynamic> getRecipes(String query, int from, int to) async {
//     final recipeData = await getData(
//         '$apiUrl?app_id=$apiId&app_key=$apiKey&q=$query&from=$from&to=$to');
//     return recipeData;
//   }
// }

@ChopperApi()
abstract class RecipeService extends ChopperService {
  @Get(path: 'search')
  Future<Response<Result<APIRecipeQuery>>> queryRecipes(
    @Query('q') String query,
    @Query('from') int from,
    @Query('to') int to,
  );

  static RecipeService create() {
    final client = ChopperClient(
      baseUrl: apiUrl,
      interceptors: [_addQuery, HttpLoggingInterceptor()],
      converter: ModelConverter(),
      errorConverter: const JsonConverter(),
      services: [
        _$RecipeService(),
      ],
    );

    return _$RecipeService(client);
  }
}

Request _addQuery(Request req) {
  final params = Map<String, dynamic>.from(req.parameters);

  params['app_id'] = apiId;
  params['app_key'] = apiKey;

  return req.copyWith(parameters: params);
}
