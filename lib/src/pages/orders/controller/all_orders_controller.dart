import 'package:get/get.dart';
import 'package:quitanda_app/src/models/order_model.dart';
import 'package:quitanda_app/src/pages/auth/controller/auth_controller.dart';
import 'package:quitanda_app/src/pages/orders/orders_result/orders_result.dart';
import 'package:quitanda_app/src/pages/orders/repository/orders_repository.dart';
import 'package:quitanda_app/src/services/utils_services.dart';

class AllOrdersController extends GetxController {
  List<OrderModel> allOrders = [];

  final authController = Get.find<AuthController>();

  final ordersRepository = OrdersRepository();

  final utilServices = UtilServices();

  @override
  void onInit() {
    super.onInit();
    getAllOrders();
  }

  Future<void> getAllOrders() async {
    OrdersResult<List<OrderModel>> result = await ordersRepository.getAllOrders(
      userId: authController.user.id!,
      token: authController.user.token!,
    );

    result.when(
      success: (orders) {
        print(orders);
        allOrders = orders;
      },
      error: (message) {
        utilServices.showToast(message: message, isError: true);
      },
    );
  }
}
