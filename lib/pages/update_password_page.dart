// lib/pages/update_password_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'coach_home_page.dart';
import 'player_home_page.dart';
import 'login_page.dart'; // For navigation in case of errors or re-authentication

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String newPassword = _newPasswordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Optional: Re-authenticate the user if required
        // Uncomment the following lines if you implement re-authentication
        /*
        bool isReauthenticated = await _reauthenticateUser();
        if (!isReauthenticated) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
        */

        // Update password in Firebase Authentication
        await user.updatePassword(newPassword);

        // Fetch user data from Firestore
        DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userData.exists) {
          String role = userData.data()?['role'] ?? 'No Role';

          // Update 'isFirstLogin' to false
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'isFirstLogin': false,
          });

          // Navigate to the appropriate home page based on role
          if (role == 'Coach') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CoachHomePage()),
            );
          } else if (role == 'Player') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PlayerHomePage()),
            );
          } else {
            // Handle unknown role
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unknown role. Please contact support.')),
            );
          }
        } else {
          // User data not found
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found.')),
          );
        }
      } else {
        // No user is signed in
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'requires-recent-login':
          message = 'Please log in again and try updating your password.';
          break;
        default:
          message = 'Password update failed: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Optional: Re-authenticate user if necessary
  Future<bool> _reauthenticateUser() async {
    // Implement re-authentication if required
    // For example, prompt user to enter current password
    // Return true if re-authenticated successfully, else false
    return true; // Placeholder
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the screen size for responsive design
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false, // Prevent back navigation
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.1, // 10% padding on left and right
            vertical: screenSize.height * 0.05, // 5% padding on top and bottom
          ),
          child: Form(
            key: _formKey,
            child: Column(
              // Center the contents vertically
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // "Update Password" Text
                Text(
                  'Update Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Open_Sans',
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02), // 2% height

                // Description Text
                Text(
                  'You can set your password once. If forgotten, contact the admin for reset.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[700],
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05), // 5% height

                // New Password TextField
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password.';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenSize.height * 0.02), // 2% height

                // Confirm Password TextField
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password.';
                    } else if (value != _newPasswordController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: screenSize.height * 0.05), // 5% height

                // Update Password Button
                SizedBox(
                  width: screenSize.width * 0.4, // 40% of screen width
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF566DA1), // Button background color
                      foregroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(vertical: 16.0), // Padding inside the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    )
                        : const Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 18.0, // Font size
                        fontWeight: FontWeight.bold, // Font weight
                        fontFamily: 'Open_Sans', // Custom font family
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
