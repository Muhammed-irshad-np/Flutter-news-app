import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
                  CustomAppBar(
                    showBackButton: true,
                    showSearchButton: true,
                    onBackPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Article Image
                          SizedBox(
                            height: 300,
                            width: double.infinity,
                            child: article.urlToImage != null
                                ? CachedNetworkImage(
                                    imageUrl: article.urlToImage!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )
                                : Container(color: Colors.grey[300]),
                          ),

                          // Content
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Source and Date
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      article.source?.name ?? '',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      article.publishedAt != null
                                          ? DateFormat('MMM dd, yyyy')
                                              .format(article.publishedAt!)
                                          : '',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Title
                                Text(
                                  article.title ?? '',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Author
                                if (article.author != null) ...[
                                  Text(
                                    'By ${article.author}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Content
                                Text(
                                  article.content ?? article.description ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Read More Button
                                // Center(
                                //   child: ElevatedButton(
                                //     onPressed: controller.openArticleUrl,
                                //     style: ElevatedButton.styleFrom(
                                //       padding: const EdgeInsets.symmetric(
                                //         horizontal: 32,
                                //         vertical: 16,
                                //       ),
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(30),
                                //       ),
                                //     ),
                                //     child: const Text('Read Full Article'),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
