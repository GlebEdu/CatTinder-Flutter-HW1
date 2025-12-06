import 'package:flutter/material.dart';
import '../services/cat_api_service.dart';
import '../models/breed.dart';
import '../widgets/error_dialog.dart';
import '../screens/detail_screen.dart';
import '../models/cat_image.dart';

class BreedsScreen extends StatefulWidget {
  const BreedsScreen({super.key});

  @override
  BreedsScreenState createState() => BreedsScreenState();
}

class BreedsScreenState extends State<BreedsScreen> {
  final CatApiService _apiService = CatApiService();
  List<Breed> _breeds = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBreeds();
  }

  Future<void> _loadBreeds() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final breeds = await _apiService.getAllBreeds();
      if (!mounted) return;

      setState(() {
        _breeds = breeds;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });

      if (mounted) {
        ErrorDialog.show(
          context,
          _error!,
          _loadBreeds,
        );
      }
    }
  }

  Future<void> _openBreedDetail(Breed breed) async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Получаем изображения для этой породы
      final catImages = await _apiService.getCatsByBreed(breed.id);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (catImages.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              catImage: catImages.first,
              breed: breed,
            ),
          ),
        );
      } else {
        // Если нет изображений, показываем placeholder
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              catImage: CatImage(
                id: 'placeholder',
                url: '', // Пустая ссылка
                breeds: [breed],
              ),
              breed: breed,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // В случае ошибки показываем DetailScreen с placeholder
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(
            catImage: CatImage(
              id: 'placeholder',
              url: '',
              breeds: [breed],
            ),
            breed: breed,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Породы кошек'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView.builder(
                  itemCount: _breeds.length,
                  itemBuilder: (context, index) {
                    final breed = _breeds[index];
                    return ListTile(
                      title: Text(breed.name),
                      subtitle: Text(
                        breed.description.length > 100
                            ? '${breed.description.substring(0, 100)}...'
                            : breed.description,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openBreedDetail(breed),
                    );
                  },
                ),
    );
  }
}
