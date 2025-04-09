import 'package:get/get.dart';

class WebViewControllerX extends GetxController {
  var url = "".obs;

  void loadUrl(String newUrl) {
    url.value = newUrl;
    update();
  }
}
