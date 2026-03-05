import 'package:flutter/material.dart';
import 'package:flex_yemen_redesign/models/category_model.dart';
import 'package:flex_yemen_redesign/services/supabase_service.dart';

class CategoryProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _supabaseService.getCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
