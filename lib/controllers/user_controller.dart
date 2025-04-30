import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/models/user.dart';

class UserController extends GetxController {
  var user = Rxn<User>(); // dari firebase auth
  var userModel =Rxn<UserModel>(); // dari firestore (username, email, profile picture, createdAt)
  
  // FETCH USER DATA DARI FIRESTORE DIAWAL
  @override
  void onInit() {
    super.onInit();
    user.value = FirebaseAuth.instance.currentUser;
    if (user.value != null) {
      fetchUserData();
    }
    // Dengarkan perubahan status login user
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      user.value = firebaseUser;
      if (firebaseUser != null) {
        await fetchUserData();
      } else {
        userModel.value = null;
      }
    });
  }


  // FUNCTION: UNTUK (MENGAMBIL) DATA USER DARI FIRESTORE
  Future<void> fetchUserData() async {
    final uid = user.value?.uid;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        userModel.value = UserModel.fromMap(doc.data()!);
      } else {
        userModel.value = null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      userModel.value = null;
    } 
  }


  /// FUNCTION: UNTUK (MEMPERBARUI) DATA USER 
  Future<void> updateUserData({
    required String currentPassword,
    required String newUsername,
    required String newProfilePictureUrl,
    required String newPassword,
    }) async {

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.snackbar('Kesalahan', 'Pengguna belum login.');
      return;
    }

    // 1. UPDATE DATA FIREBASE AUTH
    try {
      // Re-auth user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password jika diisi
      if (newPassword.isNotEmpty) {
        await user.updatePassword(newPassword);
      }

    // 2. UPDATE DATA FIRESTORE
      Map<String, dynamic> newData = {};
      if (newUsername.isNotEmpty) newData['username'] = newUsername;
      if (newProfilePictureUrl.isNotEmpty) newData['profilePicture'] = newProfilePictureUrl;

      if (newData.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update(newData);
      }

      await fetchUserData(); // Memperbarui data userModel di controller
      Get.snackbar('Succes', 'Your data has been updated successfully!');
      Get.offAll(Main());
    } catch (e) {
      if (e.toString().contains('dev.flutter.pigeon.firebase_auth_platform_interface.FirebaseAuthUserHostApi.reauthenticateWithCredential')) {
        Get.snackbar('Error', 'Password incorrect.');
      } else {
        Get.snackbar('Error', 'Failed to update data: ${e.toString()}');
      }
    }
  }

  // FUNCTION: REPORT BUG
  Future<void> reportBug(String bugReport) async {
    try {
      await FirebaseFirestore.instance.collection('bug_report').add({
        'email': userModel.value?.email,
        'username': userModel.value?.username,
        'bug_report': bugReport,
        'sendAt': Timestamp.now(),
      });
      Get.snackbar('Success', 'Bug reported successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to report bug: ${e.toString()}');
    }
  }
}
