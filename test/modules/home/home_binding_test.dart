import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:webview_demo/data/models/todo_model.dart';
import 'package:webview_demo/data/services/todo_service.dart';
import 'package:webview_demo/modules/home/home_binding.dart';
import 'package:webview_demo/modules/home/home_controller.dart';

import '../../helpers/fake_webview_platform.dart';
import '../../helpers/test_env.dart';

// ---------------------------------------------------------------------------
// Manual mock
// ---------------------------------------------------------------------------

/// Fake [TodoService] for binding tests (avoids real DioClient / Provider).
class FakeTodoService extends Fake implements TodoService {
  @override
  Future<TodoModel> getSampleTodo() async {
    return const TodoModel(
      userId: 1,
      id: 1,
      title: 'Binding Test',
      completed: false,
    );
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFakeWebViewPlatform();
  });

  setUp(() {
    // Load test environment values so EnvConfig getters work.
    loadTestEnv();

    Get.reset();

    // Stub the native MethodChannel.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.example.webview_demo/native'),
      (MethodCall methodCall) async => null,
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.example.webview_demo/native'),
      null,
    );
    Get.reset();
  });

  group('HomeBinding', () {
    test('registers HomeController via lazyPut', () {
      // Pre-register the dependency that HomeBinding expects to find.
      Get.put<TodoService>(FakeTodoService(), permanent: true);

      // Run the binding.
      HomeBinding().dependencies();

      // HomeController should now be lazily registered and resolvable.
      final controller = Get.find<HomeController>();
      expect(controller, isA<HomeController>());
    });

    test('resolves the same HomeController instance on repeated finds', () {
      Get.put<TodoService>(FakeTodoService(), permanent: true);
      HomeBinding().dependencies();

      final first = Get.find<HomeController>();
      final second = Get.find<HomeController>();
      expect(identical(first, second), isTrue);
    });
  });
}
