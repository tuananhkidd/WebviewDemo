import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_binding.dart';
import 'core/theme/theme_config.dart';
import 'core/theme/theme_service.dart';
import 'core/translations/app_translations.dart';
import 'routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Register core singletons (DioClient, services, ThemeService) up front so
  // they are available the moment the first frame builds.
  InitialBinding().dependencies();
  runApp(const MyApp());
}

/// Root widget configuring routing, DI, i18n and theming through GetX.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Webview Demo',
      debugShowCheckedModeBanner: false,

      // Routing.
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      // Internationalization. English is the default/fallback locale.
      translations: AppTranslations(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),

      // Theming. ThemeService (registered above) drives the active mode.
      theme: ThemeConfig.light,
      darkTheme: ThemeConfig.dark,
      themeMode: ThemeService.to.themeMode,
    );
  }
}
