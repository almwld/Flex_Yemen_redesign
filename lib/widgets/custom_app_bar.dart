import 'package:flutter/material.dart';
import 'package:flex_yemen_redesign/utils/constants.dart';
import 'cart_badge.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final int cartCount;
  final VoidCallback onThemeToggle;
  final VoidCallback onSettingsPressed;
  final VoidCallback onCartPressed;

  const CustomAppBar({
    super.key,
    required this.isDarkMode,
    required this.cartCount,
    required this.onThemeToggle,
    required this.onSettingsPressed,
    required this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.settings_outlined, color: AppColors.primaryGold),
        onPressed: onSettingsPressed,
      ),
      title: const Center(
        child: Text(
          AppStrings.appName,
          style: TextStyle(
            color: AppColors.primaryGold,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      actions: [
        CartBadge(cartCount: cartCount, onPressed: onCartPressed),
        IconButton(
          icon: Icon(
            isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round_outlined,
            color: AppColors.primaryGold,
          ),
          onPressed: onThemeToggle,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
