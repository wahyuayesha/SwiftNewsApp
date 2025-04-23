import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/components/appbar.dart';
import 'package:newsapp/components/newsTile.dart';
import 'package:newsapp/controllers/bookmark_controller.dart';

class BookmarkView extends StatelessWidget {
  BookmarkView({super.key});
  final BookmarkController bookmarkController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: MyAppBar(), surfaceTintColor: AppColors.background, backgroundColor: AppColors.background),
      body: Obx(() {
        return bookmarkController.bookmarked_news.isEmpty
            ? Center(child: Image.asset('assets/nodata.png', scale: 2,))
            : ListView.builder(
                itemCount: bookmarkController.bookmarked_news.length,
                itemBuilder: (context, index) {
                  return NewsItem(news: bookmarkController.bookmarked_news[index]);
                },
              );
      }),
    );
  }
}
