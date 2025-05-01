import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/gradient_background.dart';

class WholesalerHomeScreen extends StatefulWidget {
  const WholesalerHomeScreen({Key? key}) : super(key: key);

  @override
  _WholesalerHomeScreenState createState() => _WholesalerHomeScreenState();
}

class _WholesalerHomeScreenState extends State<WholesalerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wholesaler Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.business,
                    size: 100,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome, Wholesaler!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Wholesaler Dashboard Coming Soon',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}