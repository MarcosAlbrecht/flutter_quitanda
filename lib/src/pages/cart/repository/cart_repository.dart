import 'package:quitanda_app/src/constants/endpoints.dart';
import 'package:quitanda_app/src/pages/cart/cart_result/cart_result.dart';
import 'package:quitanda_app/src/services/http_manager.dart';

class CartRepository {
  final _httpManager = HttpManager();

  Future getCartItems({required String token, required String userId}) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.getCartItems,
      method: HttpMethods.post,
      headers: {'X-Parse-Session-Token': token},
      body: {'user': userId},
    );

    if (result['result'] != null) {
      print(result['result']);
    } else {
      print('Ocorreu um erro ao resuperar os itens do carinho');
    }
  }
}
