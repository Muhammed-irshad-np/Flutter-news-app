import 'package:get/get.dart';
import 'package:news_app/app/core/constants/api_constants.dart';

class ApiProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;

    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer ${ApiConstants.apiKey}';
      return request;
    });

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
      Endpoints.topHeadlines,
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
      Endpoints.everything,
      query: {
        'q': query,
        'page': page.toString(),
        'pageSize': ApiConstants.defaultPageSize.toString(),
      },
    );
  }
}
