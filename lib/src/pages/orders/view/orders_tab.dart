import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitanda_app/src/pages/orders/controller/all_orders_controller.dart';
import 'package:quitanda_app/src/pages/orders/view/components/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: GetBuilder<AllOrdersController>(
        builder: (controller) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            itemBuilder: (_, int index) => OrderTile(
              order: controller.allOrders[index],
            ),
            itemCount: controller.allOrders.length,
            separatorBuilder: (_, int index) => const SizedBox(height: 10),
          );
        },
      ),
    );
  }
}
