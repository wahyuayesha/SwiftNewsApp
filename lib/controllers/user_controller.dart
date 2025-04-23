import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  // Data user saat ini
  Rxn<User> user = Rxn<User>();
  var username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      user.value = firebaseUser;
      if (firebaseUser != null) {
        ambilUsername();
      } else {
        username.value = '';
      }
    });
  }

  String? get displayName {
    return user.value?.displayName ?? 'User';
  }

  // Getter untuk akses email dengan aman
  String? get email => user.value?.email;

  // Getter untuk tahu apakah user sudah login
  bool get isLoggedIn => user.value != null;

  // Logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  // Ambil username dari Firestore
  Future<void> ambilUsername() async {
    var uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      var doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      username.value = doc['username'];
    }
  }
}
