import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quitanda_app/src/models/cart_item_model.dart';
import 'package:quitanda_app/src/models/order_model.dart';
import 'package:quitanda_app/src/pages/common_widgets/payment_dialog.dart';
import 'package:quitanda_app/src/pages/orders/controller/order_controller.dart';
import 'package:quitanda_app/src/services/utils_services.dart';

import 'order_status_widget.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;

  OrderTile({
    Key? key,
    required this.order,
  }) : super(key: key);

  final UtilServices utilServices = UtilServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: GetBuilder<OrderController>(
            init: OrderController(order),
            global: false,
            builder: (controller) {
              return ExpansionTile(
                //initiallyExpanded: order.status == 'preparing_purchase',
                onExpansionChanged: (value) {
                  if (value && order.items.isEmpty) {
                    controller.getOrderItems();
                  }
                },
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pedido: ${order.id}'),
                    Text(
                      utilServices.formatDateTime(order.createdDateTime!),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                children: controller.isLoading
                    ? [
                        Container(
                          height: 80,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                      ]
                    : [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              //Lista de produtos
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 150,
                                  child: ListView(
                                    children: order.items.map(
                                      (orderItem) {
                                        return _OrderItemWidget(
                                          utilServices: utilServices,
                                          orderItem: orderItem,
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ),
                              //Divisao
                              VerticalDivider(
                                color: Colors.grey.shade300,
                                thickness: 2,
                                width: 8,
                              ),
                              //Status do pedido
                              Expanded(
                                flex: 2,
                                child: OrderStatusWidget(
                                  isOverdue: order.overdueDateTime
                                      .isBefore(DateTime.now()),
                                  status: order.status,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Total Geral
                        Text.rich(
                          TextSpan(
                            style: const TextStyle(fontSize: 20),
                            children: [
                              const TextSpan(
                                text: 'Total ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: utilServices.priceToCurrency(order.total),
                              ),
                            ],
                          ),
                        ),
                        //Botao Pagamento
                        Visibility(
                          visible: order.status == 'pending_payment' &&
                              !order.isOverDue,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: Image.asset('assets/app_images/pix.png',
                                height: 18),
                            label: const Text('Ver QR Code Pix'),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return PaymentDialog(order: order);
                                },
                              );
                            },
                          ),
                        )
                      ],
              );
            },
          )),
    );
  }
}

class _OrderItemWidget extends StatelessWidget {
  const _OrderItemWidget({
    Key? key,
    required this.utilServices,
    required this.orderItem,
  }) : super(key: key);

  final UtilServices utilServices;

  final CartItemModel orderItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '${orderItem.quantity} ${orderItem.item.unit} ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(orderItem.item.itemName),
          ),
          Text(
            utilServices.priceToCurrency(
              orderItem.totalPrice(),
            ),
          )
        ],
      ),
    );
  }
}
