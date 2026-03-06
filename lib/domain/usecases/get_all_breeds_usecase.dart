import '../repositories/cat_repository.dart';
import '../entities/breed.dart';

class GetAllBreedsUseCase {
  final CatRepository repository;

  GetAllBreedsUseCase(this.repository);

  Future<List<Breed>> call() async {
    return repository.getAllBreeds();
  }
}
