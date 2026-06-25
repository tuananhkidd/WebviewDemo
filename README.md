# Webview Demo — Flutter Base Project

A scalable, production-oriented Flutter starter built with **GetX** (state
management, routing, dependency injection) and **Dio** (networking). It ships
with internationalization, light/dark theming, a feature-based folder structure,
an in-app WebView, a shared REST API layer, a **native toast bridge**
(Android `Toast` / iOS overlay) driven through a `MethodChannel`, and
**multi-environment support** (develop / staging / release) via `flutter_dotenv`.

---

## ✨ Features

| Area | Implementation |
|------|----------------|
| State / Routing / DI | `get` (GetX) — `GetMaterialApp`, `GetPage`, `Bindings`, `GetxController` |
| Networking | `dio` — Base API client (`DioClient`) with a global `ApiInterceptor` (token injection, request/response logging, error mapping) |
| i18n | GetX `Translations` — English (`en`) default + `vi` example |
| Theming | Light & Dark `ThemeData` + `ThemeService.toggleTheme()` |
| WebView | `webview_flutter` loading the company website |
| Native bridge | `MethodChannel` sends the API result to native Android/iOS, shown as a native toast |
| Multi-env | `flutter_dotenv` — `.env.develop`, `.env.staging`, `.env.release` |

---

## 🔧 Environments

The project supports **three** environments. Each has its own `.env.*` file at the project root:

| Key | `.env.develop` | `.env.staging` | `.env.release` |
|-----|---------------|---------------|----------------|
| `ENV` | `develop` | `staging` | `release` |
| `APP_NAME` | Webview Demo [DEV] | Webview Demo [STG] | Webview Demo |
| `BASE_URL` | `https://jsonplaceholder.typicode.com` | `https://jsonplaceholder.typicode.com` | `https://jsonplaceholder.typicode.com` |
| `WEBSITE_URL` | `https://www.sgcarmart.com` | `https://www.sgcarmart.com` | `https://www.sgcarmart.com` |
| `ENABLE_LOGGING` | `true` | `true` | `false` |

### How it works

1. `main()` reads the compile-time constant `ENV_FILE` (via `--dart-define`).
2. `flutter_dotenv` loads the matching file (defaults to `.env.develop`).
3. `EnvConfig` (`lib/core/config/env_config.dart`) exposes typed getters
   (`baseUrl`, `appName`, `enableLogging`, …) that the rest of the app uses.
4. `ApiEndpoints` and `AppLogger` read from `EnvConfig` instead of hardcoded values.

### Adding / changing env values

1. Add the new key to **all three** `.env.*` files.
2. Add a getter in `EnvConfig`:
   ```dart
   static String get myNewValue => dotenv.get('MY_NEW_VALUE');
   ```
3. Use `EnvConfig.myNewValue` anywhere in the app.

---

## 🚀 Running the Project

```bash
# 1. Install dependencies
flutter pub get

# 2. Run with the DEVELOP environment (default)
flutter run
# or explicitly:
flutter run --dart-define=ENV_FILE=.env.develop

# 3. Run with STAGING
flutter run --dart-define=ENV_FILE=.env.staging

# 4. Run with RELEASE (production build)
flutter run --release --dart-define=ENV_FILE=.env.release

# Platform-specific
flutter run -d ios --dart-define=ENV_FILE=.env.staging
flutter run -d android --dart-define=ENV_FILE=.env.develop
```

### Convenience scripts

```bash
# From the project root:
./scripts/run_dev.sh          # develop
./scripts/run_staging.sh      # staging
./scripts/run_release.sh      # release (--release flag included)

# Pass extra flags:
./scripts/run_dev.sh -d ios
```

### Static analysis & tests

```bash
flutter analyze
flutter test
```

> Requires Flutter 3.5+ (Dart 3.5+). Tested with Flutter 3.35.

### What happens on launch

1. `main()` loads the `.env.*` file via `flutter_dotenv`.
2. `InitialBinding` registers the `DioClient`, providers, services and `ThemeService`.
3. `HomeController.onInit()` calls the shared REST function
   (`{BASE_URL}/todos/1`).
4. On success, the todo `title` is rendered in a card **and** sent to the native
   layer via `MethodChannel`, which shows it as a **native toast** on both
   Android and iOS.
5. Tap **Open Website** to load `{WEBSITE_URL}` in the in-app WebView.

---

## 🗂 Folder Structure

```text
lib/
├── main.dart                       # App entry point (loads .env, GetMaterialApp, i18n, theme, routes)
│
├── core/                           # Shared, feature-agnostic building blocks
│   ├── bindings/
│   │   └── initial_binding.dart    # App-wide singletons (DioClient, services, ThemeService)
│   ├── config/
│   │   └── env_config.dart         # EnvConfig — typed getters for .env values
│   ├── constants/
│   │   ├── api_endpoints.dart      # Base URL (from EnvConfig), paths, timeouts
│   │   ├── app_colors.dart         # Color palette
│   │   └── app_constants.dart      # Channel names, method names, pref keys
│   ├── network/
│   │   ├── dio_client.dart         # Base API client (configured Dio)
│   │   └── api_interceptor.dart    # Token / logging / error interceptor
│   ├── theme/
│   │   ├── theme_config.dart       # Light & Dark ThemeData
│   │   └── theme_service.dart      # GetX theme switcher
│   ├── translations/
│   │   └── app_translations.dart   # GetX Translations + LocaleKeys
│   └── utils/
│       ├── logger.dart             # Debug-only logging (gated by EnvConfig.enableLogging)
│       └── native_bridge.dart      # Dart -> native MethodChannel wrapper
│
├── data/                           # Data sources
│   ├── models/
│   │   └── todo_model.dart         # Typed model (fromJson/toJson)
│   ├── providers/
│   │   └── todo_provider.dart      # Raw API calls via DioClient
│   └── services/
│       └── todo_service.dart       # Shared, cross-platform REST function
│
├── modules/                        # Feature modules (View + Controller + Binding)
│   └── home/
│       ├── home_binding.dart
│       ├── home_controller.dart
│       ├── home_view.dart
│       └── widgets/
│           └── todo_card.dart      # Extracted sub-widget (shallow nesting)
│
└── routes/
    ├── app_routes.dart             # Route name constants (Routes)
    └── app_pages.dart              # GetPage declarations + bindings

# Environment files (project root)
.env.develop                        # DEV config
.env.staging                        # STG config
.env.release                        # PROD config

# Convenience scripts
scripts/
├── run_dev.sh
├── run_staging.sh
└── run_release.sh
```

**Native layer**

```text
android/app/src/main/kotlin/com/example/webview_demo/MainActivity.kt   # Android Toast handler
ios/Runner/AppDelegate.swift                                           # iOS native toast handler
android/app/src/main/AndroidManifest.xml                               # INTERNET permission
```

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
  entry point: base URL (from `EnvConfig`), timeouts, JSON headers, interceptors.
- `ApiInterceptor` (`core/network/api_interceptor.dart`) handles:
  - **Token injection** — supply a `tokenProvider` callback to attach
    `Authorization: Bearer <token>` to every request.
  - **Logging** — request/response/error logs gated by `EnvConfig.enableLogging`.
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
