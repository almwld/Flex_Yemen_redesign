import 'package:flutter/material.dart';
import 'package:flex_yemen_redesign/utils/constants.dart';

class StoreScreen extends StatelessWidget {
  final VoidCallback onAdd;

  const StoreScreen({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(15),
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        _cat(Icons.shopping_cart_checkout, "الماركت"),
        _cat(Icons.restaurant_menu, "المطاعم"),
        _cat(Icons.phone_iphone, "التقنية"),
        _cat(Icons.watch, "اكسسوارات"),
        _cat(Icons.health_and_safety, "الصحية"),
        _cat(Icons.more_horiz, "المزيد"),
      ],
    );
  }

  Widget _cat(IconData icon, String name) {
    return InkWell(
      onTap: onAdd,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primaryGold),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
