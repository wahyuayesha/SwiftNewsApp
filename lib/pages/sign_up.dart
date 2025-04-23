import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/controllers/user_controller.dart';

class SignUpController extends GetxController {
  var obscurePassword = true.obs;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

class SignUpPage extends StatelessWidget {
  final VoidCallback showSignInPage;
  SignUpPage({super.key, required this.showSignInPage});
  
  final SignUpController controller = Get.put(SignUpController());
  final UserController userController = Get.put(UserController());

  Future signUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: controller.emailController.text.trim(),
        password: controller.passwordController.text.trim(),
      );

      await userCredential.user!.updateDisplayName(controller.usernameController.text.trim());
      await userCredential.user!.reload();

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': controller.usernameController.text.trim(),
        'email': controller.emailController.text.trim(),
        'createdAt': Timestamp.now(),
      });

      // bisa juga update UserController (opsional)
      userController.username.value = controller.usernameController.text.trim();

    } on FirebaseAuthException catch (e) {
      Get.snackbar('Daftar Gagal', e.message ?? 'Terjadi kesalahan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create your account',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textFieldBorder,
                        ),
                      ),
                      SizedBox(height: 70),
                      // Username
                      TextField(
                        controller: controller.usernameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColors.textFieldBorder,
                          ),
                          hintText: 'Create username',
                          hintStyle: TextStyle(
                            color: AppColors.textFieldBorder,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          filled: true,
                          fillColor: AppColors.lightgrey,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                              color: AppColors.textFieldBackground,
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Email
                      TextField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_rounded,
                            color: AppColors.textFieldBorder,
                          ),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: AppColors.textFieldBorder,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          filled: true,
                          fillColor: AppColors.lightgrey,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: BorderSide(
                              color: AppColors.textFieldBackground,
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      // Password
                      Obx(
                        () => TextField(
                          controller: controller.passwordController,
                          obscureText: controller.obscurePassword.value,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: AppColors.textFieldBorder,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.obscurePassword.toggle();
                              },
                              icon: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.textFieldBorder,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: AppColors.textFieldBorder,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            filled: true,
                            fillColor: AppColors.lightgrey,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: BorderSide(
                                color: AppColors.textFieldBackground,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 40),

                      // Sign Up Button
                      ElevatedButton(
                        onPressed: () async {
                          await signUp();
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonColor,
                          foregroundColor: AppColors.background,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                          elevation: 0,
                        ),
                        child: Text('Sign up', style: TextStyle(fontSize: 17)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textFieldBorder,
                    ),
                  ),
                  TextButton(onPressed: () {
                    showSignInPage();
                  }, child: Text('Sign In')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
