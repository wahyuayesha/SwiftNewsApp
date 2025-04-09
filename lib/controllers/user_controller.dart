import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/models/user.dart';

class UserController extends GetxController {
  var isloading = false.obs;
  var isSuccess = false.obs;
  var currentUsername = ''.obs;
  var currentEmail = ''.obs;
  var currentPassword = ''.obs;

  // SIGN UP / REGISTRASI USER
  Future<void> registerUser(UserModel user) async {
    try {
      isloading.value = true;
      isSuccess.value = false;

      var url = Uri.parse('http://10.0.2.158:5000/register');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: user.toJsonString(),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        isSuccess.value = true;
        Get.snackbar('Success', data['message']);
        currentUsername.value = user.username;
        currentEmail.value = user.email;
      } else {
        Get.snackbar('Error', data['error'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      Get.snackbar('Error', 'Koneksi ke server gagal');
    } finally {
      isloading.value = false;
    }
  }

  // LOGIN USER
  Future<void> loginUser(UserModel user) async {
    try {
      isloading.value = true;
      isSuccess.value = false;

      var url = Uri.parse('http://10.0.2.158:5000/login');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: user.toJsonString(),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        isSuccess.value = true;
        Get.snackbar('Success', data['message']);
        currentUsername.value = data['user']['username'];
        currentEmail.value = data['user']['email'];
      } else {
        Get.snackbar('Error', data['error']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Koneksi ke server gagal');
    } finally {
      isloading.value = false;
    }
  }

  // GET USER DATA
  Future<void> getUserData() async {
    try {
      isloading.value = true;

      var url = Uri.parse(
        'http://10.0.2.158:5000/get-user/${currentUsername.value}',
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
        Get.snackbar('Error', data['error'] ?? 'Gagal mengambil data user');
      }
    } catch (e) {
      Get.snackbar('Error', 'Koneksi ke server gagal');
    } finally {
      isloading.value = false;
    }
  }

  // UPDATE USER DATA
  Future<void> updateUserData({
    required String username,
    required String email,
    required String password,
    required String newPassword,
  }) async {
    try {
      isloading.value = true;

      var url = Uri.parse(
        'http://10.0.2.158:5000/update/${currentUsername.value}',
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
        Get.snackbar('Error', data['error'] ?? 'Update gagal');
        isSuccess.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Koneksi ke server gagal');
    } finally {
      isloading.value = false;
    }
  }
}
