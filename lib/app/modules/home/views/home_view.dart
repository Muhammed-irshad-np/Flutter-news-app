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
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                _buildAppBar(),
                const SizedBox(height: 20),
                Expanded(
                  child: _buildNewsList(context, refreshController),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      showBackButton: true,
      showSearchButton: true,
      onBackPressed: () {},
      onSearchPressed: () {},
      onSearchQueryChanged: controller.onSearchQueryChanged,
    );
  }

  Widget _buildNewsList(
      BuildContext context, RefreshController refreshController) {
    return Obx(
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
        child: controller.isLoading.value && controller.articles.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : _buildNewsListContent(context),
      ),
    );
  }

  Widget _buildNewsListContent(BuildContext context) {
    return ListView(
      children: [
        _buildDateHeader(context),
        if (controller.articles.isNotEmpty) ...[
          _buildTopHeadlinesSection(context),
          const SizedBox(height: 12),
          _buildCarouselSlider(),
          const SizedBox(height: 20),
          _buildAllNewsSection(context),
          const SizedBox(height: 14),
          ..._buildNewsCards(),
        ],
        if (controller.hasMore.value == false &&
            controller.isLoading.value == false)
          _buildNoMoreArticlesMessage(),
      ],
    );
  }

  Widget _buildDateHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(right: 18.w),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(height: 2.h, color: Colors.black),
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 40.w),
          _buildDateText(theme),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildDateText(ThemeData theme) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'today',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              fontSize: 28.sp,
            ),
          ),
          Text(
            'aug 13, friday',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeadlinesSection(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Top Headlines',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'See all',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return CarouselSlider.builder(
      itemCount: controller.articles.take(5).length,
      itemBuilder: (context, index, realIndex) =>
          _buildCarouselItem(controller.articles[index]),
      options: CarouselOptions(
        height: 280.h,
        viewportFraction: 0.9,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
      ),
    );
  }

  Widget _buildCarouselItem(dynamic article) {
    return GestureDetector(
      onTap: () => Get.toNamed('/article-details', arguments: article),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildArticleImage(article),
            const SizedBox(height: 8),
            _buildArticleTitle(article),
            const SizedBox(height: 4),
            _buildArticleDate(article),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleImage(dynamic article) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: article.urlToImage != null
          ? CachedNetworkImage(
              imageUrl: article.urlToImage!,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : Container(
              height: 200.h,
              color: Colors.grey[300],
            ),
    );
  }

  Widget _buildArticleTitle(dynamic article) {
    return Expanded(
      child: Text(
        article.title ?? '',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildArticleDate(dynamic article) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        article.publishedAt != null
            ? DateFormat('MMM d, yyyy').format(article.publishedAt!)
            : '',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildAllNewsSection(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All News',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNewsCards() {
    return controller.articles.skip(5).map((article) {
      return NewsCardWidget(article: article);
    }).toList();
  }

  Widget _buildNoMoreArticlesMessage() {
    return const Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: const Center(child: Text('No more articles to load')),
    );
  }
}
