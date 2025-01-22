import '../models/response_model.dart';
import '../models/article_model.dart';
import '../providers/api_provider.dart';

class NewsRepository {
  final ApiProvider apiProvider;

  NewsRepository({required this.apiProvider});

  Future<List<Article>> getTopHeadlines({
    int page = 1,
    String country = 'us',
  }) async {
    try {
      final response = await apiProvider.getTopHeadlines(
        page: page,
        country: country,
      );

      if (response.status.hasError) {
        throw Exception(response.statusText);
      }

      final newsResponse = NewsResponse.fromJson(response.body);
      return newsResponse.articles;
    } catch (e) {
      throw Exception('Failed to fetch top headlines: $e');
    }
  }

  Future<List<Article>> searchNews({
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await apiProvider.searchNews(
        query: query,
        page: page,
      );

      if (response.status.hasError) {
        throw Exception(response.statusText);
      }

      final newsResponse = NewsResponse.fromJson(response.body);
      return newsResponse.articles;
    } catch (e) {
      throw Exception('Failed to search news: $e');
    }
  }
}
