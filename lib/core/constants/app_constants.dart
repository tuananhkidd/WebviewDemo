/// Application-wide constant identifiers that are not colors or strings.
class AppConstants {
  AppConstants._(); // Prevent instantiation.

  /// Platform channel name used to bridge Dart <-> native (Android/iOS).
  /// Must match the channel name registered on the native side.
  static const String nativeChannel = 'com.example.webview_demo/native';

  /// Method invoked on the native side to display a native toast.
  static const String showToastMethod = 'showToast';

  /// Persisted preference key for the selected theme mode.
  static const String themeModeKey = 'is_dark_mode';
}
