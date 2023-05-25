import 'package:quitanda_app/src/config/app_data.dart';
import 'package:quitanda_app/src/constants/endpoints.dart';
import 'package:quitanda_app/src/models/cart_item_model.dart';
import 'package:quitanda_app/src/models/order_model.dart';
import 'package:quitanda_app/src/pages/cart/cart_result/cart_result.dart';
import 'package:quitanda_app/src/services/http_manager.dart';

class CartRepository {
  final _httpManager = HttpManager();

  Future<CartResult<List<CartItemModel>>> getCartItems(
      {required String token, required String userId}) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.getCartItems,
      method: HttpMethods.post,
      headers: {'X-Parse-Session-Token': token},
      body: {'user': userId},
    );

    if (result['result'] != null) {
      List<CartItemModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(CartItemModel.fromJson)
              .toList();
      return CartResult<List<CartItemModel>>.success(data);
    } else {
      return CartResult.error(
          'Ocorreu um erro ao recuperar os dados do carrinho');
    }
  }

  Future<CartResult<OrderModel>> checkoutCart(
      {required String token, required double total}) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.checkout,
      method: HttpMethods.post,
      body: {'total': total},
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    if (result['result'] != null) {
      final order = OrderModel.fromJson(result['result']);
      return CartResult<OrderModel>.success(order);
    } else {
      return CartResult.error('Não foi possível realizar o pedido');
    }
  }

  Future<bool> changeItemQuantity({
    required String token,
    required String cartItemId,
    required int quantity,
  }) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.changeItemQuantity,
      method: HttpMethods.post,
      body: {
        'cartItemId': cartItemId,
        'quantity': quantity,
      },
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    return result.isEmpty;
  }

  Future<CartResult<String>> addItemToCart({
    required String userId,
    required String token,
    required String productId,
    required int quantity,
  }) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.addItemToCart,
      method: HttpMethods.post,
      body: {
        'user': userId,
        'quantity': quantity,
        'productId': productId,
      },
      headers: {'X-Parse-Session-Token': token},
    );

    if (result['result'] != null) {
      //adicionar produto
      return CartResult<String>.success(result['result']['id']);
    } else {
      //erro
      return CartResult.error('Não foi possível adicionar item no carrinho');
    }
  }
}
