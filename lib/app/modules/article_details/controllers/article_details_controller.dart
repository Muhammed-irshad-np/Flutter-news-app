import 'package:get/get.dart';
import '../../../data/models/article_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsController extends GetxController {
  final article = Rx<Article?>(null);

  @override
  void onInit() {
    super.onInit();
    article.value = Get.arguments as Article;
  }
}
