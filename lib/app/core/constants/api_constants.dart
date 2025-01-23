class ApiConstants {
  static const String baseUrl = 'https://newsapi.org/v2';
  static const String apiKey =
      '5b7ca6ac3bc74ffcae36be5312118240'; // Replace with your API key

  // Endpoints

  // Parameters
  static const String defaultCountry = 'us';
  static const int defaultPageSize = 10;
}

class Endpoints {
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';
}
