import 'package:get/get.dart';

import '../../data/providers/todo_provider.dart';
import '../../data/services/todo_service.dart';
import '../network/dio_client.dart';
import '../theme/theme_service.dart';

/// Registers app-wide singletons before the first route is shown.
///
/// Wired into `GetMaterialApp(initialBinding: InitialBinding())`. Feature
/// bindings (e.g. `HomeBinding`) only register feature-scoped controllers.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core services kept alive for the whole app lifecycle.
    Get.put<ThemeService>(ThemeService(), permanent: true);

    // Networking stack: DioClient -> Provider -> Service.
    Get.put<DioClient>(DioClient(), permanent: true);
    Get.put<TodoProvider>(TodoProvider(Get.find()), permanent: true);
    Get.put<TodoService>(TodoService(Get.find()), permanent: true);
  }
}
