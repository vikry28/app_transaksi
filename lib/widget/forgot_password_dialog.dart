import 'package:app_transaksi_barang/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ForgotPasswordDialog extends StatelessWidget {
  final TextEditingController upadateemailController = TextEditingController();
  final TextEditingController upadatepassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Forgot Password', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10.0),
              const Text('Enter your email to reset password:'),
              TextFormField(
                controller: upadateemailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10.0),
              const Text('Enter your new password:'),
              TextFormField(
                controller: upadatepassController,
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF325E8C),
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                onPressed: () async {
                  String email = upadateemailController.text;
                  String newPassword = upadatepassController.text;

                  if (email.isNotEmpty && newPassword.isNotEmpty) {
                    Provider.of<UserProvider>(context, listen: false)
                              .updatePassword(email, newPassword);
                    Navigator.of(context).pop(); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password reset successful!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error resetting password. Please try again.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage in your code:


