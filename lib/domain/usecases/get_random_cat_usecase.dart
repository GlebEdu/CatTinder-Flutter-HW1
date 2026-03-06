import '../repositories/cat_repository.dart';
import '../entities/cat_image.dart';

class GetRandomCatUseCase {
  final CatRepository repository;

  GetRandomCatUseCase(this.repository);

  Future<List<CatImage>> call() async {
    return repository.getRandomCatWithBreed();
  }
}
