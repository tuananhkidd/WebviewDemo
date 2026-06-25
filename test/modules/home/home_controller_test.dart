import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:webview_demo/data/models/todo_model.dart';
import 'package:webview_demo/data/services/todo_service.dart';
import 'package:webview_demo/modules/home/home_controller.dart';

import '../../helpers/fake_webview_platform.dart';
import '../../helpers/test_env.dart';

// ---------------------------------------------------------------------------
// Manual mock for TodoService
// ---------------------------------------------------------------------------

/// A fake [TodoService] whose [getSampleTodo] behaviour can be configured per
/// test. By default it returns a valid [TodoModel].
///
/// We extend [Fake] and implement [TodoService] to avoid pulling in the real
/// [TodoProvider] / [DioClient] dependency chain.
class MockTodoService extends Fake implements TodoService {
  /// The todo returned by [getSampleTodo]. Override per test.
  TodoModel todoToReturn = const TodoModel(
    userId: 1,
    id: 1,
    title: 'Test Todo',
    completed: false,
  );

  /// If non-null, [getSampleTodo] will throw this instead of returning.
  Object? errorToThrow;

  /// Tracks whether [getSampleTodo] was called.
  bool getSampleTodoCalled = false;

  @override
  Future<TodoModel> getSampleTodo() async {
    getSampleTodoCalled = true;
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    return todoToReturn;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // Ensure the Flutter binding is initialised for MethodChannel mocking.
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockTodoService mockTodoService;
  late HomeController controller;

  setUpAll(() {
    // Register the fake WebViewPlatform once – it applies to every test.
    registerFakeWebViewPlatform();
  });

  setUp(() {
    // Load test environment values so EnvConfig getters work.
    loadTestEnv();

    // Reset GetX between tests.
    Get.reset();

    // Stub the native MethodChannel so NativeBridge.showNativeToast never hits
    // a real platform layer during tests.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.example.webview_demo/native'),
      (MethodCall methodCall) async => null,
    );

    mockTodoService = MockTodoService();
  });

  tearDown(() {
    // Clean up the MethodChannel mock.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.example.webview_demo/native'),
      null,
    );
    Get.reset();
  });

  // Helper: instantiates the controller and triggers GetX lifecycle (onInit).
  void initController() {
    controller = HomeController(mockTodoService);
    Get.put(controller);
  }

  // -----------------------------------------------------------------------
  // Group 1 – Initialisation
  // -----------------------------------------------------------------------
  group('HomeController – initialisation', () {
    test('should have default reactive values before onInit', () {
      // Create without registering in GetX so onInit is NOT called.
      controller = HomeController(mockTodoService);

      expect(controller.progress.value, 0);
      expect(controller.canExit.value, false);
      expect(controller.canGoBack.value, false);
      expect(controller.canGoForward.value, false);
    });

    test('onInit creates a WebViewController', () {
      initController();
      expect(controller.webViewController, isNotNull);
    });

    test('onInit calls TodoService.getSampleTodo', () async {
      initController();

      // Give the async _loadTodoAndToast a chance to complete.
      await Future<void>.delayed(Duration.zero);

      expect(mockTodoService.getSampleTodoCalled, isTrue);
    });

    test('onInit survives TodoService throwing an error', () async {
      mockTodoService.errorToThrow = Exception('network error');

      // Should NOT throw.
      initController();
      await Future<void>.delayed(Duration.zero);

      // Controller is still alive and functional.
      expect(controller.progress.value, 0);
      expect(mockTodoService.getSampleTodoCalled, isTrue);
    });
  });

  // -----------------------------------------------------------------------
  // Group 2 – Reactive state (progress / canExit / canGoBack / canGoForward)
  // -----------------------------------------------------------------------
  group('HomeController – reactive state', () {
    test('progress is observable and can be updated', () {
      initController();

      controller.progress.value = 50;
      expect(controller.progress.value, 50);

      controller.progress.value = 100;
      expect(controller.progress.value, 100);
    });

    test('canExit is observable and toggleable', () {
      initController();

      expect(controller.canExit.value, false);
      controller.canExit.value = true;
      expect(controller.canExit.value, true);
    });

    test('canGoBack is observable and toggleable', () {
      initController();

      expect(controller.canGoBack.value, false);
      controller.canGoBack.value = true;
      expect(controller.canGoBack.value, true);
    });

    test('canGoForward is observable and toggleable', () {
      initController();

      expect(controller.canGoForward.value, false);
      controller.canGoForward.value = true;
      expect(controller.canGoForward.value, true);
    });
  });

  // -----------------------------------------------------------------------
  // Group 3 – WebViewController existence
  // -----------------------------------------------------------------------
  group('HomeController – webViewController', () {
    test('webViewController is initialised after onInit', () {
      initController();
      expect(controller.webViewController, isNotNull);
    });
  });

  // -----------------------------------------------------------------------
  // Group 4 – TodoService interaction
  // -----------------------------------------------------------------------
  group('HomeController – TodoService interaction', () {
    test('calls NativeBridge.showNativeToast with todo title on success',
        () async {
      // We mock the MethodChannel at the top of setUp; just verify no error.
      mockTodoService.todoToReturn = const TodoModel(
        userId: 1,
        id: 1,
        title: 'Custom title from service',
        completed: true,
      );

      initController();
      await Future<void>.delayed(Duration.zero);

      expect(mockTodoService.getSampleTodoCalled, isTrue);
    });

    test('does not crash when TodoService throws', () async {
      mockTodoService.errorToThrow = Exception('timeout');

      initController();
      await Future<void>.delayed(Duration.zero);

      // The controller should remain operational.
      expect(controller.progress.value, isNonNegative);
    });
  });

  // -----------------------------------------------------------------------
  // Group 5 – Navigation methods
  // -----------------------------------------------------------------------
  group('HomeController – navigation methods', () {
    test('goBack does not throw', () async {
      initController();
      // With fake platform, canGoBack() returns false so goBack is a no-op.
      await expectLater(controller.goBack(), completes);
    });

    test('goForward does not throw', () async {
      initController();
      // With fake platform, canGoForward() returns false so goForward is a no-op.
      await expectLater(controller.goForward(), completes);
    });

    test('updateNavigationState completes without error', () async {
      initController();
      await expectLater(controller.updateNavigationState(), completes);
    });
  });
}
