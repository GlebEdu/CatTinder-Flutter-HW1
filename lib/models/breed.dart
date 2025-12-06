import 'package:equatable/equatable.dart';

class Breed extends Equatable {
  final String id;
  final String name;
  final String description;
  final String temperament;
  final String origin;
  final String lifeSpan;
  final int? adaptability;
  final int? intelligence;

  const Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.temperament,
    required this.origin,
    required this.lifeSpan,
    this.adaptability,
    this.intelligence,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
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

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        temperament,
        origin,
        lifeSpan,
        adaptability,
        intelligence,
      ];
}
