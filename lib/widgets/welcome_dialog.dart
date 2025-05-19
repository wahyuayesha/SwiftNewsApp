import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/constants/colors.dart';

class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/welcome.png', scale: 2.5),
          SizedBox(height: 7),
          Text(
            'WELCOME!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            'Stay updated with the latest news and trusted information at your fingertips.',
            style: TextStyle(fontSize: 15, color: AppColors.textFieldBorder),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              foregroundColor: AppColors.background,
              minimumSize: const Size(100, 40),
              elevation: 0,
            ),
            onPressed: () {
              Get.back();
            },
            child: Text('Okay!'),
          ),
        ),
      ],
    );
  }
}
