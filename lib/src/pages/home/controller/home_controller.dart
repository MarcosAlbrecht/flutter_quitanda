import 'package:get/get.dart';
import 'package:quitanda_app/src/models/category_model.dart';
import 'package:quitanda_app/src/pages/home/repository/home_repository.dart';
import 'package:quitanda_app/src/pages/home/result/home_result.dart';
import 'package:quitanda_app/src/services/utils_services.dart';

class HomeController extends GetxController {
  final homeRepository = HomeRepository();
  final utilServices = UtilServices();
  CategoryModel? currentCategory;

  List<CategoryModel> allCategories = [];

  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  void selectCategory(CategoryModel category) {
    currentCategory = category;
    update();
  }

  Future<void> getAllCategories() async {
    setLoading(true);
    HomeResult<CategoryModel> homeResult =
        await homeRepository.getAllCategories();
    setLoading(false);

    homeResult.when(
      success: (data) {
        allCategories.assignAll(data);
        print('All categories: $allCategories');

        if (allCategories.isEmpty) {
          return;
        }

        selectCategory(allCategories.first);
      },
      error: (message) {
        utilServices.showToast(message: message, isError: true);
      },
    );
  }
}
