import 'package:get/get.dart';

/// Application localization using GetX [Translations].
///
/// `en` (English) is the default locale. To add a new language, add a new entry
/// to [keys] (e.g. `'vi'`) and provide the same set of keys.
///
/// Usage in widgets: `Text(LocaleKeys.appTitle.tr)`.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          LocaleKeys.appTitle: 'Webview Demo',
          LocaleKeys.homeTitle: 'Home',
          LocaleKeys.openWebsite: 'Open Website',
          LocaleKeys.toggleTheme: 'Toggle Theme',
          LocaleKeys.loading: 'Loading...',
          LocaleKeys.retry: 'Retry',
          LocaleKeys.todoTitleLabel: 'Latest Todo Title',
        },
        // Example second language. Remove or extend as needed.
        'vi': {
          LocaleKeys.appTitle: 'Webview Demo',
          LocaleKeys.homeTitle: 'Trang chủ',
          LocaleKeys.openWebsite: 'Mở Website',
          LocaleKeys.toggleTheme: 'Đổi giao diện',
          LocaleKeys.loading: 'Đang tải...',
          LocaleKeys.retry: 'Thử lại',
          LocaleKeys.todoTitleLabel: 'Tiêu đề Todo mới nhất',
        },
      };
}

/// Type-safe translation keys to avoid magic strings at call sites.
class LocaleKeys {
  LocaleKeys._();

  static const String appTitle = 'app_title';
  static const String homeTitle = 'home_title';
  static const String openWebsite = 'open_website';
  static const String toggleTheme = 'toggle_theme';
  static const String loading = 'loading';
  static const String retry = 'retry';
  static const String todoTitleLabel = 'todo_title_label';
}
