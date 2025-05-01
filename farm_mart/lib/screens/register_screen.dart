import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import '../widgets/gradient_background.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  // Form state
  String _userType = 'farmer'; // Default selection
  bool _otpSent = false;
  bool _otpVerified = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to monitor text changes
    _phoneController.addListener(_validatePhoneNumber);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_validatePhoneNumber);
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _aadharController.dispose();
    _idController.dispose();
    super.dispose();
  }

  // Validate phone number and enable/disable OTP button
  void _validatePhoneNumber() {
    // Force refresh the UI to update the OTP button state
    setState(() {});
  }

  // Send OTP method
  void _sendOtp() {
    setState(() {
      _otpSent = true;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('OTP sent successfully!')));
  }

  // Verify OTP method
  void _verifyOtp() {
    setState(() {
      _otpVerified = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('OTP verified successfully!')));
  }

  // Check if all required fields are filled
  bool _validateRegistrationForm() {
    // Check for required fields
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _pincodeController.text.isEmpty ||
        _aadharController.text.isEmpty ||
        _idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return false;
    }
    return true;
  }

  // Register user method
  void _registerUser() {
    if (!_validateRegistrationForm()) {
      return;
    }

    // Show success dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Registered successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  // Navigate to appropriate home screen based on user type
                  if (_userType == 'farmer') {
                    Navigator.pushReplacementNamed(context, '/farmer_home');
                  } else {
                    Navigator.pushReplacementNamed(context, '/wholesaler_home');
                  }
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(color: AppColors.textDark),
        ),
      ),
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // User type selection
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Register as:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Farmer'),
                                  value: 'farmer',
                                  groupValue: _userType,
                                  activeColor: AppColors.primary,
                                  onChanged: (value) {
                                    setState(() {
                                      _userType = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Wholesaler'),
                                  dense: true,
                                  isThreeLine: false,
                                  value: 'wholesaler',
                                  groupValue: _userType,
                                  activeColor: AppColors.primary,
                                  onChanged: (value) {
                                    setState(() {
                                      _userType = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Personal details form
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Name field
                          _buildTextField(
                            controller: _nameController,
                            hintText: 'Full Name',
                            icon: Icons.person,
                            keyboardType: TextInputType.name,
                            required: true,
                          ),
                          const SizedBox(height: 15),

                          // Phone number & OTP section
                          _buildTextField(
                            controller: _phoneController,
                            hintText: 'Phone Number',
                            icon: Icons.phone,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            required: true,
                          ),
                          const SizedBox(height: 10),

                          // Get OTP button
                          if (!_otpSent)
                            ElevatedButton(
                              onPressed:
                                  _phoneController.text.length == 10
                                      ? _sendOtp
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: AppColors.primary
                                    .withOpacity(0.5),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(double.infinity, 45),
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

                          // OTP field & verify button
                          if (_otpSent) ...[
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _otpController,
                              hintText: 'Enter OTP',
                              icon: Icons.lock_outline,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              required: true,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _otpVerified ? null : _verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _otpVerified
                                        ? AppColors.success
                                        : AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(double.infinity, 45),
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
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Address details form
                  if (_otpVerified)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address & ID Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Address field
                            _buildTextField(
                              controller: _addressController,
                              hintText: 'Full Address',
                              icon: Icons.home,
                              keyboardType: TextInputType.streetAddress,
                              maxLines: 3,
                              required: true,
                            ),
                            const SizedBox(height: 15),

                            // Pincode field
                            _buildTextField(
                              controller: _pincodeController,
                              hintText: 'Pincode',
                              icon: Icons.location_on,
                              keyboardType: TextInputType.number,
                              maxLength: 7,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(7),
                              ],
                              required: true,
                            ),
                            const SizedBox(height: 15),

                            // Aadhar field (mandatory)
                            _buildTextField(
                              controller: _aadharController,
                              hintText: 'Aadhar Number',
                              icon: Icons.credit_card,
                              keyboardType: TextInputType.number,
                              maxLength: 12,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(12),
                              ],
                              required: true,
                            ),
                            const SizedBox(height: 15),

                            // ID field (Kishan for farmer, PAN for wholesaler)
                            _buildTextField(
                              controller: _idController,
                              hintText:
                                  _userType == 'farmer'
                                      ? 'Kishan ID'
                                      : 'PAN Number',
                              icon:
                                  _userType == 'farmer'
                                      ? Icons.agriculture
                                      : Icons.account_balance,
                              keyboardType: TextInputType.text,
                              maxLength: _userType == 'farmer' ? 12 : 10,
                              textCapitalization: TextCapitalization.characters,
                              required: true,
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Register button
                  if (_otpVerified)
                    ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(double.infinity, 55),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields with consistent styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool required = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        maxLines: maxLines,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        onChanged: (value) {
          // Force UI update for buttons that depend on field values
          setState(() {});
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          border: InputBorder.none,
          hintText: required ? '$hintText *' : hintText,
          prefixIcon: Icon(icon, color: AppColors.primary),
          counterText: '',
        ),
      ),
    );
  }
}