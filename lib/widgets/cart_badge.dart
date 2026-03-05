import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  final int cartCount;
  final VoidCallback onPressed;

  const CartBadge({
    super.key,
    required this.cartCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFFD4AF37)),
          onPressed: onPressed,
        ),
        if (cartCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: CircleAvatar(
              radius: 7,
              backgroundColor: Colors.red,
              child: Text(
                cartCount.toString(),
                style: const TextStyle(fontSize: 9, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
