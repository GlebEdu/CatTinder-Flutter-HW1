import 'package:flutter_test/flutter_test.dart';
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

void main() {
  group('AuthService (unit)', () {
    test('signUp stores credentials and signs in', () async {
      final storage = InMemoryStorage();
      final auth = AuthService(storage: storage);

      final ok = await auth.signUp('alice', 'password123');
      expect(ok, isTrue);

      final username = await storage.read(key: 'auth_username');
      final signedIn = await storage.read(key: 'auth_signed_in');
      expect(username, 'alice');
      expect(signedIn, 'true');
    });

    test('signUp fails when user exists, login success/failure', () async {
      final storage = InMemoryStorage();
      final auth = AuthService(storage: storage);

      final ok1 = await auth.signUp('bob', 'secret1');
      expect(ok1, isTrue);

      final ok2 = await auth.signUp('bob', 'secret2');
      expect(ok2, isFalse);

      final loginFail = await auth.login('bob', 'wrong');
      expect(loginFail, isFalse);

      final loginOk = await auth.login('bob', 'secret1');
      expect(loginOk, isTrue);
    });
  });
}
