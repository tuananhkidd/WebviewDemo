import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:webview_demo/core/theme/theme_service.dart';
import 'package:webview_demo/core/translations/app_translations.dart';
import 'package:webview_demo/data/models/todo_model.dart';
import 'package:webview_demo/data/services/todo_service.dart';
import 'package:webview_demo/modules/home/home_controller.dart';
import 'package:webview_demo/modules/home/home_view.dart';

import '../../helpers/fake_webview_platform.dart';
import '../../helpers/test_env.dart';

// ---------------------------------------------------------------------------
// Manual mocks
// ---------------------------------------------------------------------------

/// Fake [TodoService] for widget tests (avoids real DioClient / Provider).
class FakeTodoService extends Fake implements TodoService {
  @override
  Future<TodoModel> getSampleTodo() async {
    return const TodoModel(
      userId: 1,
      id: 1,
      title: 'Widget Test Todo',
      completed: false,
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Wraps [HomeView] inside a [GetMaterialApp] so that GetX routing,
/// translations, and theming are available during widget tests.
Widget _buildTestableHomeView() {
  return GetMaterialApp(
    home: const HomeView(),
    translations: AppTranslations(),
    locale: const Locale('en'),
    fallbackLocale: const Locale('en'),
  );
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

    // Register dependencies required by HomeView / HomeController.
    Get.put<ThemeService>(ThemeService(), permanent: true);

    final todoService = FakeTodoService();
    Get.put<HomeController>(HomeController(todoService));
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.example.webview_demo/native'),
      null,
    );
    Get.reset();
  });

  // -----------------------------------------------------------------------
  // Group 1 – Widget structure
  // -----------------------------------------------------------------------
  group('HomeView – widget structure', () {
    testWidgets('renders a Scaffold with an AppBar', (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('AppBar contains back, forward, refresh and theme icons',
        (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Navigation arrows.
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

      // Reload.
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      // Theme toggle.
      expect(find.byIcon(Icons.brightness_6), findsOneWidget);
    });

    testWidgets('has exactly 4 IconButtons in the AppBar', (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // back, forward, refresh, theme toggle.
      expect(find.byType(IconButton), findsNWidgets(4));
    });
  });

  // -----------------------------------------------------------------------
  // Group 2 – Progress indicator
  // -----------------------------------------------------------------------
  group('HomeView – progress indicator', () {
    testWidgets('shows LinearProgressIndicator when progress < 100',
        (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      // Don't settle – we want to inspect mid-load state.
      await tester.pump();

      final controller = Get.find<HomeController>();
      controller.progress.value = 50;
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('hides LinearProgressIndicator when progress == 100',
        (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pump();

      final controller = Get.find<HomeController>();
      controller.progress.value = 100;
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsNothing);
    });
  });

  // -----------------------------------------------------------------------
  // Group 3 – Navigation button states
  // -----------------------------------------------------------------------
  group('HomeView – navigation button states', () {
    testWidgets('back button is disabled when canGoBack is false',
        (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final controller = Get.find<HomeController>();
      controller.canGoBack.value = false;
      await tester.pump();

      // Find the IconButton with the back arrow icon.
      final backButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_back_ios),
      );
      expect(backButton.onPressed, isNull);
    });

    testWidgets('back button is enabled when canGoBack is true',
        (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final controller = Get.find<HomeController>();
      controller.canGoBack.value = true;
      await tester.pump();

      final backButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_back_ios),
      );
      expect(backButton.onPressed, isNotNull);
    });

    testWidgets('forward button is disabled when canGoForward is false',
        (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final controller = Get.find<HomeController>();
      controller.canGoForward.value = false;
      await tester.pump();

      final forwardButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_forward_ios),
      );
      expect(forwardButton.onPressed, isNull);
    });

    testWidgets('forward button is enabled when canGoForward is true',
        (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final controller = Get.find<HomeController>();
      controller.canGoForward.value = true;
      await tester.pump();

      final forwardButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.arrow_forward_ios),
      );
      expect(forwardButton.onPressed, isNotNull);
    });
  });

  // -----------------------------------------------------------------------
  // Group 4 – Theme toggle
  // -----------------------------------------------------------------------
  group('HomeView – theme toggle', () {
    testWidgets('theme toggle button has tooltip', (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // The theme toggle icon button should carry the localised tooltip.
      final themeButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.brightness_6),
      );
      expect(themeButton.tooltip, isNotNull);
      expect(themeButton.tooltip, isNotEmpty);
    });

    testWidgets('tapping theme toggle does not crash', (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Simply tapping should not throw.
      await tester.tap(find.byIcon(Icons.brightness_6));
      await tester.pump();
    });
  });

  // -----------------------------------------------------------------------
  // Group 5 – PopScope / back handling
  // -----------------------------------------------------------------------
  group('HomeView – PopScope', () {
    // PopScope is generic; use a predicate to find PopScope<dynamic>.
    final popScopeFinder = find.byWidgetPredicate((w) => w is PopScope);

    testWidgets('PopScope exists in the widget tree', (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(popScopeFinder, findsOneWidget);
    });

    testWidgets('canPop reflects controller.canExit', (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final controller = Get.find<HomeController>();

      // Initially false.
      controller.canExit.value = false;
      await tester.pump();

      var popScope = tester.widget<PopScope>(popScopeFinder);
      expect(popScope.canPop, isFalse);

      // Switch to true.
      controller.canExit.value = true;
      await tester.pump();

      popScope = tester.widget<PopScope>(popScopeFinder);
      expect(popScope.canPop, isTrue);
    });
  });

  // -----------------------------------------------------------------------
  // Group 6 – Refresh button
  // -----------------------------------------------------------------------
  group('HomeView – refresh button', () {
    testWidgets('refresh button is always enabled', (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final refreshButton = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.refresh),
      );
      expect(refreshButton.onPressed, isNotNull);
    });

    testWidgets('tapping refresh does not crash', (tester) async {
      await tester.pumpWidget(_buildTestableHomeView());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();
    });
  });
}
