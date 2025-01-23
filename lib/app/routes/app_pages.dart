import 'package:get/get.dart';
import 'package:news_app/app/modules/article_details/bindings/article_details_binding.dart';
import 'package:news_app/app/modules/article_details/views/article_details_view.dart';
import 'package:news_app/app/modules/home/bindings/home_binding.dart';
import 'package:news_app/app/modules/home/views/home_view.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLE_DETAILS,
      page: () => const ArticleDetailsView(),
      binding: ArticleDetailsBinding(),
    ),
  ];
}

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const ARTICLE_DETAILS = _Paths.ARTICLE_DETAILS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/';
  static const ARTICLE_DETAILS = '/article-details';
}
