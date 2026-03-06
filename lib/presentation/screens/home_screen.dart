import 'package:flutter/material.dart';
import 'package:cattinder_hw1/domain/entities/cat_image.dart';
import 'package:cattinder_hw1/presentation/widgets/cat_card.dart';
import 'package:cattinder_hw1/presentation/widgets/error_dialog.dart';
import 'package:cattinder_hw1/presentation/screens/detail_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:cattinder_hw1/domain/usecases/get_random_cat_usecase.dart';
import 'package:flutter/services.dart';
import 'package:cattinder_hw1/data/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final int likesCount;
  final VoidCallback onLike;

  const HomeScreen({
    super.key,
    required this.likesCount,
    required this.onLike,
  });

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  CatImage? _currentCat;
  bool _isLoading = false;
  String? _error;
  

  // Для свайпа
  double _positionX = 0.0;
  double _positionY = 0.0;
  double _angle = 0.0;
  bool _isDragging = false;
  DateTime? _dragStartTime;

  @override
  void initState() {
    super.initState();
    _loadRandomCat();
  }

  Future<void> _loadRandomCat() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _resetCard();
    });

    try {
      final usecase = GetIt.I<GetRandomCatUseCase>();
      final cats = await usecase.call();
      if (cats.isNotEmpty) {
        setState(() {
          _currentCat = cats.first;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Не удалось загрузить котика';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      if (mounted) {
        ErrorDialog.show(
          context,
          _error ?? 'Ошибка загрузки',
          _loadRandomCat,
        );
      }
    }
  }

  void _openDetailScreen() {
    final current = _currentCat;
    if (current != null && current.breeds.isNotEmpty) {
      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailScreen(
            catImage: current,
            breed: current.breeds.first,
          ),
        ),
      );
    }
  }

  void _resetCard() {
    _positionX = 0.0;
    _positionY = 0.0;
    _angle = 0.0;
    _isDragging = false;
  }

  void _swipeRight() {
    // Лайк
    widget.onLike();
    _animateCardOut(true);
    Future.delayed(const Duration(milliseconds: 300), _loadRandomCat);
  }

  void _swipeLeft() {
    // Дизлайк
    _animateCardOut(false);
    Future.delayed(const Duration(milliseconds: 300), _loadRandomCat);
  }

  void _animateCardOut(bool isRight) {
    _positionX = isRight ? 500.0 : -500.0;
    _angle = isRight ? 0.5 : -0.5;
    if (mounted) {
      setState(() {});
    }
  }

  void _handlePanStart(DragStartDetails details) {
    _dragStartTime = DateTime.now();
    _isDragging = true;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    _positionX += details.delta.dx;
    _positionY += details.delta.dy;
    _angle = _positionX * 0.01;

    if (mounted) {
      setState(() {});
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!_isDragging) return;

    final start = _dragStartTime;
    if (start == null) {
      _resetCard();
      if (mounted) setState(() {});
      return;
    }

    final dragDuration = DateTime.now().difference(start);
    const minSwipeDuration = Duration(milliseconds: 100);
    const swipeThreshold = 100.0;

    // Проверяем, был ли это быстрый тап (менее 100 мс и небольшое смещение)
    if (dragDuration < minSwipeDuration && _positionX.abs() < 20) {
      // Это был тап - открываем детальный экран
      _resetCard();
      if (mounted) {
        setState(() {});
      }
      _openDetailScreen();
      return;
    }

    // Если это был свайп
    _isDragging = false;

    if (_positionX.abs() > swipeThreshold) {
      if (_positionX > 0) {
        _swipeRight();
      } else {
        _swipeLeft();
      }
    } else {
      _resetCard();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кототиндер'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final auth = GetIt.I.get<AuthService>();
              await auth.signOut();
              if (!mounted) return;
              SystemNavigator.pop();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 8),
                Text('${widget.likesCount}'),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading && _currentCat == null
          ? const Center(child: CircularProgressIndicator())
          : _currentCat == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Нет данных о котиках'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadRandomCat,
                        child: const Text('Загрузить котика'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          // Карточка
                          Center(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onPanStart: _handlePanStart,
                              onPanUpdate: _handlePanUpdate,
                              onPanEnd: _handlePanEnd,
                              child: Transform.translate(
                                                offset: Offset(_positionX, _positionY),
                                                child: Transform.rotate(
                                                  angle: _angle,
                                                  child: Builder(builder: (context) {
                                                    final current = _currentCat;
                                                    final imageUrl = current?.url ?? '';
                                                    final breedName = (current != null && current.breeds.isNotEmpty)
                                                      ? current.breeds.first.name
                                                      : 'Неизвестная порода';
                                                    return CatCard(
                                                      imageUrl: imageUrl,
                                                      breedName: breedName,
                                                    );
                                                  }),
                                                ),
                                              ),
                            ),
                          ),

                          // Индикаторы направления при свайпе
                          if (_isDragging)
                            Positioned.fill(
                              child: Row(
                                children: [
                                  // Красный индикатор
                                  Expanded(
                                    child: AnimatedOpacity(
                                      opacity: _positionX < -50 ? 1.0 : 0.3,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Container(
                                        color: const Color(0x10F44336),
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.close,
                                                size: 60,
                                                color: Color(0xFFF44336),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'ДИЗЛАЙК',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFFF44336),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // зеленый индикатор
                                  Expanded(
                                    child: AnimatedOpacity(
                                      opacity: _positionX > 50 ? 1.0 : 0.3,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      child: Container(
                                        color: const Color(0x104CAF50),
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.favorite,
                                                size: 60,
                                                color: Color(0xFF4CAF50),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                'ЛАЙК',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF4CAF50),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Кнопки
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Кнопка дизлайк
                          FloatingActionButton(
                            onPressed: _swipeLeft,
                            backgroundColor: const Color(0xFFF44336),
                            elevation: 10,
                            heroTag: 'dislike_button',
                            child: const Icon(
                              Icons.close,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),

                          // Кнопка лайк
                          FloatingActionButton(
                            onPressed: _swipeRight,
                            backgroundColor: const Color(0xFF4CAF50),
                            elevation: 10,
                            heroTag: 'like_button',
                            child: const Icon(
                              Icons.favorite,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Индикатор загрузки
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
    );
  }
}
