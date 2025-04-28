import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class RegistrationChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Register as',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                SizedBox(height: 40),
                CustomButton(
                  text: 'Farmer',
                  color: Colors.green.shade400,
                  onPressed: () {
                    Navigator.pushNamed(context, '/farmer-registration');
                  },
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'Wholesaler',
                  color: Colors.green.shade200,
                  onPressed: () {
                    Navigator.pushNamed(context, '/wholesaler-registration');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
