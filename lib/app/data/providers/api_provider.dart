import 'package:get/get.dart';
import 'package:news_app/app/core/constants/api_constants.dart';

class ApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;

    // Add default headers
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer ${ApiConstants.apiKey}';
      return request;
    });

    // Add response modifier for error handling
    httpClient.addResponseModifier((request, response) {
      return response;
    });

    super.onInit();
  }

  Future<Response> getTopHeadlines({
    int page = 1,
    String country = ApiConstants.defaultCountry,
  }) async {
    return get(
      ApiConstants.topHeadlines,
      query: {
        'country': country,
        'page': page.toString(),
        'pageSize': ApiConstants.defaultPageSize.toString(),
      },
    );
  }

  Future<Response> searchNews({
    required String query,
    int page = 1,
  }) async {
    return get(
      ApiConstants.everything,
      query: {
        'q': query,
        'page': page.toString(),
        'pageSize': ApiConstants.defaultPageSize.toString(),
      },
    );
  }
}
