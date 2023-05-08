import 'package:flutter/material.dart';
import 'package:quitanda_app/src/config/app_data.dart';
import 'package:quitanda_app/src/config/custom_colors.dart';

import 'package:quitanda_app/src/models/cart_item_model.dart';
import 'package:quitanda_app/src/services/utils_services.dart';

import '../../common_widgets/quantity_widget.dart';

class CartTile extends StatelessWidget {
  final CartItemModel cartItem;
  final UtilServices utilServices = UtilServices();

  CartTile({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Image.asset(
          cartItem.item.imageUrl,
          height: 60,
          width: 60,
        ),
        title: Text(
          cartItem.item.itemName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          utilServices.priceToCurrency(cartItem.totalPrice()),
          style: TextStyle(
            color: CustomColors.customSwatchColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: QuantityWidget(
          result: (quantity) {},
          suffixText: cartItem.item.unit,
          value: cartItem.quantity,
        ),
      ),
    );
  }
}
