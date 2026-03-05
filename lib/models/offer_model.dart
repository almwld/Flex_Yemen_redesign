class OfferModel {
  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;
  final int? discountPercent;
  final double? originalPrice;
  final double? offerPrice;
  final String? categoryId;
  final String? badgeText;
  final String badgeColor;
  final bool isExclusive;
  final bool isWeekly;
  final DateTime? startDate;
  final DateTime? endDate;
  final int order;

  OfferModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    this.discountPercent,
    this.originalPrice,
    this.offerPrice,
    this.categoryId,
    this.badgeText,
    required this.badgeColor,
    required this.isExclusive,
    required this.isWeekly,
    this.startDate,
    this.endDate,
    required this.order,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      imageUrl: json['image_url'] ?? '',
      discountPercent: json['discount_percent'],
      originalPrice: json['original_price']?.toDouble(),
      offerPrice: json['offer_price']?.toDouble(),
      categoryId: json['category_id']?.toString(),
      badgeText: json['badge_text'],
      badgeColor: json['badge_color'] ?? '#FF0000',
      isExclusive: json['is_exclusive'] ?? false,
      isWeekly: json['is_weekly'] ?? false,
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      order: json['order'] ?? 0,
    );
  }
}
