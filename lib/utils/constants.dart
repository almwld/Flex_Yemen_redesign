import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGold = Color(0xFFD4AF37);
  static const Color darkBackground = Color(0xFF151515);
  static const Color lightBackground = Colors.white;
  static const Color cardDark = Color(0xFF1A1A1A);
}

class AppStrings {
  static const String appName = "FLEX YEMEN";
  static const String home = "الرئيسية";
  static const String maps = "الخرائط";
  static const String store = "المتجر";
  static const String wallet = "المحفظة";
  static const String chat = "دردشة";
  static const String profile = "حسابي";
}

class SupabaseConfig {
  // 📌 تأتي من CodeMagic Environment Variables
  static String get url => const String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://ziqpohdxtemmsunnhlkm.supabase.co'
  );
  
  static String get anonKey => const String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InppcXBvaGR4dGVtc211bm5obGttIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE3ODQzNDcsImV4cCI6MjA4NzM2MDM0N30.ABAg5YZSrrAtBTWATJ3eRTmo4BuZVyVlrMV1HZjRWs0'
  );
}
