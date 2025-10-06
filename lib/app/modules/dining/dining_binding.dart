import 'package:get/get.dart';
import 'dining_controller.dart';

class DiningBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiningController>(() => DiningController());
  }
}

