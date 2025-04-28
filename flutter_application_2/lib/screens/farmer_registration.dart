import 'package:flutter/material.dart';

class FarmerRegistrationScreen extends StatefulWidget {
  @override
  _FarmerRegistrationScreenState createState() =>
      _FarmerRegistrationScreenState();
}

class _FarmerRegistrationScreenState extends State<FarmerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController kishanIdController = TextEditingController();

  void getOtp() {
    String phone = phoneController.text.trim();
    if (phone.length == 10) {
      // Logic to get OTP can be written here
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('OTP sent to $phone')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a valid 10-digit phone number')),
      );
    }
  }

  void registerFarmer() {
    if (_formKey.currentState!.validate()) {
      // Save farmer data or call API here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Farmer Registered Successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Registration'),
        backgroundColor: Colors.green.shade400,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildTextField(
                  controller: fullNameController,
                  label: 'Full Name',
                ),
                SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: buildTextField(
                        controller: phoneController,
                        label: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 58,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: getOtp,
                          child: Text('Get OTP'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                buildTextField(controller: addressController, label: 'Address'),
                SizedBox(height: 15),
                buildTextField(
                  controller: pincodeController,
                  label: 'Pincode',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 15),
                buildTextField(controller: stateController, label: 'State'),
                SizedBox(height: 15),
                buildTextField(
                  controller: aadharController,
                  label: 'Aadhar Number',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 15),
                buildTextField(
                  controller: kishanIdController,
                  label: 'Kishan ID',
                ),
                SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: registerFarmer,
                    child: Text('Register', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.green.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
