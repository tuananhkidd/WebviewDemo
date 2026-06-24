# Webview Demo — Flutter Base Project

A scalable, production-oriented Flutter starter built with **GetX** (state
management, routing, dependency injection) and **Dio** (networking). It ships
with internationalization, light/dark theming, a feature-based folder structure,
an in-app WebView, a shared REST API layer, and a **native toast bridge**
(Android `Toast` / iOS overlay) driven through a `MethodChannel`.

---

## ✨ Features

| Area | Implementation |
|------|----------------|
| State / Routing / DI | `get` (GetX) — `GetMaterialApp`, `GetPage`, `Bindings`, `GetxController` |
| Networking | `dio` — Base API client (`DioClient`) with a global `ApiInterceptor` (token injection, request/response logging, error mapping) |
| i18n | GetX `Translations` — English (`en`) default + `vi` example |
| Theming | Light & Dark `ThemeData` + `ThemeService.toggleTheme()` |
| WebView | `webview_flutter` loading `https://www.sgcarmart.com` |
| Native bridge | `MethodChannel` sends the API result to native Android/iOS, shown as a native toast |

---

## 🗂 Folder Structure

```text
lib/
├── main.dart                       # App entry point (GetMaterialApp, i18n, theme, routes)
│
├── core/                           # Shared, feature-agnostic building blocks
│   ├── bindings/
│   │   └── initial_binding.dart    # App-wide singletons (DioClient, services, ThemeService)
│   ├── constants/
│   │   ├── api_endpoints.dart       # Base URL, paths, website URL, timeouts
│   │   ├── app_colors.dart          # Color palette
│   │   └── app_constants.dart       # Channel names, method names, pref keys
│   ├── network/
│   │   ├── dio_client.dart          # Base API client (configured Dio)
│   │   └── api_interceptor.dart     # Token / logging / error interceptor
│   ├── theme/
│   │   ├── theme_config.dart        # Light & Dark ThemeData
│   │   └── theme_service.dart       # GetX theme switcher
│   ├── translations/
│   │   └── app_translations.dart    # GetX Translations + LocaleKeys
│   └── utils/
│       ├── logger.dart              # Debug-only logging helper
│       └── native_bridge.dart       # Dart -> native MethodChannel wrapper
│
├── data/                           # Data sources
│   ├── models/
│   │   └── todo_model.dart          # Typed model (fromJson/toJson)
│   ├── providers/
│   │   └── todo_provider.dart       # Raw API calls via DioClient
│   └── services/
│       └── todo_service.dart        # Shared, cross-platform REST function
│
├── modules/                        # Feature modules (View + Controller + Binding)
│   ├── home/
│   │   ├── home_binding.dart
│   │   ├── home_controller.dart
│   │   ├── home_view.dart
│   │   └── widgets/
│   │       └── todo_card.dart       # Extracted sub-widget (shallow nesting)
│   └── webview/
│       ├── webview_binding.dart
│       ├── webview_controller.dart
│       └── webview_view.dart
│
└── routes/
    ├── app_routes.dart             # Route name constants (Routes)
    └── app_pages.dart              # GetPage declarations + bindings
```

**Native layer**

```text
android/app/src/main/kotlin/com/example/webview_demo/MainActivity.kt   # Android Toast handler
ios/Runner/AppDelegate.swift                                           # iOS native toast handler
android/app/src/main/AndroidManifest.xml                               # INTERNET permission
```

---

## 🚀 Running the Project

```bash
# 1. Install dependencies
flutter pub get

# 2. Run on a connected device / simulator
flutter run

# Platform-specific
flutter run -d ios
flutter run -d android

# Static analysis
flutter analyze
```

> Requires Flutter 3.5+ (Dart 3.5+). Tested with Flutter 3.35.

### What happens on launch
1. `InitialBinding` registers the `DioClient`, providers, services and `ThemeService`.
2. `HomeController.onInit()` calls the shared REST function
   (`https://jsonplaceholder.typicode.com/todos/1`).
3. On success, the todo `title` is rendered in a card **and** sent to the native
   layer via `MethodChannel`, which shows it as a **native toast** on both
   Android and iOS.
4. Tap **Open Website** to load `https://www.sgcarmart.com` in the in-app WebView.

---

## 🧩 How to Add a New Module

Create a folder under `lib/modules/<feature>/` with three files:

**1. Controller** — `lib/modules/profile/profile_controller.dart`
```dart
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxString name = ''.obs;
  // ... state + logic only, no UI
}
```

**2. Binding** — `lib/modules/profile/profile_binding.dart`
```dart
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
```

**3. View** — `lib/modules/profile/profile_view.dart`
```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Obx(() => Text(controller.name.value)));
  }
}
```

**4. Register the route** in `lib/routes/app_routes.dart`:
```dart
static const String profile = '/profile';
```

and in `lib/routes/app_pages.dart`:
```dart
GetPage(
  name: Routes.profile,
  page: () => const ProfileView(),
  binding: ProfileBinding(),
),
```

Navigate with `Get.toNamed(Routes.profile)`.

> Keep `build()` shallow: extract independent UI blocks (header, form, list item)
> into their own widget classes under the module's `widgets/` folder.

---

## 🌍 How to Add a Language

Edit `lib/core/translations/app_translations.dart`:

1. Add a new locale map (e.g. `'fr'`) with the **same keys**:
   ```dart
   'fr': {
     LocaleKeys.homeTitle: 'Accueil',
     // ... all other keys
   },
   ```
2. Add any new key to `LocaleKeys` and to **every** locale map.
3. Use it in widgets: `Text(LocaleKeys.homeTitle.tr)`.
4. Switch language at runtime: `Get.updateLocale(const Locale('fr'));`

English (`en`) is the default and the `fallbackLocale`.

---

## 🎨 How to Change the Theme

Theme switching is handled by `ThemeService` (registered globally).

```dart
// Toggle light <-> dark from anywhere
ThemeService.to.toggleTheme();

// Force a specific mode
ThemeService.to.setDarkMode(true);

// Read the current mode
final isDark = ThemeService.to.isDarkMode;
```

The Home screen's app bar already includes a toggle button. Customize colors in
`core/constants/app_colors.dart` and the `ThemeData` in
`core/theme/theme_config.dart`.

---

## 🌐 Networking (Dio)

- `DioClient` (`core/network/dio_client.dart`) is the single configured HTTP
  entry point: base URL, timeouts, JSON headers, interceptors.
- `ApiInterceptor` (`core/network/api_interceptor.dart`) handles:
  - **Token injection** — supply a `tokenProvider` callback to attach
    `Authorization: Bearer <token>` to every request.
  - **Logging** — request/response/error logs in debug builds.
  - **Error mapping** — converts `DioException` into readable messages.
- Add new endpoints in `core/constants/api_endpoints.dart`, a `Provider` for raw
  calls, and a `Service` for the app-facing API.

---

## 📱 Native Toast Bridge

The flow `Dart -> Native -> Toast`:

1. `NativeBridge.showNativeToast(title)` invokes the `showToast` method on the
   channel `com.example.webview_demo/native`.
2. **Android** (`MainActivity.kt`) shows `Toast.makeText(...)`.
3. **iOS** (`AppDelegate.swift`) renders an auto-dismissing overlay label
   (UIKit has no native Toast).

To change the channel or method name, update
`core/constants/app_constants.dart` **and** both native handlers to match.
