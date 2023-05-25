import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitanda_app/src/config/app_data.dart' as appData;
import 'package:quitanda_app/src/config/custom_colors.dart';
import 'package:quitanda_app/src/models/cart_item_model.dart';
import 'package:quitanda_app/src/pages/cart/controller/cart_controller.dart';
import 'package:quitanda_app/src/pages/cart/view/components/cart_tile.dart';
import 'package:quitanda_app/src/services/utils_services.dart';

import '../../common_widgets/payment_dialog.dart';

class CartTab extends StatefulWidget {
  const CartTab({Key? key}) : super(key: key);

  @override
  State<CartTab> createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  final UtilServices utilServices = UtilServices();
  final cartController = Get.find<CartController>();

  double totalPrice = 0.0;

  double cartTotalPrice() {
    double total = 0.0;
    for (var item in appData.cartItems) {
      total += item.totalPrice();
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      body: Column(
        children: [
          //Lista de item do carrinho
          Expanded(
            child: GetBuilder<CartController>(
              builder: (controller) {
                if (controller.cartItems.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_shopping_cart,
                        size: 40,
                        color: CustomColors.customSwatchColor,
                      ),
                      const Text('Não há itens no carrinho'),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: controller.cartItems.length,
                  itemBuilder: (_, index) {
                    return CartTile(
                      cartItem: controller.cartItems[index],
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Total Geral',
                  style: TextStyle(fontSize: 12),
                ),
                GetBuilder<CartController>(
                  builder: (controller) {
                    return Text(
                      utilServices.priceToCurrency(
                        controller.cartTotalPrice(),
                      ),
                      style: TextStyle(
                        fontSize: 23,
                        color: CustomColors.customSwatchColor,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 50,
                  child: GetBuilder<CartController>(
                    builder: (controller) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.customSwatchColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: controller.isCheckoutLoading
                            ? null
                            : () async {
                                bool? result = await showOrderConfirmation();
                                if (result ?? false) {
                                  cartController.checkoutCart();
                                } else {
                                  utilServices.showToast(
                                      message: 'Pedido não confirmado!');
                                }
                              },
                        child: controller.isCheckoutLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Finalizar pedido',
                                style: TextStyle(fontSize: 18),
                              ),
                      );
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool?> showOrderConfirmation() {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Confirmação'),
          content: const Text('Deseja realmente concluir o pedido?'),
          actions: [
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
      context: context,
    );
  }
}
