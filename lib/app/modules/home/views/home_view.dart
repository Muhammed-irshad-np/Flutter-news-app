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
import 'package:intl/intl.dart';

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

                // Scrollable content
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
                          : ListView(
                              children: [
                                // Today's Date
                                Padding(
                                  padding: const EdgeInsets.only(right: 18),
                                  child: Row(
                                    children: [
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
                                      const Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                      const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ),

                                // Top Headlines Section
                                if (controller.articles.isNotEmpty) ...[
                                  // Top Headlines Title
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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

                                  // Carousel remains horizontal
                                  CarouselSlider.builder(
                                    itemCount:
                                        controller.articles.take(5).length,
                                    itemBuilder: (context, index, realIndex) {
                                      final article =
                                          controller.articles[index];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Article Image
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: article.urlToImage != null
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          article.urlToImage!,
                                                      height: 200,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    )
                                                  : Container(
                                                      height: 200,
                                                      color: Colors.grey[300],
                                                    ),
                                            ),

                                            const SizedBox(height: 8),

                                            // Article Title (without maxLines constraint)
                                            Expanded(
                                              child: Text(
                                                article.title ?? '',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 4),

                                            // Article Date (Right aligned)
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                article.publishedAt != null
                                                    ? DateFormat('MMM d, yyyy')
                                                        .format(article
                                                            .publishedAt!)
                                                    : '',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    options: CarouselOptions(
                                      height: 280,
                                      viewportFraction: 0.9,
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: true,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 5),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // All News Title
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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

                                  // All News List Items
                                  ...controller.articles.skip(5).map((article) {
                                    return NewsCardWidget(article: article);
                                  }).toList(),
                                ],
                              ],
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
