import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.thecatapi.com/v1';
  static String get apiKey => dotenv.env['CAT_API_KEY'] ?? '';

  static const String searchEndpoint = '/images/search';
  static const String breedsEndpoint = '/breeds';

  static Map<String, String> get headers {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (apiKey.isNotEmpty) headers['x-api-key'] = apiKey;
    return headers;
  }
}
