import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'widgets/news_card_widget.dart';
import 'widgets/search_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RefreshController refreshController = RefreshController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {},
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Today's Date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 2,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'today',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'aug 13, friday',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchWidget(
                onChanged: controller.onSearchQueryChanged,
              ),
            ),

            // Top Headlines Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Headlines',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See all'),
                  ),
                ],
              ),
            ),

            // News List
            Expanded(
              child: Obx(
                () => SmartRefresher(
                  controller: refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: () async {
                    await controller.refreshNews();
                    refreshController.refreshCompleted();
                  },
                  onLoading: () async {
                    if (controller.isSearching.value) {
                      await controller.searchNews();
                    } else {
                      await controller.fetchTopHeadlines();
                    }
                    refreshController.loadComplete();
                  },
                  child:
                      controller.isLoading.value && controller.articles.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: controller.articles.length,
                              itemBuilder: (context, index) {
                                final article = controller.articles[index];
                                return NewsCardWidget(article: article);
                              },
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
