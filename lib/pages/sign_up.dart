import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/models/user.dart';
import 'package:newsapp/pages/sign_in.dart';
import 'package:newsapp/pages/welcome_screen.dart';

class SignUpController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var obscurePassword = true.obs;
}

class SignUpPage extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());
  final UserController userController = Get.put(UserController());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                        controller: usernameController,
                        onChanged: (value) => controller.username.value = value,
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
                        controller: emailController,
                        onChanged: (value) => controller.email.value = value,
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
                          controller: passwordController,
                          obscureText: controller.obscurePassword.value,
                          onChanged:
                              (value) => controller.password.value = value,
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
                          // Buat objek user dari model
                          UserModel newUser = UserModel(
                            username: controller.username.value,
                            email: controller.email.value,
                            password: controller.password.value,
                          );

                          // Panggil fungsi register
                          await userController.registerUser(newUser);

                          // Jika sukses, kosongkan input dan pindah ke halaman Welcome
                          if (userController.isSuccess.value) {
                            controller.username.value = '';
                            controller.email.value = '';
                            controller.password.value = '';

                            usernameController.clear();
                            emailController.clear();
                            passwordController.clear();

                            Get.offAll(WelcomeScreen());
                          }
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
                      TextButton(
                        onPressed: () {
                          Get.to(WelcomeScreen());
                        },
                        child: Text(
                          'Skip for now',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textFieldBorder,
                          ),
                        ),
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
                  TextButton(
                    onPressed: () {
                      Get.offAll(SignInPage(), transition: Transition.cupertino, duration: Duration(seconds: 1));
                    },
                    child: Text('Sign In'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
