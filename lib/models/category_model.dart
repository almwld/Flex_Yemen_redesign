class Category {
  final String id;
  final String nameAr;
  final String nameEn;
  final String icon;
  final String? imageUrl;
  final String color;
  final int order;
  final bool isActive;

  Category({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.icon,
    this.imageUrl,
    required this.color,
    required this.order,
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      icon: json['icon'] ?? '📦',
      imageUrl: json['image_url'],
      color: json['color'] ?? '#D4AF37',
      order: json['order'] ?? 0,
      isActive: json['is_active'] ?? true,
    );
  }
}
