import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quitanda_app/src/config/custom_colors.dart';
import 'package:quitanda_app/src/pages/base/controller/navigation_controller.dart';
import 'package:quitanda_app/src/pages/cart/controller/cart_controller.dart';
import 'package:quitanda_app/src/pages/common_widgets/app_name_widget.dart';
import 'package:quitanda_app/src/pages/common_widgets/custom_shimmer.dart';
import 'package:quitanda_app/src/pages/home/view/components/category_tile.dart';
// ignore: library_prefixes, unused_import
import 'package:quitanda_app/src/config/app_data.dart' as appData;
import 'package:quitanda_app/src/pages/home/view/components/item_tile.dart';
import 'package:quitanda_app/src/pages/home/controller/home_controller.dart';
import 'package:quitanda_app/src/services/utils_services.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GlobalKey<CartIconKey> globalKeyCartItem = GlobalKey<CartIconKey>();

  final searchController = TextEditingController();
  final navigationController = Get.find<NavigationController>();

  late Function(GlobalKey) runAddToCartAnimation;

  void itemSelectedCardAnimation(GlobalKey gkImage) {
    runAddToCartAnimation(gkImage);
  }

  final UtilServices utilServices = UtilServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const AppNameWidget(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              right: 15,
            ),
            child: GetBuilder<CartController>(
              builder: (controller) {
                return GestureDetector(
                  onTap: () {
                    navigationController.navigatePageView(NavigationTabs.cart);
                  },
                  child: Badge(
                    badgeStyle: BadgeStyle(
                      badgeColor: CustomColors.customContrastColor,
                    ),
                    badgeContent: Text(
                      controller.cartItems.length.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    child: AddToCartIcon(
                      key: globalKeyCartItem,
                      icon: Icon(
                        Icons.shopping_cart,
                        color: CustomColors.customSwatchColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      body: AddToCartAnimation(
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        gkCart: globalKeyCartItem,
        receiveCreateAddToCardAnimationMethod: (AddToCartAnimationMethod) {
          runAddToCartAnimation = AddToCartAnimationMethod;
        },
        child: Column(
          children: [
            //campo de pesquisa
            GetBuilder<HomeController>(
              builder: (controller) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      controller.searchTitle.value = value;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      hintText: 'Pesquise aqui...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: CustomColors.customContrastColor,
                        size: 21,
                      ),
                      suffixIcon: controller.searchTitle.isNotEmpty
                          ? IconButton(
                              onPressed: (() {
                                searchController.clear();
                                controller.searchTitle.value = '';
                                FocusScope.of(context).unfocus();
                              }),
                              icon: Icon(
                                Icons.close,
                                color: CustomColors.customContrastColor,
                                size: 21,
                              ),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            //categories
            GetBuilder<HomeController>(
              builder: (controller) {
                return Container(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  height: 40,
                  child: !controller.isCategoryLoading
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, int index) {
                            return CategoryTile(
                              onPressed: () {
                                controller.selectCategory(
                                    controller.allCategories[index]);
                              },
                              category: controller.allCategories[index].title,
                              isSelected: controller.allCategories[index] ==
                                  controller.currentCategory,
                            );
                          },
                          itemCount: controller.allCategories.length,
                          separatorBuilder: (_, int index) =>
                              const SizedBox(width: 10),
                        )
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              10,
                              (index) => Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    alignment: Alignment.center,
                                    child: CustomShimmer(
                                      height: 20,
                                      width: 80,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  )),
                        ),
                );
              },
            ),

            //grid
            GetBuilder<HomeController>(
              builder: (controller) {
                return Expanded(
                  child: !controller.isProductLoading
                      ? Visibility(
                          visible: (controller.currentCategory?.items ?? [])
                              .isNotEmpty,
                          replacement: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  color: CustomColors.customSwatchColor,
                                ),
                                const Text('Não há itens para apresentar'),
                              ]),
                          child: GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 9 / 11.5),
                            itemCount: controller.allProducts.length,
                            itemBuilder: (_, index) {
                              if (((index + 1) ==
                                      controller.allProducts.length) &&
                                  (!controller.isLastPage)) {
                                controller.loadMoreProducts();
                              }
                              return ItemTile(
                                item: controller.allProducts[index],
                                cartAnimationMethod: itemSelectedCardAnimation,
                              );
                            },
                          ),
                        )
                      : GridView.count(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 9 / 11.5,
                          children: List.generate(
                            10,
                            ((index) => CustomShimmer(
                                  height: double.infinity,
                                  width: double.infinity,
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
