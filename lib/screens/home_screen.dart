import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_yemen_redesign/providers/category_provider.dart';
import 'package:flex_yemen_redesign/widgets/category_widget.dart';
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
    _loadData();
  }

  Future<void> _loadData() async {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return RefreshIndicator(
      onRefresh: _loadData,
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
                    // TODO: التنقل لصفحة القسم
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

          // مسافة
          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // هنا راح نضيف باقي المكونات:
          // 2. السلايدر
          // 3. العروض الحصرية
          // 4. عروض الأسبوع
          // 5. المتاجر المميزة
        ],
      ),
    );
  }
}
