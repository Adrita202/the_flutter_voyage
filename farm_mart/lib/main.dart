
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/farmer_home_screen.dart';
import 'screens/wholesaler_home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'constants/colors.dart';
import 'screens/product_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmer to Wholesaler',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ).copyWith(secondary: AppColors.accent),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayMedium: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: AppColors.textDark),
          bodyMedium: TextStyle(color: AppColors.textLight),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/farmer_home': (context) => const FarmerHomeScreen(),
        '/wholesaler_home': (context) => const WholesalerHomeScreen(),
        '/cart': (context) => const CartScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/product_details': (context) => const ProductDetailsScreen(),
      },
    );
  }
}
// Add this to your main.dart or wherever your routes are defined

