import '../entities/cat_image.dart';
import '../entities/breed.dart';

abstract class CatRepository {
  Future<List<CatImage>> getRandomCatWithBreed();
  Future<List<Breed>> getAllBreeds();
  Future<List<CatImage>> getCatsByBreed(String breedId);
}
