import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:newsapp/models/user.dart';

class UserController extends GetxController {
  var user = Rxn<User>(); // dari firebase auth 
  var userModel = Rxn<UserModel>(); // dari firestore (username, email, profile picture, createdAt)
  var isLoading = false.obs;

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

  // FUNGSI UNTUK (MENGAMBIL) DATA USER DARI FIRESTORE
  Future<void> fetchUserData() async {
    final uid = user.value?.uid;
    try {
      isLoading.value = true;

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        userModel.value = UserModel.fromMap(doc.data()!);
      } else {
        userModel.value = null;
      }
    } catch (e) {
      userModel.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
