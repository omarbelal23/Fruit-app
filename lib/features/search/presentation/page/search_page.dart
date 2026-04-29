import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants.dart';
import '../../../product_details/controller/product_controller.dart';
import '../../../cart/presentation/controllar/cart_controller.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../home/presentation/widgets/product_card/product_card.dart';
import '../../../product_details/data/product.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ProductController _productController = Get.find<ProductController>();
  final CartController _cartController = Get.find<CartController>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  // ✅ RxString عشان Obx يتابعها — بدل قراءة _searchController.text مباشرة
  final RxString _query = ''.obs;

  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 500);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _handleSearch(String query) {
    // ✅ نحدث الـ Rx source الموثوق
    _query.value = query.trim();

    _debouncer.run(() {
      if (query.trim().isNotEmpty) {
        _productController.searchProducts(query.trim());
      } else {
        _productController.clearSearch();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _query.value = '';
    _debouncer.cancel();
    _productController.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
        backgroundColor: kMainColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: kMainColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        style: const TextStyle(color: Colors.white),
        onChanged: _handleSearch,
        decoration: InputDecoration(
          hintText: kSearchHint,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withValues(alpha: 0.7),
          ),
          // ✅ Obx يراقب _query (RxString) مش _searchController
          suffixIcon: Obx(() {
            return _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: _clearSearch,
                  )
                : const SizedBox.shrink();
          }),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }

  // ✅ Obx واحد بس يراقب كل الـ state
  Widget _buildBody() {
    return Obx(() {
      final query = _query.value;

      if (query.isEmpty) return _buildSearchSuggestions();

      // ✅ .value صح — لأن isLoading بيرجع RxBool
      if (_productController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kMainColor),
          ),
        );
      }

      final results = _productController.searchResults;

      if (results.isEmpty) return _buildNoResults(query);

      return _buildSearchResults(results);
    });
  }

  Widget _buildSearchSuggestions() {
    const suggestions = [
      'Apple', 'Banana', 'Orange', 'Tomato', 'Organic', 'Fresh',
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: kTextLightColor),
            const SizedBox(height: 16),
            const Text(
              'Search for products',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Find fruits, vegetables, and more...',
              style: TextStyle(fontSize: 16, color: kTextLightColor, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: suggestions.map((s) {
                return ActionChip(
                  label: Text(s),
                  onPressed: () {
                    _searchController.text = s;
                    _handleSearch(s);
                  },
                  backgroundColor: kSecondaryColor.withValues(alpha: 0.1),
                  labelStyle: TextStyle(color: kSecondaryColor),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: kTextLightColor),
            const SizedBox(height: 16),
            const Text(
              'No products found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t find any products matching "$query"',
              style: TextStyle(fontSize: 16, color: kTextLightColor, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              // ✅ بيمسح الـ TextField والـ controller مع بعض
              onPressed: _clearSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: kMainColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Clear Search'),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ typed List<Product> بدل List بدون type
  Widget _buildSearchResults(List<Product> products) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${products.length} results found',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kTextColor,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: _handleSort,
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'name', child: Text('Sort by Name')),
                  PopupMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                  PopupMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                  PopupMenuItem(value: 'rating', child: Text('Highest Rated')),
                ],
                child: Row(
                  children: [
                    Text('Sort', style: TextStyle(fontSize: 14, color: kTextLightColor)),
                    Icon(Icons.arrow_drop_down, color: kTextLightColor, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                key: ValueKey(product.id),
                product: product,
                onTap: () => _productController.goToProductDetails(product),
                onAddToCart: () => _cartController.addToCart(product),
              );
            },
          ),
        ),
      ],
    );
  }

  // ✅ منفصلة وجاهزة للتطبيق
  void _handleSort(String value) {
    final sorted = List<Product>.from(_productController.searchResults);
    switch (value) {
      case 'name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
      case 'price_low':
        sorted.sort((a, b) => a.price.compareTo(b.price));
      case 'price_high':
        sorted.sort((a, b) => b.price.compareTo(a.price));
      case 'rating':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
    }
    _productController.searchResults.assignAll(sorted);
  }
}