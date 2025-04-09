import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/controllers/bookmark_controller.dart';
import 'package:newsapp/controllers/home_controller.dart';
import 'package:newsapp/controllers/news_controller.dart';
import 'package:newsapp/controllers/profilePicture_controller.dart';
import 'package:newsapp/controllers/webView_controller.dart';
import 'package:newsapp/pages/akun.dart';
import 'package:newsapp/pages/berita.dart';
import 'package:newsapp/pages/bookmarked.dart';
import 'package:newsapp/pages/home.dart';
import 'package:newsapp/pages/search.dart';
import 'package:newsapp/pages/splashscreen.dart';

void main() {
  // Inisialisasi COntroller sekali di awal
  Get.put(NewsController());
  Get.put(WebViewControllerX());
  Get.put(SearchController());
  Get.put(HomeController());
  Get.put(BookmarkController());
  Get.put(ProfilePicController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: SplashScreen()), // Default halaman utama
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange),
      ),
    );
  }
}

// Utama
class Main extends StatelessWidget {
  Main({super.key});
  final RxInt indexHalaman = 2.obs;

  // Halaman yang akan ditampilkan
  final List<Widget> halaman = [
    Search(), // Halaman pencarian
    BeritaScreen(), // Berita per kategori
    HomePage(), // Beranda
    BookmarkView(), // Halaman pencarian
    MyAccount(), // Akun
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: halaman[indexHalaman.value], // Menampilkan halaman sesuai index
          bottomNavigationBar: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)), color: Colors.white),            child: Padding(
              padding: const EdgeInsets.all(8),
              child: GNav(
                selectedIndex:
                    indexHalaman.value, // Menyesuaikan dengan tab yang aktif
                onTabChange: (index) {
                  indexHalaman.value =
                      index; // Mengubah halaman sesuai tab yang ditekan
                },
                backgroundColor: Colors.white,
                gap: 5,
                color: const Color.fromARGB(255, 201, 201, 201),
                activeColor: AppColors.primary,
                padding: EdgeInsets.all(16),
                tabs: const [
                  GButton(icon: Icons.search, text: 'Search'),
                  GButton(icon: Icons.newspaper, text: 'News'),
                  GButton(icon: Icons.home_rounded, text: 'Home'),
                  GButton(icon: Icons.bookmark_rounded, text: 'Saved'),
                  GButton(icon: Icons.person_rounded, text: 'Profile'),
                ], 
              ),
            ),
          ),
        ),
      ),
    );
  }
}
