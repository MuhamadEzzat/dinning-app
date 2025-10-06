import 'package:fluttertask/app/modules/dining/dining_controller.dart';
import 'package:fluttertask/app/modules/profile/profile_controller.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<DiningController>(() => DiningController());
  }
}
