import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:cattinder_hw1/presentation/screens/auth/login_screen.dart';
import 'package:cattinder_hw1/data/services/auth_service.dart';
import 'package:cattinder_hw1/data/services/secure_storage.dart';

class InMemoryStorage implements SecureStorage {
  final Map<String, String> _map = {};
  @override
  Future<String?> read({required String key}) async => _map[key];
  @override
  Future<void> write({required String key, required String value}) async {
    _map[key] = value;
  }
}

class TestAuthService extends AuthService {
  final bool willSucceed;
  TestAuthService({this.willSucceed = true}) : super(storage: InMemoryStorage());

  @override
  Future<bool> login(String username, String password) async => willSucceed;
  @override
  Future<bool> signUp(String username, String password) async => false;
  @override
  Future<void> signOut() async {}
  @override
  Future<bool> isSignedIn() async => false;
  @override
  Future<String?> getUsername() async => null;
}

void main() {
  setUp(() {
    GetIt.I.reset();
  });

  testWidgets('LoginScreen shows validation error for empty fields', (tester) async {
    GetIt.I.registerLazySingleton<AuthService>(() => TestAuthService(willSucceed: false));

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Войти'));
    await tester.pumpAndSettle();

    expect(find.text('Введите имя пользователя'), findsOneWidget);
    expect(find.text('Пароль минимум 6 символов'), findsOneWidget);
  });

  testWidgets('LoginScreen successful login pops route', (tester) async {
    GetIt.I.registerLazySingleton<AuthService>(() => TestAuthService(willSucceed: true));

    await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) {
      return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
        },
        child: const Text('open'),
      );
    })));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'user');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Войти'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsNothing);
  });
}
