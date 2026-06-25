import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'core/bindings/initial_binding.dart';
import 'core/config/env_config.dart';
import 'core/theme/theme_config.dart';
import 'core/theme/theme_service.dart';
import 'core/translations/app_translations.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment file selected at build time via --dart-define.
  // Defaults to `.env.develop` when no flag is supplied.
  const envFile = String.fromEnvironment('ENV_FILE', defaultValue: '.env.develop');
  await dotenv.load(fileName: envFile);

  // Register core singletons (DioClient, services, ThemeService) up front so
  // they are available the moment the first frame builds.
  InitialBinding().dependencies();
  runApp(MyApp());
}

/// Root widget configuring routing, DI, i18n and theming through GetX.
class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables — title is dynamic (EnvConfig).
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: EnvConfig.appName,
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

