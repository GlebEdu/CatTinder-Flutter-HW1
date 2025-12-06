import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cat_image.dart';
import '../models/breed.dart';

class DetailScreen extends StatelessWidget {
  final CatImage catImage;
  final Breed breed;

  const DetailScreen({
    super.key,
    required this.catImage,
    required this.breed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breed.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Изображение котика
            Container(
              height: 300,
              color: Colors.grey[200],
              child: catImage.url.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: catImage.url,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => _buildErrorWidget(),
                    )
                  : _buildErrorWidget(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (breed.description.isNotEmpty)
                    Text(
                      breed.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 16),
                  if (breed.temperament.isNotEmpty)
                    _buildInfoCard('Характер', breed.temperament),
                  const SizedBox(height: 8),
                  if (breed.origin.isNotEmpty)
                    _buildInfoCard('Происхождение', breed.origin),
                  const SizedBox(height: 8),
                  if (breed.lifeSpan.isNotEmpty)
                    _buildInfoCard('Продолжительность жизни', breed.lifeSpan),
                  const SizedBox(height: 8),
                  if (breed.adaptability != null)
                    _buildRatingBar('Адаптивность', breed.adaptability!),
                  const SizedBox(height: 8),
                  if (breed.intelligence != null)
                    _buildRatingBar('Интеллект', breed.intelligence!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(value),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(String title, int value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  color: index < value ? Colors.amber : Colors.grey,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      height: 300,
      color: Colors.grey[200],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Изображение недоступно',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
