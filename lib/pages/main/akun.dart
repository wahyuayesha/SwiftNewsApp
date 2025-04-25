import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';
import 'package:newsapp/components/appbar.dart';
import 'package:newsapp/controllers/auth_controller.dart';
import 'package:newsapp/controllers/profilePicture_controller.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/pages/edit_akun.dart';
// import 'package:newsapp/pages/edit_akun.dart';

// ignore: must_be_immutable
class MyAccount extends StatelessWidget {
  UserController userController = Get.find();
  ProfilePicController profileController = Get.find();
  AuthController authController = Get.find();

  MyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: MyAppBar(), backgroundColor: AppColors.background),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Profile
              Center(
                child: Column(
                  children: [
                    Obx(() {
                      final url = profileController.profilePictureUrl.value;
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            url.startsWith('http') && url.isNotEmpty
                                ? NetworkImage(url)
                                : AssetImage('assets/profile.jpeg'),
                      );
                    }),

                    const SizedBox(height: 10),
                    Obx(() {
                      final user = userController.userModel.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            user != null && user.username.isNotEmpty
                                ? user.username
                                : 'Loading...',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user != null && user.email.isNotEmpty
                                ? user.email
                                : 'Loading...',
                            style: const TextStyle(color: Colors.black45),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(EditAkun(), transition: Transition.fade);
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.background,
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Tile-tile pengaturan
              Column(
                children: [
                  tilePengaturan(
                    const Icon(
                      Icons.account_circle_outlined,
                      color: Colors.grey,
                    ),
                    'Account',
                    null,
                  ),
                  tilePengaturan(
                    const Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.grey,
                    ),
                    'Notification',
                    null,
                  ),
                  tilePengaturan(
                    const Icon(Icons.wb_sunny_outlined, color: Colors.grey),
                    'Theme',
                    null,
                  ),
                  tilePengaturan(
                    const Icon(Icons.help_outline_rounded, color: Colors.grey),
                    'Help',
                    null,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Button Sign Out
              TextButton(
                onPressed: () {
                  authController.logout();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.logout_outlined, color: AppColors.primary,),
                    const SizedBox(width: 5),
                    Text(
                    'Sign out',
                    style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk tile pengaturan
  Widget tilePengaturan(Icon icon, String teks, dynamic route) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.textFieldBackground,
        borderRadius: BorderRadius.circular(13),
      ),
      child: ListTile(
        leading: icon,
        title: Text(teks),
        trailing: const Icon(Icons.navigate_next_rounded),
        onTap: route,
      ),
    );
  }
}
