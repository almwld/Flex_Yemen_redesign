import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flex_yemen_redesign/providers/store_provider.dart';
import 'package:flex_yemen_redesign/models/store_model.dart'; // ✅ IMPORT مهم جداً
import 'package:flex_yemen_redesign/utils/constants.dart';

class StoreScreen extends StatefulWidget {
  final VoidCallback onAdd;

  const StoreScreen({super.key, required this.onAdd});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<StoreProvider>(context, listen: false);
    await provider.loadAllStoreData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Consumer<StoreProvider>(
        builder: (context, provider, child) {
          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // 🔍 شريط البحث الثابت
                SliverAppBar(
                  expandedHeight: 120,
                  floating: true,
                  pinned: true,
                  snap: true,
                  backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              textAlign: TextAlign.right,
                              onChanged: provider.search,
                              decoration: InputDecoration(
                                hintText: 'ابحث عن منتج...',
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
                        ],
                      ),
                    ),
                  ),
                ),
                
                // 🏷️ التبويبات (الأقسام)
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: AppColors.primaryGold,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primaryGold,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'الكل'),
                        Tab(text: 'المتاجر'),
                        Tab(text: 'المنتجات'),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                // 📱 صفحة الكل
                _buildAllPage(provider, isDark),
                
                // 🏪 صفحة المتاجر
                _buildStoresPage(provider, isDark),
                
                // 📦 صفحة المنتجات
                _buildProductsPage(provider, isDark),
              ],
            ),
          );
        },
      ),
    );
  }

  // 📱 صفحة الكل (منتجات مميزة + متاجر مميزة)
  Widget _buildAllPage(StoreProvider provider, bool isDark) {
    return provider.isLoading
        ? _buildShimmerGrid(context)
        : CustomScrollView(
            slivers: [
              // منتجات مميزة
              SliverToBoxAdapter(
                child: _buildSectionHeader('منتجات مميزة', isDark),
              ),
              SliverToBoxAdapter(
                child: _buildFeaturedProducts(provider.featuredProducts, isDark),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              
              // متاجر مميزة
              SliverToBoxAdapter(
                child: _buildSectionHeader('متاجر مميزة', isDark),
              ),
              SliverToBoxAdapter(
                child: _buildFeaturedStores(provider.stores.where((s) => s.isFeatured).toList(), isDark),
              ),
            ],
          );
  }

  // 🏪 صفحة المتاجر
  Widget _buildStoresPage(StoreProvider provider, bool isDark) {
    return provider.isLoading
        ? _buildShimmerGrid(context)
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: provider.stores.length,
            itemBuilder: (context, index) {
              final store = provider.stores[index];
              return _buildStoreCard(store, isDark);
            },
          );
  }

  // 📦 صفحة المنتجات
  Widget _buildProductsPage(StoreProvider provider, bool isDark) {
    return Column(
      children: [
        // شريط الفلترة
        _buildFilterBar(provider, isDark),
        
        // المنتجات المفلترة
        Expanded(
          child: provider.isLoading
              ? _buildShimmerGrid(context)
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: provider.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = provider.filteredProducts[index];
                    return _buildProductCard(product, isDark);
                  },
                ),
        ),
      ],
    );
  }

  // شريط الفلترة
  Widget _buildFilterBar(StoreProvider provider, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // فلتر الأقسام
            ...provider.categories.map((category) {
              final isSelected = provider.selectedCategoryId == category.id;
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(category.nameAr),
                  onSelected: (selected) {
                    provider.filterByCategory(selected ? category.id : null);
                  },
                  selectedColor: AppColors.primaryGold.withOpacity(0.2),
                  checkmarkColor: AppColors.primaryGold,
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // بطاقة منتج
  Widget _buildProductCard(Product product, bool isDark) {
    return GestureDetector(
      onTap: () {
        // TODO: فتح صفحة تفاصيل المنتج
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product.images.isNotEmpty ? product.images.first : '',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                if (product.discountPrice != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${((product.price - product.discountPrice!) / product.price * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (!product.inStock)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'نفد من المخزون',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // التفاصيل
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nameAr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.primaryGold,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewsCount})',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white54 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${(product.discountPrice ?? product.price).round()} ر.ي',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGold,
                        ),
                      ),
                      if (product.discountPrice != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            '${product.price.round()} ر.ي',
                            style: TextStyle(
                              fontSize: 10,
                              decoration: TextDecoration.lineThrough,
                              color: isDark ? Colors.white54 : Colors.black38,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // زر الإضافة
            if (product.inStock)
              Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onAdd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('أضف إلى السلة'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // بطاقة متجر
  Widget _buildStoreCard(Store store, bool isDark) {
    return GestureDetector(
      onTap: () {
        // TODO: فتح صفحة المتجر
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // الشعار
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: store.logo,
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
                    child: const Icon(Icons.store),
                  ),
                ),
              ),
            ),
            
            // التفاصيل
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    store.nameAr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.primaryGold,
                        size: 12,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        store.rating.toString(),
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${store.reviewsCount})',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark ? Colors.white54 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // منتجات مميزة أفقية
  Widget _buildFeaturedProducts(List<Product> products, bool isDark) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(left: 12),
            child: _buildProductCard(products[index], isDark),
          );
        },
      ),
    );
  }

  // متاجر مميزة أفقية
  Widget _buildFeaturedStores(List<Store> stores, bool isDark) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stores.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(left: 12),
            child: _buildStoreCard(stores[index], isDark),
          );
        },
      ),
    );
  }

  // عنوان القسم
  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'عرض الكل',
              style: TextStyle(
                color: AppColors.primaryGold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Shimmer loading
  Widget _buildShimmerGrid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Delegate للـ TabBar الثابت
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
