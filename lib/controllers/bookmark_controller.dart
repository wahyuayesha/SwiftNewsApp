import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/base_url.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/models/news.dart';

class BookmarkController extends GetxController {
  final UserController userController = Get.find<UserController>();
  RxList<News> bookmarked_news = <News>[].obs; // Menyimpan berita yang sudah di bookmark pada user saat ini

  // FUNCTION: Menambahkan berita ke database tabel bookmark
  void bookmarkNews(News news) async {
    var url = Uri.parse('$base_url/bookmark');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userController.currentUserId.value,
        "title": news.title,
        "url": news.url,
        "imageUrl": news.imageUrl,
        "source": news.source,
      }),
    );

    if (response.statusCode == 201) {
      // Setelah berhasil, panggil getBookmarkedNews() untuk memperbarui data bookmark di UI
      getBookmarkedNews();
    } else {
      if (userController.currentUserId.value.isEmpty) {
        Get.snackbar('Error', 'Please sign up or login to bookmark this news');
      } else {
        Get.snackbar('Error', 'Failed to bookmark this news');
      }
    }
  }

  // FUNCTION: Mengambil berita yang sudah di bookmark dari database
  getBookmarkedNews() async {
    var url = Uri.parse(
      '$base_url/get-bookmark?user_id=${userController.currentUserId.value}',
    );
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var bookmarkedData = jsonDecode(response.body);

      if (bookmarkedData != null && bookmarkedData.isNotEmpty) {
        bookmarked_news.assignAll(
          List<News>.from(bookmarkedData.map((item) => News.fromJson(item))),
        );
      }
    } else {
      if (userController.currentUserId.value.isNotEmpty) {
        Get.snackbar('Error', 'Failed to load bookmarked news');
      }
    }
  }

  // FUNCTION: Menghapus berita dari bookmark
  void deleteBookmark(News news) async {
    var url = Uri.parse('$base_url/delete-bookmark');
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userController.currentUserId.value,
        "title": news.title, // "title" : news.url
      }),
    );

    if (response.statusCode == 200) {
      bookmarked_news.removeWhere((item) => item.title == news.title);
    } else {
      Get.snackbar('Error', 'Failed to delete this news from bookmark');
    }
  }

  // FUNCTION: Mengecek apakah berita sudah di bookmark
  bool isBookmarked(News news) {
    return bookmarked_news.any((item) => item.title == news.title);
  }
}
