import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news_app/app/core/theme/app_colors.dart';
import 'package:news_app/app/widgets/custom_app_bar.dart';
import '../controllers/home_controller.dart';
import 'widgets/news_card_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                CustomAppBar(
                  showBackButton: true,
                  showSearchButton: true,
                  onBackPressed: () {},
                  onSearchPressed: () {},
                  onSearchQueryChanged: controller.onSearchQueryChanged,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Obx(
                    () => SmartRefresher(
                      controller: refreshController,
                      enablePullDown: true,
                      enablePullUp: controller.hasMore.value,
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
                                      Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'today',
                                              style: theme
                                                  .textTheme.headlineLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 1,
                                                      fontSize: 28),
                                            ),
                                            Text(
                                              'aug 13, friday',
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: AppColors
                                                          .textPrimary),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                ),
                                if (controller.articles.isNotEmpty) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Top Headlines',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            'See all',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  CarouselSlider.builder(
                                    itemCount:
                                        controller.articles.take(5).length,
                                    itemBuilder: (context, index, realIndex) {
                                      final article =
                                          controller.articles[index];
                                      return GestureDetector(
                                        onTap: () => Get.toNamed(
                                            '/article-details',
                                            arguments: article),
                                        child: Container(
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
                                                child: article.urlToImage !=
                                                        null
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
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(height: 4),

                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  article.publishedAt != null
                                                      ? DateFormat(
                                                              'MMM d, yyyy')
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
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'All News',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  ...controller.articles.skip(5).map((article) {
                                    return NewsCardWidget(article: article);
                                  }).toList(),
                                ],
                                if (controller.hasMore.value == false &&
                                    controller.isLoading.value == false) ...[
                                  const Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: const Center(
                                        child:
                                            Text('No more articles to load')),
                                  ),
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
