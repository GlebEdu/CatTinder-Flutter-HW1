import '../../domain/repositories/cat_repository.dart';
import '../../domain/entities/cat_image.dart';
import '../../domain/entities/breed.dart';
import '../datasources/cat_remote_datasource.dart';

class CatRepositoryImpl implements CatRepository {
  final CatRemoteDataSource remoteDataSource;

  CatRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CatImage>> getRandomCatWithBreed() async {
    final models = await remoteDataSource.fetchRandomCatWithBreed();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<Breed>> getAllBreeds() async {
    final models = await remoteDataSource.fetchAllBreeds();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<CatImage>> getCatsByBreed(String breedId) async {
    final models = await remoteDataSource.fetchCatsByBreed(breedId);
    return models.map((m) => m.toEntity()).toList();
  }
}
