import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitanda_app/src/pages/base/controller/navigation_controller.dart';
import 'package:quitanda_app/src/pages/cart/view/cart_tab.dart';
import 'package:quitanda_app/src/pages/home/view/home_tab.dart';

import 'package:quitanda_app/src/pages/orders/orders_tab.dart';

import '../profile/profile_tab.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    final navigationController = Get.find<NavigationController>();

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: navigationController.pageController,
        children: const [
          HomeTab(),
          CartTab(),
          OrdersTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            onTap: (index) {
              navigationController.navigatePageView(index);
            },
            currentIndex: navigationController.currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.green,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.black,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Carrinho',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Pedidos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Perfil',
              ),
            ],
          )),
    );
  }
}
