import 'package:flutter/widgets.dart';
import 'package:newsapp/pages/sign_in.dart';
import 'package:newsapp/pages/sign_up.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showSignInPage = true;

  void toggleScreens() {
    setState(() {
      showSignInPage = !showSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignInPage) {
      return SignInPage(showSignUpPage: toggleScreens);
    } else {
      return SignUpPage(showSignInPage: toggleScreens);
    }
  }
}
