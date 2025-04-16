import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/base_url.dart';
import 'package:newsapp/controllers/bookmark_controller.dart';
import 'package:newsapp/controllers/profilePicture_controller.dart';
import 'package:newsapp/models/user.dart';
import 'package:newsapp/pages/sign_in.dart';

class UserController extends GetxController {
  // Data user saat ini
  var currentUserId = ''.obs;
  var currentUsername = ''.obs;
  var currentEmail = ''.obs;
  var currentPassword = ''.obs;
  // Indikator 
  var isloading = false.obs;
  var isSuccess = false.obs;
  

  // FUNCTION: Register User
  Future<void> registerUser(UserModel user) async {
    try {
      isloading.value = true;
      isSuccess.value = false;

      var url = Uri.parse('$base_url/register');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: user.toJsonString(),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        isSuccess.value = true;
        Get.snackbar('Success', data['message']);
        currentUserId.value = data['id'].toString();
        currentUsername.value = user.username;
        currentEmail.value = user.email;
      } else {
        Get.snackbar('Error', data['error'] ?? 'Registration failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection to server failed');
    } finally {
      isloading.value = false;
    }
  }
  

  // FUNCTION: Login User
  Future<void> loginUser(UserModel user) async {
    try {
      isloading.value = true;
      isSuccess.value = false;

      var url = Uri.parse('$base_url/login');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: user.toJsonString(),
      );

      var data = jsonDecode(response.body);
      print(data); // Debugging

      if (response.statusCode == 200) {
        isSuccess.value = true;
        currentUserId.value = data['user']['id'].toString();
        currentUsername.value = data['user']['username'];
        currentEmail.value = data['user']['email'];

        Get.snackbar('Success', data['message']);

        // Try block untuk ambil profile picture saja
        try {
          final profileController = Get.find<ProfilePicController>();
          await profileController.getProfilePicture(currentUsername.value);
        } catch (e) {
          print('Failed to fetch profile picture: $e');
        }
      } else {
        Get.snackbar('Error', data['error'] ?? 'Login failed');
      }
    } catch (e) {
      print('Error saat login: $e');
      Get.snackbar('Error', 'Connection to server failed');
    } finally {
      isloading.value = false;
    }
  }


  // FUNCTION: memngambil data user
  Future<void> getUserData() async {
    try {
      isloading.value = true;

      var url = Uri.parse(
        '$base_url/get-user/${currentUsername.value}',
      );
      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar('Success', data['message']);
        print(data); // Debugging
      } else {
        Get.snackbar('Error', data['error'] ?? 'Failed to get user data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection to server failed');
    } finally {
      isloading.value = false;
    }
  }


  // FUNCTION: memperbarui data user
  Future<void> updateUserData({
    required String username,
    required String email,
    required String password,
    required String newPassword,
  }) async {
    try {
      isloading.value = true;

      var url = Uri.parse(
        '$base_url/update/${currentUsername.value}',
      );
      var response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': username,
          'email': email,
          'current_password': password,
          'password': newPassword,
        }),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        isSuccess.value = true;
        currentUsername.value = username;
        currentEmail.value = email;
        currentPassword.value = password;
        Get.snackbar('Success', data['message']);
      } else {
        Get.snackbar('Error', data['error'] ?? 'Update failed');
        isSuccess.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection to server failed');
    } finally {
      isloading.value = false;
    }
  }


  // FUNCTION: Logout User
  Future<void> logout() async {
    final profileController = Get.find<ProfilePicController>();
    final bookmarkController = Get.find<BookmarkController>();
    
    // reset data user
    currentUserId.value = '';
    currentUsername.value = '';
    currentEmail.value = '';
    currentPassword.value = '';

    // reset foto profile
    profileController.profilePictureUrl.value = 'assets/profile.jpeg';
    profileController.isSucces.value = false;

    // reset bookmark
    bookmarkController.bookmarked_news.clear(); 

    // navigasi ke halaman sign in
    Get.offAll(SignInPage());
  }
}
