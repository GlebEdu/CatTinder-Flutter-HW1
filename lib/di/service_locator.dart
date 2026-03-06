import 'package:get_it/get_it.dart';

import '../data/services/cat_api_service.dart';
import '../data/datasources/cat_remote_datasource.dart';
import '../data/repositories/cat_repository_impl.dart';
import '../domain/repositories/cat_repository.dart';
import '../domain/usecases/get_random_cat_usecase.dart';
import '../domain/usecases/get_all_breeds_usecase.dart';
import '../domain/usecases/get_cats_by_breed_usecase.dart';
import '../data/services/auth_service.dart';

final GetIt locator = GetIt.instance;

void setupServiceLocator() {
  locator.registerLazySingleton<CatApiService>(() => CatApiService());
  
  locator.registerLazySingleton<AuthService>(() => AuthService());

  locator.registerLazySingleton<CatRemoteDataSource>(
      () => CatRemoteDataSource(locator<CatApiService>()));

  locator.registerLazySingleton<CatRepository>(
      () => CatRepositoryImpl(locator<CatRemoteDataSource>()));

  locator.registerFactory(() => GetRandomCatUseCase(locator<CatRepository>()));
  locator.registerFactory(() => GetAllBreedsUseCase(locator<CatRepository>()));
  locator.registerFactory(() => GetCatsByBreedUseCase(locator<CatRepository>()));
}
