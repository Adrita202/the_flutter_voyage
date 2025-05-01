import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(color: AppColors.textDark),
        ),
      ),
      body: const Center(
        child: Text(
          'Cart Screen - To Be Implemented',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}