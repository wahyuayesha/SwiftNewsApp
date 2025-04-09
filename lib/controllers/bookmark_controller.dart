import 'package:get/get.dart';
import 'package:newsapp/models/news.dart';

class BookmarkController extends GetxController {
  RxList<News> bookmarked_news = <News>[].obs;

  void addBookmark(News news) {
    if (!isBookmarked(news)) {
      bookmarked_news.add(news);
    }
  }

  void deleteBookmark(News news) {
    bookmarked_news.removeWhere((item) => item.title == news.title);
  }

  bool isBookmarked(News news) {
    return bookmarked_news.any((item) => item.title == news.title);
  }
}

