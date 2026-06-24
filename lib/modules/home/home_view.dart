import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/theme/theme_service.dart';
import '../../core/translations/app_translations.dart';
import 'home_controller.dart';

/// The single Home screen: hosts the company website in an in-app WebView.
///
/// UI only — all logic (WebView setup, API call, toast) lives in
/// [HomeController]. Uses [GetView] so `controller` is available directly.
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.homeTitle.tr),
        actions: [
          // Light/dark theme toggle wired to the GetX ThemeService.
          IconButton(
            tooltip: LocaleKeys.toggleTheme.tr,
            icon: const Icon(Icons.brightness_6),
            onPressed: ThemeService.to.toggleTheme,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Obx(() {
            final value = controller.progress.value;
            // Hide the bar once the page has fully loaded.
            return value < 100
                ? LinearProgressIndicator(value: value / 100)
                : const SizedBox(height: 3);
          }),
        ),
      ),
      body: WebViewWidget(controller: controller.webViewController),
    );
  }
}
