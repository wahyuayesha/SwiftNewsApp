import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/base_url.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePicController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  var profilePictureUrl = ''.obs; // URL gambar profil saaat ini
  var isSucces = false.obs; // Status upload gambar
  
  // PICK IMAGE: Fungsi untuk memilih gambar dari galeri dan menguploadnya ke server
  Future<void> pickImage(String username) async {
    var selectedImage = Rxn<File>();
    // Meminta izin penyimpanan untuk Android
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        var result = await Permission.storage.request();
        if (!result.isGranted) {
          Get.snackbar('Permission', 'Storage permission is required to upload image');
          return;
        }
      }
    }

    // Menggunakan ImagePicker untuk memilih gambar dari galeri
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      } else {
        return;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
      print('Image Picker Error: $e');
      return;
    }

    // Upload gambar ke server setelah gambar dipilih
    try {
      isSucces.value = false;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$base_url/upload-profile-picture/$username'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', selectedImage.value!.path),
      );

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);
      var data = jsonDecode(responseData.body);

      if (response.statusCode == 200) {
        isSucces.value = true;
        await getProfilePicture(username); //
        Get.snackbar('Success', data['message']);
      } else {
        Get.snackbar('Error', data['error'] ?? 'Upload gagal');
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection to server failed');
    }
  }

  // GET IMAGE: Ambil gambar dari server
  Future<void> getProfilePicture(String username) async {
    try {
      var url = Uri.parse(
        '$base_url/get-user-profile-picture/$username',
      );

      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data['profile_picture_url'] != null && data['profile_picture_url'].toString().isNotEmpty) {
          profilePictureUrl.value = data['profile_picture_url'];
        } else { 
          profilePictureUrl.value = 'assets/profile.jpeg'; // default image di assets
        }
      } else {
        profilePictureUrl.value = 'assets/profile.jpeg'; // fallback
        Get.snackbar('Error', data['error'] ?? 'Failed to load profile picture');
      } 
    } catch (e) {
      profilePictureUrl.value = 'assets/profile.jpeg'; // fallback on error
      Get.snackbar('Error', 'Connection to server failed');
    }
  }
}
