import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_loading.dart';

/// Global, imperative loading helper backed by GetX dialogs.
///
/// Lets any controller show/hide a blocking, full-screen loader without needing
/// a `BuildContext` — useful for async actions triggered outside the widget
/// tree (e.g. inside a controller method).
///
/// ```dart
/// LoadingHelper.show();
/// try {
///   await repository.save();
/// } finally {
///   LoadingHelper.hide();
/// }
/// ```
class LoadingHelper {
  LoadingHelper._(); // Prevent instantiation.

  /// Shows the blocking loader. Safe to call when one is already visible (no-op).
  static void show({String? message}) {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      PopScope(
        // Prevent the back button from dismissing the loader.
        canPop: false,
        child: Center(
          child: AppLoading(
            showMessage: message != null,
            message: message,
            color: Colors.white,
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black45,
    );
  }

  /// Hides the loader if one is currently open.
  static void hide() {
    if (Get.isDialogOpen ?? false) Get.back();
  }
}
