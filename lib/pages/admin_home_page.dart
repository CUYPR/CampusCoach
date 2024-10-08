// lib/pages/admin_home_page.dart

import 'package:flutter/material.dart';
import 'login_page.dart'; // For logout
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'manage_users_page.dart'; // Placeholder for managing users
import 'view_reports_page.dart'; // Placeholder for viewing reports

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String _adminName = '';
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAdminData();
  }

  Future<void> _fetchAdminData() async {
    try {
      // Get the current authenticated user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Fetch the user's document from Firestore
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            _adminName = userDoc.data()?['name'] ?? 'Admin';
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Admin data not found in Firestore.';
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Admin data not found. Please contact support.')),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'No user is currently signed in.';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in.')),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching admin data: $e';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching admin data: $e')),
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
    // Obtain the screen size for responsive design
    final screenSize = MediaQuery.of(context).size;

    // Define text sizes based on screen width
    double largeTextSize = screenSize.width * 0.08;
    double smallTextSize = screenSize.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? const Text('Admin Dashboard')
            : Text('Admin Dashboard - $_adminName'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      )
          : Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.09,
          vertical: screenSize.height * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $_adminName!',
              style: TextStyle(
                fontSize: largeTextSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'Open_Sans',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenSize.height * 0.05),
            // Manage Users Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageUsersPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF566DA1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Manage Users',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Open_Sans',
                ),
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),
            // View Reports Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewReportsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF566DA1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'View Reports',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Open_Sans',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
