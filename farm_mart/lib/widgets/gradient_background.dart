import 'package:flutter/material.dart';
import '../constants/colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  
  const GradientBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.gradientStart,
            AppColors.gradientEnd,
          ],
        ),
      ),
      // Ensure the container takes up the full screen
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: child,
    );
  }
}