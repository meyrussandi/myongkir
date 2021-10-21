import 'package:get/get.dart';

import '../controllers/cost_controller.dart';

class CostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CostController>(
      () => CostController(),
    );
  }
}
