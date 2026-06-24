import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/utils/logger.dart';
import '../../core/utils/native_bridge.dart';
import '../../data/services/todo_service.dart';

/// Controller for the single Home screen.
///
/// Responsibilities:
/// * Own the [WebViewController] that loads the company website.
/// * Call the shared REST function on load and, on success, show the todo
///   `title` as a native toast (Android/iOS).
class HomeController extends GetxController {
  final TodoService _todoService;

  HomeController(this._todoService);

  late final WebViewController webViewController;

  /// Reactive WebView loading progress (0–100). Drives the progress bar.
  final RxInt progress = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initWebView();
    _loadTodoAndToast();
  }

  /// Configures the in-app WebView and starts loading the company website.
  void _initWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (value) => progress.value = value,
          onPageFinished: (_) => progress.value = 100,
        ),
      )
      ..loadRequest(Uri.parse(ApiEndpoints.companyWebsite));
  }

  /// Calls the common REST function (`/todos/1`). On success, forwards the
  /// `title` to the native layer to be displayed as a native toast.
  Future<void> _loadTodoAndToast() async {
    try {
      final todo = await _todoService.getSampleTodo();
      await NativeBridge.showNativeToast(todo.title);
    } catch (e, s) {
      // A failed background fetch must never break the WebView UI.
      AppLogger.e('Todo fetch failed', e, s);
    }
  }
}
