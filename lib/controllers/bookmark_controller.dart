import 'package:cloud_firestore/cloud_firestore.dart';
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

  // Menambahkan berita ke bookmark (jika belum ada)
  Future<void> addBookmark(News news) async {
    if (!isBookmarked(news)) {
      try {
        await FirebaseFirestore.instance.collection('bookmarked').add({
          'title': news.title,
          'url': news.url,
          'urlToImage': news.imageUrl,
          'source': news.source,
          'email': userController.userModel.value?.email,
        });

        // Tambahkan ke UI secara realtime
        bookmarked_news.add(news);
        print('isi bookmarked_news: $bookmarked_news');
      } catch (e) {
        Get.snackbar('Error', 'Gagal menambahkan bookmark: $e');
      }
    }
  }

  // Menghapus berita dari bookmark
  Future<void> removeBookmark(News news) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('bookmarked')
          .where('url', isEqualTo: news.url)
          .where('email', isEqualTo: userController.userModel.value?.email)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      // Hapus dari UI
      bookmarked_news.removeWhere((item) => item.url == news.url);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus bookmark: $e');
    }
  }

  
  void clearBookmarks() {
    bookmarked_news.clear(); 
  }
}
