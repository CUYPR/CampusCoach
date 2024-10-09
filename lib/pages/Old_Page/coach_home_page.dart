// lib/pages/coach_home_page.dart

import 'package:flutter/material.dart';
import '../../login_page.dart'; // For logout navigation
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoachHomePage extends StatefulWidget {
  const CoachHomePage({super.key});

  @override
  _CoachHomePageState createState() => _CoachHomePageState();
}

class _CoachHomePageState extends State<CoachHomePage> {
  String _coachName = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCoachName();
  }

  Future<void> _fetchCoachName() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Fetch the user document from Firestore
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _coachName = userDoc.data()?['name'] ?? 'Coach';
            _isLoading = false;
          });
        } else {
          setState(() {
            _coachName = 'Coach';
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found.')),
          );
        }
      } else {
        setState(() {
          _coachName = 'Coach';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in.')),
        );
      }
    } catch (e) {
      setState(() {
        _coachName = 'Coach';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

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
        title: _isLoading
            ? const Text('Coach Home')
            : Text('Coach Home - $_coachName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
          'Welcome, $_coachName!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
