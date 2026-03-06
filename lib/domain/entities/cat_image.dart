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

  @override
  List<Object?> get props => [id, url, breeds];
}
