import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/models/user.dart';
import 'package:newsapp/pages/sign_up.dart';

class SignInController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var obscurePassword = true.obs;
}

class SignInPage extends StatelessWidget {
  final SignInController controller = Get.put(SignInController());
  final UserController userController = Get.find();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Enter your credential to continue',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textFieldBorder,
                      ),
                    ),
                    SizedBox(height: 70),
                    TextField(
                      controller: usernameController,
                      onChanged: (value) => controller.username.value = value,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: AppColors.textFieldBorder,
                        ),
                        hintText: 'Username',
                        hintStyle: TextStyle(color: AppColors.textFieldBorder),
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
                    Obx(
                      () => TextField(
                        controller: passwordController,
                        obscureText: controller.obscurePassword.value,
                        onChanged: (value) => controller.password.value = value,
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
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        UserModel user = UserModel(
                          username: controller.username.value,
                          email: 'None',
                          password: controller.password.value,
                        );
                        print(
                          "Data Terkirim ke Backend: ${user.toJsonString()}",
                        );

                        await userController.loginUser(user);

                        if (userController.isSuccess.value) {
                          controller.username.value = '';
                          controller.password.value = '';

                          usernameController.clear();
                          passwordController.clear();

                          Get.offAll(Main());
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
                      child: Text('Sign In', style: TextStyle(fontSize: 17)),
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),

            // Bagian bawah tetap
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don’t have an account?',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textFieldBorder,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.offAll(SignUpPage());
                    },
                    child: Text('Sign Up'),
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
