import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_app/app/core/theme/app_colors.dart';
import '../../../../data/models/article_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsCardWidget extends StatelessWidget {
  final Article article;

  const NewsCardWidget({
    Key? key,
    required this.article,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Get.toNamed('/article-details', arguments: article),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  height: 160.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    article.source?.name?.toUpperCase() ?? '',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    article.title ?? '',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
