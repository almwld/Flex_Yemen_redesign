import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flex_yemen_redesign/models/category_model.dart';
import 'package:flex_yemen_redesign/models/banner_model.dart';
import 'package:flex_yemen_redesign/models/offer_model.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // 📥 تحميل الأقسام
  Future<List<Category>> getCategories() async {
    try {
      final response = await _client
          .from('categories')
          .select()
          .eq('is_active', true)
          .order('order');
      
      return (response as List)
          .map((json) => Category.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading categories: $e');
      return [];
    }
  }

  // 📥 تحميل البنرات
  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await _client
          .from('banners')
          .select()
          .eq('is_active', true)
          .order('order');
      
      return (response as List)
          .map((json) => BannerModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading banners: $e');
      return [];
    }
  }

  // 📥 تحميل العروض الحصرية
  Future<List<OfferModel>> getExclusiveOffers() async {
    try {
      final response = await _client
          .from('offers')
          .select()
          .eq('is_exclusive', true)
          .eq('is_active', true)
          .order('order');
      
      return (response as List)
          .map((json) => OfferModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading exclusive offers: $e');
      return [];
    }
  }

  // 📥 تحميل عروض الأسبوع
  Future<List<OfferModel>> getWeeklyOffers() async {
    try {
      final response = await _client
          .from('offers')
          .select()
          .eq('is_weekly', true)
          .eq('is_active', true)
          .order('order');
      
      return (response as List)
          .map((json) => OfferModel.fromJson(json))
          .toList();
    } catch (e) {
      print('Error loading weekly offers: $e');
      return [];
    }
  }
}
