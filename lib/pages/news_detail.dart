import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/controllers/webView_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final WebViewControllerX webViewController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(surfaceTintColor: Colors.white),
        body: Obx(() {
          if (webViewController.url.isEmpty) {
            return Center(child: Text("URL tidak tersedia"));
          }
          return WebViewWidget(
            controller:
                WebViewController()
                  ..loadRequest(Uri.parse(webViewController.url.value)),
          );
        }),
      ),
    );
  }
}
