import 'package:flutter/material.dart';
import 'package:cattinder_hw1/domain/entities/breed.dart';
import 'package:cattinder_hw1/presentation/widgets/error_dialog.dart';
import 'package:cattinder_hw1/presentation/screens/detail_screen.dart';
import 'package:cattinder_hw1/domain/entities/cat_image.dart';
import 'package:get_it/get_it.dart';
import 'package:cattinder_hw1/domain/usecases/get_all_breeds_usecase.dart';
import 'package:cattinder_hw1/domain/usecases/get_cats_by_breed_usecase.dart';

class BreedsScreen extends StatefulWidget {
  const BreedsScreen({super.key});

  @override
  BreedsScreenState createState() => BreedsScreenState();
}

class BreedsScreenState extends State<BreedsScreen> {
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
      final usecase = GetIt.I<GetAllBreedsUseCase>();
      final breeds = await usecase.call();
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
          _error ?? 'Ошибка',
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
      final getByBreed = GetIt.I<GetCatsByBreedUseCase>();
      final catImages = await getByBreed.call(breed.id);

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
                  ? Center(child: Text(_error ?? 'Ошибка'))
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
