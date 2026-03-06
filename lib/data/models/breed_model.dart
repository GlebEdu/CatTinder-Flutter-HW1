import '../../domain/entities/breed.dart';

class BreedModel {
  final String id;
  final String name;
  final String description;
  final String temperament;
  final String origin;
  final String lifeSpan;
  final int? adaptability;
  final int? intelligence;

  BreedModel({
    required this.id,
    required this.name,
    required this.description,
    required this.temperament,
    required this.origin,
    required this.lifeSpan,
    this.adaptability,
    this.intelligence,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      temperament: json['temperament'] ?? '',
      origin: json['origin'] ?? '',
      lifeSpan: json['life_span'] ?? '',
      adaptability: (json['adaptability'] as num?)?.toInt(),
      intelligence: (json['intelligence'] as num?)?.toInt(),
    );
  }

  Breed toEntity() {
    return Breed(
      id: id,
      name: name,
      description: description,
      temperament: temperament,
      origin: origin,
      lifeSpan: lifeSpan,
      adaptability: adaptability,
      intelligence: intelligence,
    );
  }
}
