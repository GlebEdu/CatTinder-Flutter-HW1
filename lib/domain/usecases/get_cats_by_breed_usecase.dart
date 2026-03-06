import '../repositories/cat_repository.dart';
import '../entities/cat_image.dart';

class GetCatsByBreedUseCase {
  final CatRepository repository;

  GetCatsByBreedUseCase(this.repository);

  Future<List<CatImage>> call(String breedId) async {
    return repository.getCatsByBreed(breedId);
  }
}
