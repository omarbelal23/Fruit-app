class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final double discountPercentage;
  final bool hasDiscount;
  final String imageUrl;
  final String category;
  final bool isOrganic;
  final bool isInStock;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.discountPercentage,
    this.hasDiscount = false,
    required this.imageUrl,
    required this.category,
    this.isOrganic = false,
    this.isInStock = true,
    this.stockQuantity = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      hasDiscount: json['hasDiscount'] ?? false,
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      isOrganic: json['isOrganic'] ?? false,
      isInStock: json['isInStock'] ?? true,
      stockQuantity: json['stockQuantity'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // ✅ تضيف دي هنا
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'hasDiscount': hasDiscount,
      'imageUrl': imageUrl,
      'category': category,
      'isOrganic': isOrganic,
      'isInStock': isInStock,
      'stockQuantity': stockQuantity,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}