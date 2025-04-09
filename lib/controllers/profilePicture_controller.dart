import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePicController extends GetxController {
  var selectedImage = Rxn<File>();
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    // Untuk Android: minta permission storage
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        var result = await Permission.storage.request();
        if (!result.isGranted) {
          Get.snackbar('Permission', 'Akses penyimpanan ditolak');
          return;
        }
      }
    }
    
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = File(image.path);
      } else {
        Get.snackbar('Gagal', 'Gambar tidak dipilih');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat mengambil gambar');
      print('Image Picker Error: $e');
    }
  }
}
