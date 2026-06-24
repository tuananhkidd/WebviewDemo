import 'package:flutter/services.dart';

import '../constants/app_constants.dart';
import 'logger.dart';

/// Bridge between Dart and the native Android/iOS layers.
///
/// This is the single place that talks to the platform [MethodChannel].
/// It is used to fulfil the requirement: *"share the API result to native
/// and display it as a toast on the native side"*.
class NativeBridge {
  NativeBridge._(); // Prevent instantiation.

  static const MethodChannel _channel =
      MethodChannel(AppConstants.nativeChannel);

  /// Sends [message] to the native platform, which shows it as a native toast
  /// (Android `Toast` / a custom toast view on iOS).
  ///
  /// Failures are logged but never thrown, so a missing native handler can
  /// never crash the Flutter UI.
  static Future<void> showNativeToast(String message) async {
    try {
      await _channel.invokeMethod<void>(
        AppConstants.showToastMethod,
        {'message': message},
      );
    } on PlatformException catch (e, s) {
      AppLogger.e('Failed to show native toast', e, s);
    }
  }
}
