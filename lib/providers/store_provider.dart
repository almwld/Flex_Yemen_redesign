import 'package:flutter/material.dart';
import 'package:flex_yemen_redesign/models/category_model.dart';
import 'package:flex_yemen_redesign/models/store_model.dart';
import 'package:flex_yemen_redesign/services/supabase_service.dart';

class StoreProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  
  List<Category> _categories = [];
  List<Store> _stores = [];
  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  
  String? _selectedCategoryId;
  String? _searchQuery;
  double _maxPrice = 1000000;
  RangeValues _priceRange = const RangeValues(0, 1000000);
  
  bool _isLoadingCategories = false;
  bool _isLoadingStores = false;
  bool _isLoadingProducts = false;
  
  String? _categoriesError;
  String? _storesError;
  String? _productsError;

  // Getters
  List<Category> get categories => _categories;
  List<Store> get stores => _stores;
  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  String? get selectedCategoryId => _selectedCategoryId;
  RangeValues get priceRange => _priceRange;
  bool get isLoading => _isLoadingCategories || _isLoadingStores || _isLoadingProducts;

  // تحميل كل البيانات
  Future<void> loadAllStoreData() async {
    await Future.wait([
      loadCategories(),
      loadStores(),
      loadProducts(),
      loadFeaturedProducts(),
    ]);
  }

  // تحميل الأقسام
  Future<void> loadCategories() async {
    _isLoadingCategories = true;
    _categoriesError = null;
    notifyListeners();

    try {
      _categories = await _supabaseService.getCategories();
    } catch (e) {
      _categoriesError = e.toString();
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  // تحميل المتاجر
  Future<void> loadStores() async {
    _isLoadingStores = true;
    _storesError = null;
    notifyListeners();

    try {
      // هذا يحتاج إنشاء جدول stores في Supabase
      // حالياً نستخدم بيانات وهمية
      _stores = _getMockStores();
    } catch (e) {
      _storesError = e.toString();
    } finally {
      _isLoadingStores = false;
      notifyListeners();
    }
  }

  // تحميل المنتجات
  Future<void> loadProducts() async {
    _isLoadingProducts = true;
    _productsError = null;
    notifyListeners();

    try {
      // هذا يحتاج إنشاء جدول products في Supabase
      // حالياً نستخدم بيانات وهمية
      _products = _getMockProducts();
    } catch (e) {
      _productsError = e.toString();
    } finally {
      _isLoadingProducts = false;
      notifyListeners();
    }
  }

  // تحميل المنتجات المميزة
  Future<void> loadFeaturedProducts() async {
    try {
      final allProducts = await _getMockProducts();
      _featuredProducts = allProducts.where((p) => p.isFeatured).take(10).toList();
    } catch (e) {
      print('Error loading featured products: $e');
    }
  }

  // فلترة حسب القسم
  void filterByCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  // فلترة حسب السعر
  void filterByPrice(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  // بحث
  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // المنتجات المفلترة
  List<Product> get filteredProducts {
    return _products.where((product) {
      // فلترة حسب القسم
      if (_selectedCategoryId != null && product.categoryId != _selectedCategoryId) {
        return false;
      }
      
      // فلترة حسب السعر
      final price = product.discountPrice ?? product.price;
      if (price < _priceRange.start || price > _priceRange.end) {
        return false;
      }
      
      // فلترة حسب البحث
      if (_searchQuery != null && _searchQuery!.isNotEmpty) {
        final query = _searchQuery!.toLowerCase();
        final matchesName = product.nameAr.toLowerCase().contains(query) ||
                           product.nameEn.toLowerCase().contains(query);
        if (!matchesName) return false;
      }
      
      return true;
    }).toList();
  }

  // بيانات وهمية مؤقتة (حتى ننشئ الجداول في Supabase)
  List<Store> _getMockStores() {
    return [
      Store(
        id: '1',
        nameAr: 'متجر الإلكترونيات',
        nameEn: 'Electronics Store',
        logo: 'https://via.placeholder.com/150',
        coverImage: 'https://via.placeholder.com/300x150',
        description: 'أفضل الأجهزة الإلكترونية',
        categoryId: '1',
        rating: 4.5,
        reviewsCount: 120,
        isFeatured: true,
        isActive: true,
      ),
      Store(
        id: '2',
        nameAr: 'متجر الأزياء',
        nameEn: 'Fashion Store',
        logo: 'https://via.placeholder.com/150',
        coverImage: 'https://via.placeholder.com/300x150',
        description: 'أحدث صيحات الموضة',
        categoryId: '2',
        rating: 4.2,
        reviewsCount: 85,
        isFeatured: true,
        isActive: true,
      ),
    ];
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: '1',
        nameAr: 'آيفون 15 برو',
        nameEn: 'iPhone 15 Pro',
        description: 'أحدث هواتف آبل',
        images: ['https://via.placeholder.com/300'],
        price: 350000,
        discountPrice: 320000,
        categoryId: '1',
        tags: ['جديد', 'مميز'],
        rating: 4.8,
        reviewsCount: 50,
        inStock: true,
        isFeatured: true,
      ),
      Product(
        id: '2',
        nameAr: 'لابتوب ديل',
        nameEn: 'Dell Laptop',
        description: 'لابتوب عالي الأداء',
        images: ['https://via.placeholder.com/300'],
        price: 250000,
        discountPrice: null,
        categoryId: '1',
        tags: ['عرض خاص'],
        rating: 4.3,
        reviewsCount: 30,
        inStock: true,
        isFeatured: false,
      ),
      Product(
        id: '3',
        nameAr: 'فستان سهرة',
        nameEn: 'Evening Dress',
        description: 'فستان أنيق للسهرات',
        images: ['https://via.placeholder.com/300'],
        price: 45000,
        discountPrice: 38000,
        categoryId: '2',
        tags: ['تخفيض'],
        rating: 4.6,
        reviewsCount: 25,
        inStock: true,
        isFeatured: true,
      ),
    ];
  }
}
