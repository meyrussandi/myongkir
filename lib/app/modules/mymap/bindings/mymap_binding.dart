import 'package:get/get.dart';

import '../controllers/mymap_controller.dart';

class MymapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MymapController>(
      () => MymapController(),
    );
  }
}
