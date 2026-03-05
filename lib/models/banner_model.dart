class BannerModel {
  final String id;
  final String title;
  final String? subtitle;
  final String imageUrl;
  final String? linkType;
  final String? linkId;
  final int order;
  final String bgColor;

  BannerModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    this.linkType,
    this.linkId,
    required this.order,
    required this.bgColor,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      imageUrl: json['image_url'] ?? '',
      linkType: json['link_type'],
      linkId: json['link_id']?.toString(),
      order: json['order'] ?? 0,
      bgColor: json['bg_color'] ?? '#D4AF37',
    );
  }
}
