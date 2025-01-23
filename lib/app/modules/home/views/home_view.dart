import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news_app/app/widgets/custom_app_bar.dart';
import '../controllers/home_controller.dart';
import 'widgets/news_card_widget.dart';
import 'widgets/search_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RefreshController refreshController = RefreshController();

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF2D3B48),
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                CustomAppBar(
                  showBackButton: true,
                  showSearchButton: true,
                  onBackPressed: () {
                    // Handle back press
                  },
                  onSearchPressed: () {
                    // Handle search press
                  },
                  onSearchQueryChanged: controller.onSearchQueryChanged,
                ),

                // Today's Date
                Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                  ),
                  child: Row(
                    children: [
                      // Line with dot
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Container(
                              height: 2,
                              color: Colors.black,
                            ),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Today text and date
                      const Align(
                        alignment: Alignment.center,
                        child: Column(
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
                      ),
                      // Add space to center the text
                      Expanded(child: SizedBox()),
                    ],
                  ),
                ),

                // Top Headlines Carousel
                Obx(() {
                  if (controller.isLoading.value &&
                      controller.articles.isEmpty) {
                    return const SizedBox(
                      height: 250,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final topHeadlines = controller.articles.take(5).toList();

                  return Column(
                    children: [
                      // Top Headlines Title
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

                      // Carousel Slider
                      CarouselSlider.builder(
                        itemCount: topHeadlines.length,
                        itemBuilder: (context, index, realIndex) {
                          final article = topHeadlines[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Stack(
                              children: [
                                // Article Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: article.urlToImage != null
                                      ? CachedNetworkImage(
                                          imageUrl: article.urlToImage!,
                                          height: 200,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                                      : Container(
                                          height: 200,
                                          color: Colors.grey[300],
                                        ),
                                ),
                                // Gradient Overlay
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Article Title
                                Positioned(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  child: Text(
                                    article.title ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 200,
                          viewportFraction: 0.9,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 16),

                // All News Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All News',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
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
                      child: controller.isLoading.value &&
                              controller.articles.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: controller.articles.length,
                              itemBuilder: (context, index) {
                                // Skip the first 5 articles as they're shown in the carousel
                                if (index < 5) return const SizedBox.shrink();
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
        ));
  }
}
