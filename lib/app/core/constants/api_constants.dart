class ApiConstants {
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey =
      '0789daaf7d414222807757914e66f2f5'; // Replace with your API key

  // Endpoints

  // Parameters
  static const String defaultCountry = 'us';
  static const int defaultPageSize = 10;
}

class Endpoints {
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';
}
