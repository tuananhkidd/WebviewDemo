import 'package:get/get.dart';

import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';

part 'app_routes.dart';

/// Declares every navigable page together with its binding.
///
/// Each [GetPage] couples a route name (from [Routes]) to its [View] and its
/// [Bindings], so dependencies are injected lazily when the route is opened.
class AppPages {
  AppPages._();

  static const String initial = Routes.home;

  static final List<GetPage> routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
