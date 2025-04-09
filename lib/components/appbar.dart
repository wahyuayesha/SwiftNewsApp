import 'package:flutter/material.dart';
import 'package:newsapp/colors.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/icon.png', scale: 2.5),
        SizedBox(width: 5),
        Row(
          children: [
            Text('Swift', style: TextStyle(fontSize: 20, )),
            Text(
              'News',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
