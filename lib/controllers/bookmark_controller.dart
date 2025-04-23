import 'package:get/get.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/models/news.dart';

class BookmarkController extends GetxController {
  final UserController userController = Get.find<UserController>();
  RxList<News> bookmarked_news = <News>[].obs; // Menyimpan berita yang sudah di bookmark pada user saat ini

  // FUNCTION: Mengecek apakah berita sudah di bookmark
  bool isBookmarked(News news) {
    return bookmarked_news.any((item) => item.title == news.title);
  }
}
