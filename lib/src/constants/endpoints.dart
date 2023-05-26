const String baseUrl = 'https://parseapi.back4app.com/functions';

abstract class EndPoints {
  static const signin = '$baseUrl/login';
  static const signup = '$baseUrl/signup';
  static const validateToken = '$baseUrl/validate-token';
  static const resetPassword = '$baseUrl/reset-password';
  static const getAllCategories = '$baseUrl/get-category-list';
  static const getAllProducts = '$baseUrl/get-product-list';
  static const getCartItems = '$baseUrl/get-cart-items';
  static const changeItemQuantity = '$baseUrl/modify-item-quantity';
  static const addItemToCart = '$baseUrl/add-item-to-cart';
  static const checkout = '$baseUrl/checkout';
  static const getAllOrders = '$baseUrl/get-orders';
  static const getOrderItems = '$baseUrl/get-order-items';
  static const changePassword = '$baseUrl/change-password';
}
