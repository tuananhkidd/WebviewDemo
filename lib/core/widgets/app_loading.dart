import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../translations/app_translations.dart';

/// Base, reusable loading indicator for the whole app.
///
/// Use this everywhere a loading state is shown so the spinner style, sizing
/// and optional message stay consistent across screens.
///
/// ```dart
/// const AppLoading();                       // simple centered spinner
/// const AppLoading(showMessage: true);      // spinner + localized text
/// AppLoading(size: 24, color: Colors.white) // inline / custom
/// ```
class AppLoading extends StatelessWidget {
  /// Diameter of the spinner.
  final double size;

  /// Stroke thickness of the spinner.
  final double strokeWidth;

  /// Optional spinner color. Defaults to the theme's primary color.
  final Color? color;

  /// Whether to render a text label under the spinner.
  final bool showMessage;

  /// Custom label. Falls back to the localized "loading" string.
  final String? message;

  const AppLoading({
    super.key,
    this.size = 36,
    this.strokeWidth = 3,
    this.color,
    this.showMessage = false,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final spinner = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: color != null ? AlwaysStoppedAnimation<Color>(color!) : null,
      ),
    );

    if (!showMessage) return Center(child: spinner);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          spinner,
          const SizedBox(height: 12),
          Text(message ?? LocaleKeys.loading.tr),
        ],
      ),
    );
  }
}
