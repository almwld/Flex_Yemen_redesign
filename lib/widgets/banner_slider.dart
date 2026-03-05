import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flex_yemen_redesign/models/banner_model.dart';
import 'package:flex_yemen_redesign/utils/constants.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerModel> banners;
  final bool isLoading;

  const BannerSlider({
    super.key,
    required this.banners,
    required this.isLoading,
  });

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.isLoading) {
      return _buildShimmer();
    }

    if (widget.banners.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            viewportFraction: 0.85,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          items: widget.banners.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _getColorFromString(banner.bgColor).withOpacity(0.1),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: banner.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryGold,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              isDark ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              banner.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                                shadows: [
                                  Shadow(
                                    color: isDark ? Colors.black : Colors.white,
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            if (banner.subtitle != null)
                              Text(
                                banner.subtitle!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.white70 : Colors.black54,
                                  shadows: [
                                    Shadow(
                                      color: isDark ? Colors.black : Colors.white,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.banners.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? AppColors.primaryGold
                    : Colors.grey.withOpacity(0.5),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text('لا توجد بنرات حالياً'),
      ),
    );
  }

  Color _getColorFromString(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColors.primaryGold;
    }
  }
}
