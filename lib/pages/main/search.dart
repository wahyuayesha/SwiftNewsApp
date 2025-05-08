import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/widgets/appbar.dart';
import 'package:newsapp/widgets/newsTile.dart';
import 'package:newsapp/controllers/search_controller.dart';
import 'package:newsapp/widgets/shimmer_news.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final searchController = Get.put(SearchKeywordController());
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = searchController.keyword.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: MyAppBar(),
        surfaceTintColor: AppColors.background,
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextField(
              controller: textController,
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
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (searchController.isLoading.value) {
                return ShimmerLoading();
              }
              if (searchController.articles.isEmpty) {
                return Center(child: Image.asset('assets/nodata.png', scale: 2));
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
          ),
        ],
      ),
    );
  }
}
