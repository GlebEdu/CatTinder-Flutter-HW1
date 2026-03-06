import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cattinder_hw1/presentation/screens/home_screen.dart';
import 'package:cattinder_hw1/presentation/screens/breeds_screen.dart';
import 'package:cattinder_hw1/presentation/screens/onboarding_screen.dart';
import 'package:cattinder_hw1/presentation/screens/auth/auth_screen.dart';
import 'di/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'data/services/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  setupServiceLocator();

  runApp(const MyApp());
}

// Главный виджет приложения
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loading = true;
  bool _showOnboarding = false;
  bool _showAuth = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_seen') ?? false;
    final auth = GetIt.I<AuthService>();
    final signedIn = await auth.isSignedIn();
    setState(() {
      _showOnboarding = !seen;
      _showAuth = seen ? !signedIn : false;
      _loading = false;
    });
  }

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    final auth = GetIt.I<AuthService>();
    final signedIn = await auth.isSignedIn();
    setState(() {
      _showOnboarding = false;
      _showAuth = !signedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Кототиндер',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: _showOnboarding
          ? OnboardingScreen(onFinish: _finishOnboarding)
          : _showAuth
              ? AuthScreen(onAuthenticated: () {
                  setState(() { _showAuth = false; });
                })
              : const MainTabScreen(),
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
