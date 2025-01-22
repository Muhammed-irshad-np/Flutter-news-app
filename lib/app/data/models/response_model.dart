import 'article_model.dart';

class NewsResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
        status: json['status'],
        totalResults: json['totalResults'],
        articles: List<Article>.from(
            json['articles'].map((x) => Article.fromJson(x))),
      );
}
