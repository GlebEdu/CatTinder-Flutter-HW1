import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorage {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
}

class FlutterSecureStorageAdapter implements SecureStorage {
  final FlutterSecureStorage _impl;
  const FlutterSecureStorageAdapter([FlutterSecureStorage? impl]) : _impl = impl ?? const FlutterSecureStorage();

  @override
  Future<String?> read({required String key}) => _impl.read(key: key);

  @override
  Future<void> write({required String key, required String value}) => _impl.write(key: key, value: value);
}
