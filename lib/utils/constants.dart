import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color darkBackground = Color(0xFF151515);
  static const Color lightBackground = Colors.white;
  static const Color cardDark = Color(0xFF1A1A1A);
  
  // دالة مساعدة للشفافية (متوافقة مع Flutter 3.27+)
  static Color withOpacityColor(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}

class AppStrings {
  static const String appName = "FLEX YEMEN";
  static const String home = "الرئيسية";
  static const String maps = "الخرائط";
  static const String store = "المتجر";
  static const String wallet = "المحفظة";
  static const String chat = "دردشة";
  static const String profile = "حسابي";
  static const String searchHint = "ابحث عن مطاعم، أزياء، خدمات...";
  static const String categories = "الأقسام";
  static const String viewAll = "عرض الكل";
}

class SupabaseConfig {
  static const String url = 'https://ziqpohdxtemmsunnhlkm.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InppcXBvaGR4dGVtc211bm5obGttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE3ODQzNDcsImV4cCI6MjA4NzM2MDM0N30.ABAg5YZSrrAtBTWATJ3eRTmo4BuZVyVlrMV1HZjRWs0';
}
