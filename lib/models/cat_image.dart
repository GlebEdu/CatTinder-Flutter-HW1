import 'package:equatable/equatable.dart';
import 'breed.dart';

class CatImage extends Equatable {
  final String id;
  final String url;
  final List<Breed> breeds;

  const CatImage({
    required this.id,
    required this.url,
    required this.breeds,
  });

  factory CatImage.fromJson(Map<String, dynamic> json) {
    final breedsJson = json['breeds'] as List? ?? [];
    final breeds = breedsJson.map((b) => Breed.fromJson(b)).toList();

    return CatImage(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      breeds: breeds,
    );
  }

  @override
  List<Object?> get props => [id, url, breeds];
}
