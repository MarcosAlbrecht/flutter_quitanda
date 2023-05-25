import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:quitanda_app/src/config/app_data.dart';
import 'package:quitanda_app/src/constants/endpoints.dart';
import 'package:quitanda_app/src/models/cart_item_model.dart';
import 'package:quitanda_app/src/models/item_model.dart';
import 'package:quitanda_app/src/pages/auth/controller/auth_controller.dart';
import 'package:quitanda_app/src/pages/cart/cart_result/cart_result.dart';
import 'package:quitanda_app/src/pages/cart/repository/cart_repository.dart';
import 'package:quitanda_app/src/services/http_manager.dart';
import 'package:quitanda_app/src/services/utils_services.dart';

class CartController extends GetxController {
  final cartRepository = CartRepository();
  final authController = Get.find<AuthController>();
  final utilServices = UtilServices();

  List<CartItemModel> cartItems = [];

  @override
  void onInit() {
    super.onInit();

    getCartItems();
  }

  double cartTotalPrice() {
    double total = 0;
    for (var item in cartItems) {
      total += (item.totalPrice() * item.quantity);
    }
    return total;
  }

  Future<bool> changeItemQuantity({
    required CartItemModel item,
    required int quantity,
  }) async {
    final result = await cartRepository.changeItemQuantity(
      token: authController.user.token!,
      cartItemId: item.id,
      quantity: quantity,
    );

    return result;
  }

  Future<void> getCartItems() async {
    final CartResult<List<CartItemModel>> result =
        await cartRepository.getCartItems(
      token: authController.user.token!,
      userId: authController.user.id!,
    );

    result.when(
      success: (data) {
        cartItems = data;
        update();
      },
      error: (message) {
        utilServices.showToast(message: message, isError: true);
      },
    );
  }

  int getItemIndex(ItemModel item) {
    return cartItems.indexWhere((itemInList) => itemInList.item.id == item.id);
  }

  Future<void> addItemToCart({
    required ItemModel item,
    int quantity = 1,
  }) async {
    int itemIndex = getItemIndex(item);

    if (itemIndex >= 0) {
      //ja existe na listagem do carrinho
      final product = cartItems[itemIndex];

      final result = await changeItemQuantity(
          item: product, quantity: (product.quantity + quantity));
      if (result) {
        cartItems[itemIndex].quantity += quantity;
      } else {
        utilServices.showToast(
            message: 'Ocorreu um erro ao alterar a quanitade do produto');
      }
    } else {
      //novo item no carrinho
      final CartResult<String> result = await cartRepository.addItemToCart(
        userId: authController.user.id!,
        token: authController.user.token!,
        productId: item.id,
        quantity: quantity,
      );

      result.when(
        success: (cartItemId) {
          cartItems.add(
            CartItemModel(
              id: cartItemId,
              item: item,
              quantity: quantity,
            ),
          );
        },
        error: (message) {
          utilServices.showToast(message: message, isError: true);
        },
      );
    }
    update();
  }
}
