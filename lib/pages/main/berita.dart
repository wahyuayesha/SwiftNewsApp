import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/components/appbar.dart';
import 'package:newsapp/components/newsTile.dart';
import 'package:newsapp/controllers/news_controller.dart';
import 'package:newsapp/constants/colors.dart';

class BeritaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewsController>(
      builder: (newsController) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: MyAppBar(), surfaceTintColor: AppColors.background, backgroundColor: AppColors.background),
          body: Column(
            children: [
              // Button-button kategori
              SizedBox(
                height: 40,
                child: Obx(
                  () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: newsController.categories.length,
                    itemBuilder: (context, index) {
                      final category = newsController.categories[index];
                      final isSelected =
                          category == newsController.selectedCategory.value;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: GestureDetector(
                          onTap: () {
                            newsController.updateCategory(category);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? AppColors.primary
                                      : AppColors.textFieldBackground,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? AppColors.background
                                        : AppColors.textFieldBorder,
                                fontWeight:
                                    isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Builder berita-berita dari API
              Expanded(
                child: Obx(() {
                  if (newsController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (newsController.articles.isEmpty) {
                    return Center( 
                      child: Image.asset('assets/nodata.png', scale: 2),
                    );
                  }
                  return ListView.builder(
                    itemCount: newsController.articles.length,
                    itemBuilder: (context, index) {
                      final news = newsController.articles[index];
                      return NewsItem(news: news);
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
