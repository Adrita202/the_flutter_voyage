import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/gradient_background.dart';
import '../api_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpSent = false;
  bool _otpVerified = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    final phone = _phoneController.text.trim();

    if (phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit phone number.'),
        ),
      );
      return;
    }

    try {
      bool success = await ApiService.sendOtp(phone);
      if (success) {
        setState(() {
          _otpSent = true;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('OTP sent successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send OTP. Try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _verifyOtp() async {
    final phone = _phoneController.text.trim();
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 6-digit OTP.')),
      );
      return;
    }

    try {
      bool verified = await ApiService.verifyOtp(phone, otp);
      if (verified) {
        setState(() {
          _otpVerified = true;
        });

        // Check user role and navigate accordingly
        _checkUserRoleAndNavigate(phone);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // New method to check user role and navigate to appropriate screen
  void _checkUserRoleAndNavigate(String phone) async {
    try {
      final userRole = await ApiService.getUserRole(phone);

      // TEMPORARY DEBUGGING: Print what role was returned
      print("Returned user role: $userRole");
      // Important: Check if widget is still mounted after async operations
      if (!mounted) return;
      if (userRole == null) {
        // User not registered
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissing by tapping outside
          builder:
              (BuildContext dialogContext) => AlertDialog(
                title: const Text('Not Registered'),
                content: const Text(
                  'This phone number is not registered. Please create a new account.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Use dialogContext to pop the dialog
                      Navigator.of(dialogContext).pop();
                      // Then use the original context for navigation
                      _navigateToRegister();
                    },
                    child: const Text('Register Now'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
        );
      } else if (userRole.toLowerCase() == 'farmer') {
        // Use pushAndRemoveUntil to clear the navigation stack
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/farmer_home',
          (route) => false, // This removes all previous routes
        );
      } else if (userRole.toLowerCase() == 'wholesaler') {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/wholesaler_home',
          (route) => false, // This removes all previous routes
        );
      } else {
        // For any other role
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unknown user role: $userRole')));
      }
    } catch (e) {
      // Check if widget is still mounted before showing SnackBar
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error checking user role: $e')));
    }
  }

  void _navigateToRegister() {
    Navigator.of(context).pushReplacementNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size to help with responsiveness
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          // This ensures the gradient covers the entire screen
          bottom: false,
          child: Container(
            height: screenSize.height,
            width: screenSize.width,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          screenSize.height -
                          32, // Subtract the vertical padding
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        const Text(
                          'Login Your Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.06,
                        ), // Responsive spacing
                        // Phone number field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 15,
                              ),
                              border: InputBorder.none,
                              hintText: 'Phone Number',
                              prefixIcon: Icon(Icons.phone),
                              counterText: '',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // OTP Button or OTP Field based on state
                        if (!_otpSent)
                          ElevatedButton(
                            onPressed: _sendOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Get OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                        if (_otpSent) ...[
                          // OTP field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                border: InputBorder.none,
                                hintText: 'Enter OTP',
                                prefixIcon: Icon(Icons.lock_outline),
                                counterText: '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Verify OTP button
                          ElevatedButton(
                            onPressed: _otpVerified ? null : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _otpVerified
                                      ? AppColors.success
                                      : AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              _otpVerified ? 'Verified' : 'Verify OTP',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 30),

                        SizedBox(
                          height: screenSize.height * 0.04,
                        ), // Responsive spacing
                        // OR divider
                        Row(
                          children: const [
                            Expanded(
                              child: Divider(color: Colors.grey, thickness: 1),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: Colors.grey, thickness: 1),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Don't have an account text
                        const Text(
                          "Don't have an account?",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textLight),
                        ),

                        const SizedBox(height: 10),

                        // Create new account button
                        OutlinedButton(
                          onPressed: _navigateToRegister,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Create a New Account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
