import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/controllers/bookmark_controller.dart';
import 'package:newsapp/controllers/webView_controller.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/pages/news_detail.dart';
import 'package:newsapp/widgets/image_network_shimmer.dart';

// ignore: must_be_immutable
class NewsItem extends StatelessWidget {
  NewsItem({super.key, required this.news});
  final WebViewControllerX webViewController = Get.find();
  final BookmarkController bookmarkController = Get.find();
  final News news;
  bool bookmarked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        webViewController.loadUrl(news.url);
        Get.to(() => WebViewPage());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.hardEdge,
              child:
                  news.imageUrl != ''
                      ? ImageNetworkShimmer(imageUrl: news.imageUrl)
                      : Image.asset('assets/noImage.jpg', fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          news.source,
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Obx(() {
                        final isBookmarked = bookmarkController.isBookmarked(
                          news,
                        );
                        return IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            if (isBookmarked) {
                              await bookmarkController.removeBookmark(news);
                            } else {
                              await bookmarkController.addBookmark(news);
                            }
                          },
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border_rounded,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
