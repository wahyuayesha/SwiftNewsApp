import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:newsapp/colors.dart';
import 'package:newsapp/controllers/profilePicture_controller.dart';
import 'package:newsapp/controllers/user_controller.dart';
import 'package:newsapp/main.dart';

class EditProfileController extends GetxController {
  var obscurePassword = true.obs;
  var obscureNewPassword = true.obs;

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleObscureNewPassword() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }
}

class EditAkun extends StatelessWidget {
  EditAkun({super.key});
  final EditProfileController editController = Get.put(EditProfileController());
  final UserController userController = Get.put(UserController());
  final ProfilePicController profileController = Get.find();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(fontSize: 18)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Obx(() {
                          final url = profileController.profilePictureUrl.value;
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                url.startsWith('http') && url.isNotEmpty
                                    ? NetworkImage(url)
                                    : AssetImage('assets/profile.jpeg'),
                          );
                        }),
                        IconButton.filled(
                          onPressed:
                              () => profileController.pickImage(
                                userController.currentUsername.value,
                              ),
                          icon: Icon(Icons.edit),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userController.currentUsername.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userController.currentEmail.value,
                      style: TextStyle(color: Colors.black45),
                      maxLines: 1, // Batasi teks email agar tidak overflow
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 40),
                    myTextField(
                      'Username',
                      Icon(Icons.person, color: AppColors.textFieldBorder),
                      usernameController,
                    ),
                    SizedBox(height: 15),
                    myTextField(
                      'Email',
                      Icon(Icons.email, color: AppColors.textFieldBorder),
                      emailController,
                    ),
                    SizedBox(height: 15),
                    Divider(color: AppColors.textFieldBackground, thickness: 1),
                    SizedBox(height: 15),
                    Obx(
                      () => myTextField(
                        'Current Password',
                        Icon(Icons.lock, color: AppColors.textFieldBorder),
                        currentPasswordController,
                        obscureText: editController.obscurePassword.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            editController.obscurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textFieldBorder,
                          ),
                          onPressed:
                              () => editController.toggleObscurePassword(),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Obx(
                      () => myTextField(
                        'New Password',
                        Icon(Icons.lock, color: AppColors.textFieldBorder),
                        newPasswordController,
                        obscureText: editController.obscureNewPassword.value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            editController.obscureNewPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textFieldBorder,
                          ),
                          onPressed:
                              () => editController.toggleObscureNewPassword(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  alert();
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget textfield
  Widget myTextField(
    String hint,
    Icon icon,
    TextEditingController controller, {
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: icon,
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textFieldBorder),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
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
    );
  }

  // Alert dialog untuk konfirmasi simpan perubahan
  void alert() {
    Get.defaultDialog(
      title: 'Save Changes',
      titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      middleText: 'Are you sure you want save changes?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () async {
        final usernameBaru =
            usernameController.text.isNotEmpty
                ? usernameController.text
                : userController.currentUsername.value;

        final emailBaru =
            emailController.text.isNotEmpty
                ? emailController.text
                : userController.currentEmail.value;

        final passwordBaru =
            newPasswordController.text.isNotEmpty
                ? newPasswordController.text
                : currentPasswordController.text;

        await userController.updateUserData(
          username: usernameBaru,
          email: emailBaru,
          password: currentPasswordController.text,
          newPassword: passwordBaru,
        );

        if (userController.isSuccess.value) {
          // bersihkan field setelah sukses update
          usernameController.clear();
          emailController.clear();
          currentPasswordController.clear();
          newPasswordController.clear();

          Get.offAll(Main());
        } else {
          Get.snackbar(
            'Error',
            'Failed to update profile',
            duration: Duration(seconds: 2),
          );
        }
        // Debugging
        print('Username: $usernameBaru');
        print('Email: $emailBaru');
        print('Password yang dikirim: $passwordBaru');
      },
      onCancel: () {
        Get.back();
      },
    );
  }
}
