import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _currentIndex(double page) => page.round().clamp(0, 2);

  Widget _buildDots(double page) {
    final idx = _currentIndex(page);
    return Row(
      children: List.generate(3, (i) {
        final selected = (idx == i);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: selected ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.white54,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }

  Widget _buildPage({
    required String title,
    required String subtitle,
    required Color color,
    required double offset,
    required IconData icon,
  }) {
    final o = offset.clamp(-1.0, 1.0);

    final t = (1.0 - o.abs()).clamp(0.0, 1.0);

    final dx = o * 150;
    final dy = (1.0 - t) * 12;
    final rotation = -o * 0.35;
    final scale = 0.85 + 0.30 * t;
    final opacity = 0.55 + 0.45 * t;

    final haloScale = 0.9 + 0.25 * t;
    final haloOpacity = 0.10 + 0.18 * t;

    final cat = Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(dx, dy),
        child: Transform.rotate(
          angle: rotation,
          child: Transform.scale(
            scale: scale,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Halo
                Opacity(
                  opacity: haloOpacity,
                  child: Transform.scale(
                    scale: haloScale,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: SizedBox(width: 220, height: 220),
                    ),
                  ),
                ),
                Icon(icon, size: 170, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );

    return Container(
      color: color,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cat,
              const SizedBox(height: 26),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _skipToEnd() async {
    await _controller.animateToPage(
      2,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _nextOrFinish(double page) async {
    final idx = _currentIndex(page);
    if (idx >= 2) {
      widget.onFinish();
      return;
    }
    await _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final page = _controller.hasClients ? (_controller.page ?? 0.0) : 0.0;
          final idx = _currentIndex(page);

          return Stack(
            children: [
              PageView(
                controller: _controller,
                children: [
                  _buildPage(
                    title: 'Свайпай котиков',
                    subtitle: 'Лайк / дислайк — находи своих любимцев',
                    color: Colors.indigo,
                    icon: Icons.pets,
                    offset: page - 0,
                  ),
                  _buildPage(
                    title: 'Детали породы',
                    subtitle: 'Узнавай информацию о породах и фотографиях',
                    color: Colors.deepPurple,
                    icon: Icons.info_outline,
                    offset: page - 1,
                  ),
                  _buildPage(
                    title: 'Список пород',
                    subtitle:
                        'Просматривай все породы в одном месте (вкладка «Породы»)',
                    color: Colors.teal,
                    icon: Icons.list_alt,
                    offset: page - 2,
                  ),
                ],
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 36,
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _skipToEnd,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Пропустить'),
                      ),
                      _buildDots(page),
                      ElevatedButton(
                        onPressed: () => _nextOrFinish(page),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                        ),
                        child: Text(idx >= 2 ? 'Начать' : 'Далее'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
