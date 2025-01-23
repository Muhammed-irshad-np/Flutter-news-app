import 'package:get/get.dart';
import '../../../data/models/article_model.dart';
import '../../../data/repositories/news_repository.dart';

class HomeController extends GetxController {
  final NewsRepository newsRepository;

  HomeController({required this.newsRepository});

  
  final RxList<Article> articles = <Article>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopHeadlines();
  }

  Future<void> fetchTopHeadlines({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      articles.clear();
      hasMore.value = true;
    }

    if (isLoading.value || !hasMore.value) return;

    try {
      isLoading.value = true;

      final newArticles = await newsRepository.getTopHeadlines(
        page: currentPage.value,
      );

      if (newArticles.isEmpty) {
        hasMore.value = false;
      } else {
        articles.addAll(newArticles);
        currentPage.value++;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchNews({bool refresh = false}) async {
    if (searchQuery.value.isEmpty) return;

    if (refresh) {
      currentPage.value = 1;
      articles.clear();
      hasMore.value = true;
    }

    if (isLoading.value || !hasMore.value) return;

    try {
      isLoading.value = true;
      final searchResults = await newsRepository.searchNews(
        query: searchQuery.value,
        page: currentPage.value,
      );

      if (searchResults.isEmpty) {
        hasMore.value = false;
      } else {
        articles.addAll(searchResults);
        currentPage.value++;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchQueryChanged(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      isSearching.value = false;
      fetchTopHeadlines(refresh: true);
    } else {
      isSearching.value = true;
      searchNews(refresh: true);
    }
  }

  Future<void> refreshNews() async {
    if (isSearching.value) {
      await searchNews(refresh: true);
    } else {
      await fetchTopHeadlines(refresh: true);
    }
  }
}
