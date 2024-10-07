// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'coach_home_page.dart'; // Import CoachHomePage
import 'player_home_page.dart'; // Import PlayerHomePage
import 'update_password_page.dart'; // Import UpdatePasswordPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false; // For showing a loading indicator

  void _login() async {
    String userId = _userIdController.text.trim();
    String password = _passwordController.text;
    String email;

    if (userId.contains('@')) {
      email = userId;
    } else {
      email = '$userId@campuscoach.com';
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Authenticate with Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Fetch user data from Firestore
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userData.exists) {
          String role = userData.data()?['role'] ?? 'No Role';
          bool isFirstLogin = userData.data()?['isFirstLogin'] ?? false;

          if (isFirstLogin) {
            // Navigate to UpdatePasswordPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UpdatePasswordPage()),
            );
          } else {
            // Navigate based on role
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
          }
        } else {
          // User data not found
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found.')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific authentication errors
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Incorrect password.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'user-disabled':
          message = 'User account has been disabled.';
          break;
        default:
          message = 'Authentication error: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtain the screen size for responsive design
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // Make the AppBar transparent and remove its elevation
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/images/BGGra2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Logo Positioned at the Top Center
          Positioned(
            top: 0, // 5% from the top
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/CHRISTLogo_colored.png', // Your logo asset
                width: screenSize.width * 0.75, // 75% of screen width
                height: screenSize.width * 0.75, // Maintain aspect ratio
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Custom White Box with PNG Shape
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                // The PNG Shape
                Image.asset(
                  'assets/images/CustomShape1.png',
                  width: screenSize.width,
                  height: screenSize.height * 0.55, // 55% of screen height
                  fit: BoxFit.cover,
                ),
                // The Content Inside the Shape
                Container(
                  width: screenSize.width,
                  height: screenSize.height * 0.55,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.15, // 15% padding on left and right
                    vertical: screenSize.height * 0.05, // 5% padding on top and bottom
                  ),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Greeting Text
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 5.0, top: 50.0), // Custom padding for 'Hello!'
                                child: Text(
                                  'Hello!',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Open_Sans',
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0, bottom: 40.0), // Custom padding for 'Log into the CampusCoach.'
                                child: Text(
                                  'Log into the CampusCoach.',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF6D6D6D),
                                    fontFamily: 'Inter', // Different font family
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // User ID TextField
                        TextField(
                          controller: _userIdController,
                          decoration: const InputDecoration(
                            labelText: 'User ID',
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02), // 2% height

                        // Password TextField
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: screenSize.height * 0.03), // 3% height

                        // Login Button
                        SizedBox(
                          width: screenSize.width * 0.4,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF566DA1), // Button background color (Hex color)
                              foregroundColor: Colors.white, // Text color
                              padding: const EdgeInsets.symmetric(vertical: 16.0), // Padding inside the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0), // Rounded corners (radius)
                              ),
                            ),
                            child: const Text(
                              'Login',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
