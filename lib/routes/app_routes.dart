// Route name constants. Keeping these as strings in one place avoids typos and
// makes navigation refactors safe.
part of 'app_pages.dart';

/// Centralized route names used with `Get.toNamed(...)`.
abstract class Routes {
  Routes._();

  static const String home = '/home';
}
