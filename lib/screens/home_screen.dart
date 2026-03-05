import 'package:flutter/material.dart';
import 'package:flex_yemen_redesign/utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "اكتشف فلكس يمن",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        _featuredCard("عقارات فاخرة", "أفضل الفلل في صنعاء", Icons.domain),
        _featuredCard("سيارات حديثة", "عروض معرض فلكس", Icons.directions_car_filled),
      ],
    );
  }

  Widget _featuredCard(String title, String subtitle, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: AppColors.cardDark,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryGold),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
