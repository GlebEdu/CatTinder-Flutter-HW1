import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'secure_storage.dart';

class AuthService {
  final SecureStorage _storage;

  AuthService({SecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorageAdapter();

  static const _keyUsername = 'auth_username';
  static const _keyPasswordHash = 'auth_password_hash';
  static const _keySignedIn = 'auth_signed_in';

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> signUp(String username, String password) async {
    final existing = await _storage.read(key: _keyUsername);
    if (existing != null) {
      return false;
    }

    final hash = _hashPassword(password);
    await _storage.write(key: _keyUsername, value: username);
    await _storage.write(key: _keyPasswordHash, value: hash);
    await _storage.write(key: _keySignedIn, value: 'true');
    return true;
  }

  Future<bool> login(String username, String password) async {
    final storedUser = await _storage.read(key: _keyUsername);
    final storedHash = await _storage.read(key: _keyPasswordHash);
    if (storedUser == null || storedHash == null) return false;

    if (storedUser != username) return false;
    final hash = _hashPassword(password);
    if (hash != storedHash) return false;
    await _storage.write(key: _keySignedIn, value: 'true');
    return true;
  }

  Future<void> signOut() async {
    await _storage.write(key: _keySignedIn, value: 'false');
  }

  Future<bool> isSignedIn() async {
    final v = await _storage.read(key: _keySignedIn);
    return v == 'true';
  }

  Future<String?> getUsername() async => _storage.read(key: _keyUsername);
}
