import 'package:get/get.dart';

import 'home_controller.dart';

/// Injects [HomeController] when the Home route is opened.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // TodoService is a permanent singleton (see InitialBinding); HomeController
    // resolves it via Get.find().
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
