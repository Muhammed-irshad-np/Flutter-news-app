import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/article_details_controller.dart';
import 'package:news_app/app/widgets/custom_app_bar.dart';

class ArticleDetailsView extends GetView<ArticleDetailsController> {
  const ArticleDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF2D3B48),
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Obx(() {
          final article = controller.article.value;
          if (article == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildArticleImage(article),
                        _buildArticleContent(context, article),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      showBackButton: true,
      showSearchButton: false,
      onBackPressed: () => Get.back(),
    );
  }

  Widget _buildArticleImage(dynamic article) {
    return SizedBox(
      height: 240.h,
      width: double.infinity,
      child: article.urlToImage != null
          ? CachedNetworkImage(
              imageUrl: article.urlToImage!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            )
          : Container(color: Colors.grey[300]),
    );
  }

  Widget _buildArticleContent(BuildContext context, dynamic article) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          if (article.author != null) ...[
            _buildAuthorChip(context, article),
            SizedBox(height: 16.h),
          ],
          _buildTitle(context, article),
          SizedBox(height: 16.h),
          _buildBody(context, article),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildAuthorChip(BuildContext context, dynamic article) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        article.author ?? '',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 14.sp,
            ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, dynamic article) {
    return Text(
      article.title ?? '',
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28.sp,
          ),
    );
  }

  Widget _buildBody(BuildContext context, dynamic article) {
    return Text(
      article.content ?? article.description ?? '',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 16.sp,
            height: 1.6,
          ),
    );
  }
}
