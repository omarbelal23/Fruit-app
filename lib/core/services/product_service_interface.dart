import '../../features/product_details/data/product.dart';

/// Abstract interface for ProductService
/// Enables dependency injection and testability
abstract class ProductServiceInterface {
  /// Get all products from the backend
  Future<List<Product>> getAllProducts();

  /// Get products filtered by category
  Future<List<Product>> getProductsByCategory(String category);

  /// Get featured/organic products
  Future<List<Product>> getFeaturedProducts();

  /// Get a specific product by ID
  Future<Product?> getProductById(String productId);

  /// Search products by name or description
  Future<List<Product>> searchProducts(String query);

  /// Add sample products for development
  Future<void> addSampleProducts();
}
