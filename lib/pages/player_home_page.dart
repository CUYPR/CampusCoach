// lib/pages/player_home_page.dart

import 'package:flutter/material.dart';
import 'login_page.dart'; // For logout navigation
import 'package:firebase_auth/firebase_auth.dart';

class PlayerHomePage extends StatelessWidget {
  const PlayerHomePage({super.key});

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
        title: const Text('Player Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome, Player!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
