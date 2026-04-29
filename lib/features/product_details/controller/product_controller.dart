import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/product.dart';
import '../../../core/services/product_service_interface.dart';
import '../../../core/constants.dart';
import '../../../core/utils/logger.dart';

class ProductController extends GetxController {
  late ProductServiceInterface _productService;

  // Reactive variables
  final RxList<Product> _allProducts = <Product>[].obs; // ✅ source of truth
  final RxList<Product> _filteredProducts = <Product>[].obs;
  final RxList<Product> _featuredProducts = <Product>[].obs;
  final RxList<Product> _searchResults = <Product>[].obs;
  final RxList<String> _categories = <String>[].obs; // ✅ مش computed كل مرة
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _selectedCategory = 'All'.obs;
  final RxString _searchQuery = ''.obs;

  // ✅ Getters ترجع Rx مباشرة عشان Obx يتابعها صح
  RxList<Product> get products =>
      _searchQuery.isNotEmpty ? _searchResults : _filteredProducts;
  RxList<Product> get featuredProducts => _featuredProducts;
  RxList<Product> get searchResults => _searchResults;
  RxList<String> get categories => _categories;
  RxBool get isLoading => _isLoading; // ✅ مش .value — عشان Obx يشتغل
  String get errorMessage => _errorMessage.value;
  String get selectedCategory => _selectedCategory.value;
  String get searchQuery => _searchQuery.value;

  List<Product> getProductsByCategory(String category) {
    if (category == 'All') return _allProducts;
    return _allProducts.where((p) => p.category == category).toList();
  }

  @override
  void onInit() {
    super.onInit();
    try {
      _productService = Get.find<ProductServiceInterface>();
      // ✅ await بالترتيب لتجنب race condition
      _initializeData();
    } catch (e) {
      AppLogger.error('Error initializing ProductController', e);
      _errorMessage.value = 'Failed to initialize products';
    }
  }

  // ✅ نقطة دخول واحدة بالترتيب الصح
  Future<void> _initializeData() async {
    await loadProducts();
    await loadFeaturedProducts();

    // بس لو ما فيش products، نضيف sample — بدون تعارض
    if (_allProducts.isEmpty) {
      await addSampleProducts(silent: true);
    }
  }

  // ✅ بتحدّث _allProducts و _filteredProducts و _categories مع بعض
  void _applyProducts(List<Product> products) {
    _allProducts.assignAll(products);

    // تحديث الـ categories
    final cats = ['All', ...products.map((p) => p.category).toSet()];
    _categories.assignAll(cats);

    // إعادة تطبيق الفلتر الحالي
    _applyCurrentFilter();
  }

  void _applyCurrentFilter() {
    final filtered = getProductsByCategory(_selectedCategory.value);
    _filteredProducts.assignAll(filtered);
  }

  Future<void> loadProducts() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final products = await _productService.getAllProducts();
      _applyProducts(products);
    } catch (e) {
      _errorMessage.value = kGenericError;
      AppLogger.error('Error loading products', e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadFeaturedProducts() async {
    try {
      final featured = await _productService.getFeaturedProducts();
      _featuredProducts.assignAll(featured);
    } catch (e) {
      AppLogger.error('Error loading featured products', e);
    }
  }

  // ✅ مش بيمسح _allProducts — بيفلتر منها بس
  Future<void> loadProductsByCategory(String category) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _selectedCategory.value = category;

      if (category == 'All') {
        // عندنا البيانات بالفعل — مش محتاجين network call
        _filteredProducts.assignAll(_allProducts);
      } else {
        final products = await _productService.getProductsByCategory(category);
        _filteredProducts.assignAll(products);
      }
    } catch (e) {
      _errorMessage.value = kGenericError;
      AppLogger.error('Error loading products by category', e);
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> searchProducts(String query) async {
    _searchQuery.value = query;

    if (query.isEmpty) {
      _searchResults.clear();
      return;
    }

    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      final results = await _productService.searchProducts(query);
      _searchResults.assignAll(results);
    } catch (e) {
      _errorMessage.value = kGenericError;
      AppLogger.error('Error searching products', e);
    } finally {
      _isLoading.value = false;
    }
  }

  void clearSearch() {
    _searchQuery.value = '';
    _searchResults.clear();
  }

  Product? getProductById(String productId) {
    return _allProducts.firstWhereOrNull((p) => p.id == productId);
  }

  // ✅ silent=true بيتجنب snackbar لما بنستدعيه داخلياً
  Future<void> addSampleProducts({bool silent = false}) async {
    try {
      await _productService.addSampleProducts();
      await loadProducts();
      if (!silent)
        _showSnackbar('Success', 'Sample products added!', isError: false);
    } catch (e) {
      AppLogger.error('Error adding sample products', e);
      if (!silent)
        _showSnackbar('Error', 'Failed to add sample products', isError: true);
    }
  }

  void goToProductDetails(Product product) {
    Get.toNamed('/product/${product.id}', arguments: product);
  }

  // ✅ helper مركزي للـ snackbars بدل تكرار الألوان
  void _showSnackbar(String title, String message, {required bool isError}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? kErrorColor : kSuccessColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
    );
  }
}
