import 'package:flutter/material.dart';
import 'package:flex_yemen_redesign/models/banner_model.dart';
import 'package:flex_yemen_redesign/models/offer_model.dart';
import 'package:flex_yemen_redesign/services/supabase_service.dart';

class HomeProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  
  List<BannerModel> _banners = [];
  List<OfferModel> _exclusiveOffers = [];
  List<OfferModel> _weeklyOffers = [];
  
  bool _isLoadingBanners = false;
  bool _isLoadingExclusive = false;
  bool _isLoadingWeekly = false;
  
  String? _bannersError;
  String? _exclusiveError;
  String? _weeklyError;

  List<BannerModel> get banners => _banners;
  List<OfferModel> get exclusiveOffers => _exclusiveOffers;
  List<OfferModel> get weeklyOffers => _weeklyOffers;
  
  bool get isLoading => _isLoadingBanners || _isLoadingExclusive || _isLoadingWeekly;
  bool get hasError => _bannersError != null || _exclusiveError != null || _weeklyError != null;

  Future<void> loadAllData() async {
    await Future.wait([
      loadBanners(),
      loadExclusiveOffers(),
      loadWeeklyOffers(),
    ]);
  }

  Future<void> loadBanners() async {
    _isLoadingBanners = true;
    _bannersError = null;
    notifyListeners();

    try {
      _banners = await _supabaseService.getBanners();
    } catch (e) {
      _bannersError = e.toString();
    } finally {
      _isLoadingBanners = false;
      notifyListeners();
    }
  }

  Future<void> loadExclusiveOffers() async {
    _isLoadingExclusive = true;
    _exclusiveError = null;
    notifyListeners();

    try {
      _exclusiveOffers = await _supabaseService.getExclusiveOffers();
    } catch (e) {
      _exclusiveError = e.toString();
    } finally {
      _isLoadingExclusive = false;
      notifyListeners();
    }
  }

  Future<void> loadWeeklyOffers() async {
    _isLoadingWeekly = true;
    _weeklyError = null;
    notifyListeners();

    try {
      _weeklyOffers = await _supabaseService.getWeeklyOffers();
    } catch (e) {
      _weeklyError = e.toString();
    } finally {
      _isLoadingWeekly = false;
      notifyListeners();
    }
  }
}
