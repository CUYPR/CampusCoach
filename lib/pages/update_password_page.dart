// lib/pages/update_password_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'coach_home_page.dart';
import 'player_home_page.dart';
import 'admin_home_page.dart';
// For navigation in case of errors or re-authentication

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
      print('Form validation failed');
      return;
    }

    String newPassword = _newPasswordController.text.trim();
    print('New password: $newPassword');

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('Current user ID: ${user.uid}');

        // Re-authenticate the user
        bool isReauthenticated = await _reauthenticateUser();
        if (!isReauthenticated) {
          print('Re-authentication failed');
          setState(() {
            _isLoading = false;
          });
          return;
        } else {
          print('Re-authentication successful');
        }

        // Update password in Firebase Authentication
        await user.updatePassword(newPassword);
        print('Password updated in Firebase Authentication');

        // Fetch user data from Firestore
        DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userData.exists) {
          Map<String, dynamic>? data = userData.data();
          print('User data from Firestore: $data');

          String role = data?['role'] ?? 'No Role';
          print('User role: $role');

          // Prepare update data
          Map<String, dynamic> updateData = {
            'isFirstLogin': false,
            // 'updatedAt': FieldValue.serverTimestamp(),
          };
          print('Update data: $updateData');

          // Update 'isFirstLogin' to false
          await FirebaseFirestore.instance.collection('users').doc(user.uid).update(updateData);
          print('User document updated in Firestore');

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
          } else if (role == 'Admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminPage()),
            );
          } else {
            // Handle unknown role
            print('Unknown role');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Unknown role. Please contact support.')),
            );
          }
        } else {
          // User data not found
          print('User data not found in Firestore');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found.')),
          );
        }
      } else {
        // No user is signed in
        print('No user is currently signed in');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
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
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.message}')),
      );
    } catch (e) {
      print('Exception: ${e.toString()}');
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
    String? currentPassword;
    // Prompt the user to enter their current password
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Re-authenticate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter your current password to confirm:'),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
              onChanged: (value) {
                currentPassword = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Confirm
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (currentPassword == null || currentPassword!.isEmpty) {
      print('User canceled re-authentication or did not enter a password');
      return false; // User canceled or did not enter a password
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword!,
        );

        await user.reauthenticateWithCredential(credential);
        print('Re-authentication successful');
        return true; // Re-authentication successful
      }
    } on FirebaseAuthException catch (e) {
      print('Re-authentication failed: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Re-authentication failed: ${e.message}')),
      );
    }
    return false; // Re-authentication failed
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
                const Text(
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
