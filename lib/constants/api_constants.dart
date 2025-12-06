class ApiConstants {
  static const String baseUrl = 'https://api.thecatapi.com/v1';
  // Понимаю, что ключ в открытом доступе небезопасно, но оставляю осознанно, чтобы можно было запустить без дополнительных действий
  static const String apiKey =
      'live_czeFCZ96bAVUO8pW99fQhfvo5minkWwiRvx4HOsdaOIknUGY3JMgaavMfi4cavD1';

  static const String searchEndpoint = '/images/search';
  static const String breedsEndpoint = '/breeds';

  static Map<String, String> get headers => {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      };
}
