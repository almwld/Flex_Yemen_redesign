class Store {
  final String id;
  final String nameAr;
  final String nameEn;
  final String logo;
  final String? coverImage;
  final String? description;
  final String? categoryId;
  final double rating;
  final int reviewsCount;
  final bool isFeatured;
  final bool isActive;

  Store({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.logo,
    this.coverImage,
    this.description,
    this.categoryId,
    required this.rating,
    required this.reviewsCount,
    required this.isFeatured,
    required this.isActive,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'].toString(),
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      logo: json['logo'] ?? '',
      coverImage: json['cover_image'],
      description: json['description'],
      categoryId: json['category_id']?.toString(),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
      isActive: json['is_active'] ?? true,
    );
  }
}

class Product {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? description;
  final List<String> images;
  final double price;
  final double? discountPrice;
  final String? storeId;
  final String? categoryId;
  final List<String> tags;
  final double rating;
  final int reviewsCount;
  final bool inStock;
  final bool isFeatured;

  Product({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.description,
    required this.images,
    required this.price,
    this.discountPrice,
    this.storeId,
    this.categoryId,
    required this.tags,
    required this.rating,
    required this.reviewsCount,
    required this.inStock,
    required this.isFeatured,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      description: json['description'],
      images: List<String>.from(json['images'] ?? []),
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: json['discount_price']?.toDouble(),
      storeId: json['store_id']?.toString(),
      categoryId: json['category_id']?.toString(),
      tags: List<String>.from(json['tags'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      inStock: json['in_stock'] ?? true,
      isFeatured: json['is_featured'] ?? false,
    );
  }
}
