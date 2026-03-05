import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_yemen_redesign/providers/category_provider.dart';
import 'package:flex_yemen_redesign/providers/home_provider.dart';
import 'package:flex_yemen_redesign/widgets/category_widget.dart';
import 'package:flex_yemen_redesign/widgets/banner_slider.dart';
import 'package:flex_yemen_redesign/widgets/offers_widget.dart';
import 'package:flex_yemen_redesign/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    
    await Future.wait([
      categoryProvider.loadCategories(),
      homeProvider.loadAllData(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return RefreshIndicator(
      onRefresh: _loadAllData,
      color: AppColors.primaryGold,
      child: CustomScrollView(
        slivers: [
          // 🔍 شريط البحث
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  ),
                ),
                child: TextField(
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchHint,
                    hintStyle: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.primaryGold,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 🎯 الأقسام (Categories)
          SliverToBoxAdapter(
            child: Consumer<CategoryProvider>(
              builder: (context, provider, child) {
                return CategoriesGrid(
                  categories: provider.categories,
                  isLoading: provider.isLoading,
                  onCategoryTap: (category) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم اختيار: ${category.nameAr}'),
                        backgroundColor: AppColors.primaryGold,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // 🎠 السلايدر (Banners)
          SliverToBoxAdapter(
            child: Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return BannerSlider(
                  banners: provider.banners,
                  isLoading: provider._isLoadingBanners,
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),

          // 🎁 العروض الحصرية (Exclusive Offers)
          SliverToBoxAdapter(
            child: Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return OffersWidget(
                  title: '🔥 عروض حصرية',
                  offers: provider.exclusiveOffers,
                  isLoading: provider._isLoadingExclusive,
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),

          // ⭐ عروض الأسبوع (Weekly Deals)
          SliverToBoxAdapter(
            child: Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return OffersWidget(
                  title: '⭐ عروض الأسبوع',
                  offers: provider.weeklyOffers,
                  isLoading: provider._isLoadingWeekly,
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),

          // 🏪 متاجر مميزة (سنضيفها لاحقاً)
        ],
      ),
    );
  }
}

// ✅ إضافة الخاص المؤقت للوصول للحالات
extension HomeProviderExtension on HomeProvider {
  bool get _isLoadingBanners => _isLoadingBanners;
  bool get _isLoadingExclusive => _isLoadingExclusive;
  bool get _isLoadingWeekly => _isLoadingWeekly;
}
