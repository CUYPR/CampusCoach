// lib/pages/coach_home_page.dart

import 'package:flutter/material.dart';
import 'login_page.dart'; // For logout navigation
import 'package:firebase_auth/firebase_auth.dart';

class CoachHomePage extends StatelessWidget {
  const CoachHomePage({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome, Coach!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
