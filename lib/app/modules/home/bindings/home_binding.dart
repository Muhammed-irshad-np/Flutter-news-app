import 'package:get/get.dart';
import 'package:news_app/app/data/repositories/news_repository.dart';
import 'package:news_app/app/modules/home/controllers/home_controller.dart';
import '../../../data/providers/api_provider.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register API Provider
    Get.lazyPut<ApiProvider>(
      () => ApiProvider(),
      fenix: true,
    );

    // Register News Repository
    Get.lazyPut<NewsRepository>(
      () => NewsRepository(apiProvider: Get.find<ApiProvider>()),
      fenix: true,
    );

    // Register Home Controller
    Get.lazyPut<HomeController>(
      () => HomeController(newsRepository: Get.find<NewsRepository>()),
    );
  }
}
