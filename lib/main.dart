import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/breeds_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кототиндер',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainTabScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  MainTabScreenState createState() => MainTabScreenState();
}

class MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;
  int _likesCount = 0;

  void _incrementLikes() {
    setState(() {
      _likesCount++;
    });
  }

  void _handleItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Геттер для списка экранов
  List<Widget> get _screens => [
        HomeScreen(
          likesCount: _likesCount,
          onLike: _incrementLikes,
        ),
        const BreedsScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Породы',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _handleItemTapped,
      ),
    );
  }
}
