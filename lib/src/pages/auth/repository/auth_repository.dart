import 'dart:ffi';

import 'package:quitanda_app/src/config/app_data.dart';
import 'package:quitanda_app/src/constants/endpoints.dart';
import 'package:quitanda_app/src/models/user_model.dart';
import 'package:quitanda_app/src/pages/auth/repository/auth_errors.dart'
    as authErrors;
import 'package:quitanda_app/src/pages/auth/result/auth_result.dart';
import 'package:quitanda_app/src/services/http_manager.dart';

class AuthRepository {
  final HttpManager _httpManager = HttpManager();

  AuthResult handleUserOrError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      //print(result['result']);
      final user = UserModel.fromJson(result['result']);
      return AuthResult.success(user);
    } else {
      return AuthResult.error(authErrors.authErrorString(result['error']));
    }
  }

  //Realiza o login com o token salvo
  Future<AuthResult> validateToken(String token) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.validateToken,
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
    );

    return handleUserOrError(result);
  }

  //Realiza o login com email e senha
  Future signIn({required String email, required String password}) async {
    final result = await _httpManager.restRequest(
      method: HttpMethods.post,
      url: EndPoints.signin,
      body: {
        'email': email,
        'password': password,
      },
    );

    return handleUserOrError(result);
  }

  //realiza a criação do usuário
  Future<AuthResult> signUp(UserModel user) async {
    final result = await _httpManager.restRequest(
      url: EndPoints.signup,
      method: HttpMethods.post,
      body: user.toJson(),
    );
    return handleUserOrError(result);
  }

  Future<void> resetPassword(String email) async {
    await _httpManager.restRequest(
      url: EndPoints.resetPassword,
      method: HttpMethods.post,
      body: {'email': email},
    );
  }
}
