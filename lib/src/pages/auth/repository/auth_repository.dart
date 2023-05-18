import 'package:quitanda_app/src/constants/endpoints.dart';
import 'package:quitanda_app/src/services/http_manager.dart';

class AuthRepository {
  final HttpManager _httpManager = HttpManager();
  Future signIn({required String email, required String password}) async {
    final result = await _httpManager.restRequest(
      method: HttpMethods.post,
      url: EndPoints.signin,
      body: {
        "email": email,
        "password": password,
      },
    );

    if (result['result'] != null) {
      print('Sigin funcionou');
      print(result['result']);
    } else {
      print(result['error']);
    }
  }
}
