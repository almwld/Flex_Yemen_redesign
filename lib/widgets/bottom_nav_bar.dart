import 'package:flutter/material.dart';
import 'package:flex_yemen_redesign/utils/constants.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isDarkMode;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.isDarkMode,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              _navItem(Icons.home_filled, AppStrings.home, 0),
              _navItem(Icons.map_outlined, AppStrings.maps, 1),
              _navItem(Icons.storefront_outlined, AppStrings.store, 2),
            ]),
            Row(children: [
              _navItem(Icons.account_balance_wallet_outlined, AppStrings.wallet, 4),
              _navItem(Icons.chat_bubble_outline_rounded, AppStrings.chat, 5),
              _navItem(Icons.person_outline_rounded, AppStrings.profile, 6),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onItemTapped(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryGold : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryGold : Colors.grey,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
