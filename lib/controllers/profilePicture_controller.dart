import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
          Get.snackbar(
            'Permission',
            'Storage permission is required to upload image',
          );
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

    // GET IMAGE: Ambil gambar dari server
  }
}
