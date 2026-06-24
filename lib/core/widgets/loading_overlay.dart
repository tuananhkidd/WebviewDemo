import 'package:flutter/material.dart';

import 'app_loading.dart';

/// Reusable overlay that places an [AppLoading] on top of [child] while
/// [isLoading] is `true`, dimming and blocking interaction with the content
/// underneath.
///
/// Ideal for forms / detail screens that should stay visible but locked during
/// a request:
///
/// ```dart
/// Obx(() => LoadingOverlay(
///       isLoading: controller.isSaving.value,
///       child: MyForm(),
///     ));
/// ```
class LoadingOverlay extends StatelessWidget {
  /// Whether the loading layer is shown.
  final bool isLoading;

  /// The content displayed underneath the overlay.
  final Widget child;

  /// Optional message shown beneath the spinner.
  final String? message;

  /// Scrim color painted over the content while loading.
  final Color barrierColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.barrierColor = Colors.black45,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          // Absorb taps so the locked content cannot be interacted with.
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: barrierColor,
                child: AppLoading(
                  showMessage: message != null,
                  message: message,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
