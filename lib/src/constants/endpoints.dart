const String baseUrl = 'https://parseapi.back4app.com/functions';

abstract class EndPoints {
  static const signin = '$baseUrl/login';
  static const signup = '$baseUrl/signup';
  static const validateToken = '$baseUrl/validate-token';
  static const resetPassword = '$baseUrl/reset-password';
}
