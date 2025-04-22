import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/components/appbar.dart';
import 'package:newsapp/components/newsTile.dart';
import 'package:newsapp/controllers/home_controller.dart';
import 'package:newsapp/controllers/webView_controller.dart';
import 'package:newsapp/models/news.dart';
import 'package:newsapp/pages/news_detail.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController homeController = Get.find();
  final WebViewControllerX webViewController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: MyAppBar(), surfaceTintColor: AppColors.background, backgroundColor: AppColors.background),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  if (homeController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (homeController.topHeadlines.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Image.asset('assets/nodata.png', scale: 2),
                      ),
                    );
                  }
                  final topnews = homeController.topHeadlines[0];
                  return _buildBeritaUtama(context, topnews);
                }),
                const SizedBox(height: 25),
                const Text(
                  'Popular News',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (homeController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (homeController.popularNews.isEmpty) {
                return Center(
                  child: Image.asset('assets/nodata.png', scale: 2),
                );
              }
              return ListView.builder(
                itemCount: homeController.popularNews.length,
                itemBuilder: (context, index) {
                  final popnews = homeController.popularNews[index];
                  return NewsItem(news: popnews);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBeritaUtama(BuildContext context, News news) {
    return GestureDetector(
      onTap: () {
        webViewController.loadUrl(news.url);
        Get.to(WebViewPage());
      },
      child: Stack(
        children: [
          // Gambar
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image:
                    news.imageUrl.isNotEmpty
                        ? NetworkImage(news.imageUrl) as ImageProvider
                        : const AssetImage('assets/noImage.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Meredupkan gambar
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(54, 0, 0, 0),
            ),
          ),
          // Teks sumber
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              news.source,
              style: const TextStyle(color: Colors.blueAccent),
            ),
          ),
          // Teks judul dan animasi
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisSize:
                  MainAxisSize.min, // Agar tidak melebihi lebar yang diperlukan
              children: [
                Lottie.asset(
                  'assets/animation/popular.json',
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppColors.background,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
