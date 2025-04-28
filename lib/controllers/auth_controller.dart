import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/pages/auth/sign_in.dart';
import 'package:newsapp/pages/auth/sign_up.dart';

class AuthController extends GetxController {
 final SignUpController signUpController = Get.put(SignUpController());
 final SignInController signInController = Get.put(SignInController());
 final UserController userController = Get.find();
 
  // FUNGSI UNTUK (SIGN UP)
  Future signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signUpController.emailController.text.trim(),
        password: signUpController.passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': signUpController.usernameController.text.trim(),
        'email': signUpController.emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'An error occurred');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // FUNGSI UNTUK (SIGN IN)
  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: signInController.emailController.text.trim(),
      password: signInController.passwordController.text.trim(),
      );
      userController.fetchUserData(); 
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Failed', e.message ?? 'An error occurred');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // FUNGSI UNTUK (LOGOUT)
  Future<void> logout() async {
      userController.userModel.value = null;
      await FirebaseAuth.instance.signOut();
    }

  // FUNGSI UNTUK (HAPUS)AKUN
  Future<void> deleteUserAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
        await user.delete();
        Get.snackbar('Success', 'Account deleted permanently.');
        Get.offAll(Main());
      } catch (e) {
        Get.snackbar('Error', 'Error occured: $e');
      }
    } else {
      Get.snackbar('Error', 'User not found.');
    }
  }
}