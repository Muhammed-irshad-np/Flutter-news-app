import 'package:get/get.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [];
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
