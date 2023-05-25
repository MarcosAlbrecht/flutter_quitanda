import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:quitanda_app/src/models/order_model.dart';
import 'package:quitanda_app/src/services/utils_services.dart';

class PaymentDialog extends StatelessWidget {
  final OrderModel order;

  PaymentDialog({
    Key? key,
    required this.order,
  }) : super(key: key);

  final UtilServices utilServices = UtilServices();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        //Conteúdo
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //titulo
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Pagamento com Pix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //qrcode
                Image.memory(
                  utilServices.decodeQrCodeImage(order.qrCodeImage),
                  height: 200,
                  width: 200,
                ),
                //vencimento
                Text(
                  'Vencimento: ${utilServices.formatDateTime(order.overdueDateTime)}',
                  style: const TextStyle(fontSize: 12),
                ),

                //total
                Text(
                  'Total: ${utilServices.priceToCurrency(order.total)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //botao copia e cola
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(
                      width: 2,
                      color: Colors.green,
                    ),
                  ),
                  label: const Text(
                    'Copiar código Pix',
                    style: TextStyle(fontSize: 13),
                  ),
                  icon: const Icon(
                    Icons.copy,
                    size: 15,
                  ),
                  onPressed: () {
                    FlutterClipboard.copy(order.copyAndPaste);
                    utilServices.showToast(
                        message: 'QR Code copiado com sucesso');
                  },
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          )
        ],
      ),
    );
  }
}
