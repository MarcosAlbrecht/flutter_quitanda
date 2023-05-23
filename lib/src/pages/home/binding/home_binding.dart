import 'package:get/get.dart';
import 'package:quitanda_app/src/pages/home/controller/home_controller.dart';

class HomeBindig extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
