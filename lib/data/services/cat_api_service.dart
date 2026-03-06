import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';
import '../models/cat_image_model.dart';
import '../models/breed_model.dart';

class CatApiService {
  final http.Client client;

  CatApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<CatImageModel>> getRandomCatWithBreed() async {
    try {
      final response = await client.get(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.searchEndpoint}?has_breeds=1'),
        headers: ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CatImageModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cat image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<BreedModel>> getAllBreeds() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.breedsEndpoint}'),
        headers: ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => BreedModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load breeds: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<CatImageModel>> getCatsByBreed(String breedId) async {
    try {
      final response = await client.get(
        Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.searchEndpoint}?breed_ids=$breedId&limit=1'),
        headers: ApiConstants.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CatImageModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load cats for breed $breedId');
      }
    } catch (e) {
      throw Exception('Error loading cats: $e');
    }
  }
}
