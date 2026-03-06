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
