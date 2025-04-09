import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/components/appbar.dart';
import 'package:newsapp/components/newsListScreen.dart';
import 'package:newsapp/controllers/search_controller.dart';

class Search extends StatelessWidget {
  Search({super.key});
  final searchController = Get.put(SearchKeywordController());
  final textController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: MyAppBar(), surfaceTintColor: AppColors.background, backgroundColor: AppColors.background),
      body: Column(
        children: [
          Obx(
            () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TextField(
                controller:
                    textController..text = searchController.keyword.value,
                onChanged: (value) {
                  searchController.keyword.value = value;
                },
                onSubmitted: (value) {
                  searchController.searchNews(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: AppColors.textFieldBorder),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textFieldBorder,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                  filled: true,
                  fillColor: AppColors.textFieldBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(
                      color: AppColors.textFieldBackground,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 10),
          Obx(() {
            if (searchController.isLoading.value) {
              return Expanded(child: Center(child: CircularProgressIndicator()));
            }
            if (searchController.articles.isEmpty) {
              return Expanded(child: Center(child: Image.asset('assets/nodata.png', scale: 2)));
            }
            return Expanded(
              child: ListView.builder(
                itemCount: searchController.articles.length,
                itemBuilder: (context, index) {
                  final news = searchController.articles[index];
                  return NewsItem(news: news);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
