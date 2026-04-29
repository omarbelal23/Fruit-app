import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/product_details/data/product.dart';
import '../constants.dart';
import '../utils/logger.dart';
import 'product_service_interface.dart';

class ProductService implements ProductServiceInterface {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(kProductsCollection)
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        final productData = Map<String, dynamic>.from(data);
        productData['id'] = doc.id;
        return Product.fromJson(productData);
      }).toList();
    } catch (e) {
      AppLogger.error('Error getting products', e);
      return [];
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      Query query = _firestore.collection(kProductsCollection);

      if (category != 'All') {
        query = query.where('category', isEqualTo: category);
      }

      final querySnapshot = await query.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final productData = Map<String, dynamic>.from(data);
        productData['id'] = doc.id;
        return Product.fromJson(productData);
      }).toList();
    } catch (e) {
      AppLogger.error('Error getting products by category', e);
      return [];
    }
  }

  // Get featured products (organic or high rated)
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(kProductsCollection)
          .where('isOrganic', isEqualTo: true)
          .limit(10)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        final productData = Map<String, dynamic>.from(data);
        productData['id'] = doc.id;
        return Product.fromJson(productData);
      }).toList();
    } catch (e) {
      AppLogger.error('Error getting featured products', e);
      return [];
    }
  }

  // Get product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      final doc = await _firestore
          .collection(kProductsCollection)
          .doc(productId)
          .get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        final productData = Map<String, dynamic>.from(data);
        productData['id'] = doc.id;
        return Product.fromJson(productData);
      }
      return null;
    } catch (e) {
      AppLogger.error('Error getting product', e);
      return null;
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    try {
      // Note: This is a simple search. For better search, consider using Algolia or Elasticsearch
      final querySnapshot = await _firestore
          .collection(kProductsCollection)
          .get();

      final allProducts = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final productData = Map<String, dynamic>.from(data);
        productData['id'] = doc.id;
        return Product.fromJson(productData);
      }).toList();

      // Filter products that contain the search query in name or description
      return allProducts.where((product) {
        final nameMatch = product.name.toLowerCase().contains(
          query.toLowerCase(),
        );
        final descriptionMatch = product.description.toLowerCase().contains(
          query.toLowerCase(),
        );
        return nameMatch || descriptionMatch;
      }).toList();
    } catch (e) {
      AppLogger.error('Error searching products', e);
      return [];
    }
  }

  // Get products with low stock
  Future<List<Product>> getLowStockProducts({int threshold = 5}) async {
    try {
      final querySnapshot = await _firestore
          .collection(kProductsCollection)
          .where('stockQuantity', isLessThanOrEqualTo: threshold)
          .where('isInStock', isEqualTo: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        final productData = Map<String, dynamic>.from(data);
        productData['id'] = doc.id;
        return Product.fromJson(productData);
      }).toList();
    } catch (e) {
      AppLogger.error('Error getting low stock products', e);
      return [];
    }
  }

  // Stream products (for real-time updates)
  Stream<List<Product>> productsStream() {
    return _firestore.collection(kProductsCollection).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final productData = Map<String, dynamic>.from(data);
        productData['id'] = doc.id;
        return Product.fromJson(productData);
      }).toList();
    });
  }

  // Add sample products (for development)
  Future<void> addSampleProducts() async {
    final sampleProducts = [
      Product(
        id: 'apple_1',
        name: 'Red Delicious Apple',
        description: 'Fresh, crisp red apples perfect for snacking or baking.',
        price: 4.99,
        originalPrice: null,
        discountPercentage: 0.0,
        hasDiscount: false,
        imageUrl:
            'https://img.freepik.com/free-photo/apple-fresh-fruit-transparent-cube-generative-ai_188544-11979.jpg?semt=ais_hybrid&w=740&q=80',
        category: 'Fruits',
        isOrganic: true,
        isInStock: true,
        stockQuantity: 50,
        rating: 4.5,
        reviewCount: 120,
        tags: ['organic', 'fresh', 'red'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'apple_2',
        name: 'Red Delicious Apple',
        description: 'Fresh, crisp red apples perfect for snacking or baking.',
        price: 4.99,
        originalPrice: null,
        discountPercentage: 0.0,
        hasDiscount: false,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFcfDy5ZFVBKuu2s0z_M2UTcevkBpNWOq9nQ&s',
        category: 'Fruits',
        isOrganic: true,
        isInStock: true,
        stockQuantity: 50,
        rating: 4.5,
        reviewCount: 120,
        tags: ['organic', 'fresh', 'red'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'apple_3',
        name: 'Red Delicious Apple',
        description: 'Fresh, crisp red apples perfect for snacking or baking.',
        price: 4.99,
        originalPrice: null,
        discountPercentage: 0.0,
        hasDiscount: false,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFcfDy5ZFVBKuu2s0z_M2UTcevkBpNWOq9nQ&s',
        category: 'Fruits',
        isOrganic: true,
        isInStock: true,
        stockQuantity: 50,
        rating: 4.5,
        reviewCount: 120,
        tags: ['organic', 'fresh', 'red'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'apple_4',
        name: 'Red Delicious Apple',
        description: 'Fresh, crisp red apples perfect for snacking or baking.',
        price: 4.99,
        originalPrice: null,
        discountPercentage: 0.0,
        hasDiscount: false,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFcfDy5ZFVBKuu2s0z_M2UTcevkBpNWOq9nQ&s',
        category: 'Fruits',
        isOrganic: true,
        isInStock: true,
        stockQuantity: 50,
        rating: 4.5,
        reviewCount: 120,
        tags: ['organic', 'fresh', 'red'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'apple_5',
        name: 'Red Delicious Apple',
        description: 'Fresh, crisp red apples perfect for snacking or baking.',
        price: 4.99,
        originalPrice: null,
        discountPercentage: 0.0,
        hasDiscount: false,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFcfDy5ZFVBKuu2s0z_M2UTcevkBpNWOq9nQ&s',
        category: 'Fruits',
        isOrganic: true,
        isInStock: true,
        stockQuantity: 50,
        rating: 4.5,
        reviewCount: 120,
        tags: ['organic', 'fresh', 'red'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'apple_6',
        name: 'Red Delicious Apple',
        description: 'Fresh, crisp red apples perfect for snacking or baking.',
        price: 4.99,
        originalPrice: null,
        discountPercentage: 0.0,
        hasDiscount: false,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFcfDy5ZFVBKuu2s0z_M2UTcevkBpNWOq9nQ&s',
        category: 'Fruits',
        isOrganic: true,
        isInStock: true,
        stockQuantity: 50,
        rating: 4.5,
        reviewCount: 120,
        tags: ['organic', 'fresh', 'red'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'apple_7',
        name: 'Red Delicious Apple',
        description: 'Fresh, crisp red apples perfect for snacking or baking.',
        price: 4.99,
        originalPrice: null,
        discountPercentage: 0.0,
        hasDiscount: false,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFcfDy5ZFVBKuu2s0z_M2UTcevkBpNWOq9nQ&s',
        category: 'Fruits',
        isOrganic: true,
        isInStock: true,
        stockQuantity: 50,
        rating: 4.5,
        reviewCount: 120,
        tags: ['organic', 'fresh', 'red'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: 'apple_8',
        name: 'Red Delicious Apple',
        description: 'Fresh, crisp red apples perfect for snacking or baking.',
        price: 4.99,
        originalPrice: null,
        discountPercentage: 0.0,
        hasDiscount: false,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFcfDy5ZFVBKuu2s0z_M2UTcevkBpNWOq9nQ&s',
        category: 'Fruits',
        isOrganic: true,
        isInStock: true,
        stockQuantity: 50,
        rating: 4.5,
        reviewCount: 120,
        tags: ['organic', 'fresh', 'red'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    for (final product in sampleProducts) {
      try {
        await _firestore
            .collection(kProductsCollection)
            .doc(product.id)
            .set(product.toJson());
        AppLogger.info('Added product: ${product.name}');
      } catch (e) {
        AppLogger.error('Error adding product ${product.name}', e);
      }
    }
  }
}
