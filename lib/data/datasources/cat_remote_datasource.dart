import '../services/cat_api_service.dart';
import '../models/cat_image_model.dart';
import '../models/breed_model.dart';

class CatRemoteDataSource {
  final CatApiService apiService;

  CatRemoteDataSource(this.apiService);

  Future<List<CatImageModel>> fetchRandomCatWithBreed() => apiService.getRandomCatWithBreed();

  Future<List<BreedModel>> fetchAllBreeds() => apiService.getAllBreeds();

  Future<List<CatImageModel>> fetchCatsByBreed(String breedId) => apiService.getCatsByBreed(breedId);
}
