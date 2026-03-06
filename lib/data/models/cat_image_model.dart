import 'breed_model.dart';
import '../../domain/entities/cat_image.dart';

class CatImageModel {
  final String id;
  final String url;
  final List<BreedModel> breeds;

  CatImageModel({
    required this.id,
    required this.url,
    required this.breeds,
  });

  factory CatImageModel.fromJson(Map<String, dynamic> json) {
    final breedsJson = json['breeds'] as List? ?? [];
    final breeds = breedsJson.map((b) => BreedModel.fromJson(b)).toList();

    return CatImageModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      breeds: breeds,
    );
  }

  CatImage toEntity() {
    return CatImage(
      id: id,
      url: url,
      breeds: breeds.map((b) => b.toEntity()).toList(),
    );
  }
}
