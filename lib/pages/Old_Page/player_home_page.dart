// lib/pages/player_home_page.dart

import 'package:flutter/material.dart';
import '../../login_page.dart'; // For logout navigation
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'attendance_page.dart'; // Ensure these imports point to your actual page files
import 'leave_page.dart';
import 'analysis_page.dart';
import 'team_page.dart';

class PlayerHomePage extends StatefulWidget {
  const PlayerHomePage({super.key});

  @override
  _PlayerHomePageState createState() => _PlayerHomePageState();
}

class _PlayerHomePageState extends State<PlayerHomePage> {
  String _playerName = '';
  String _playerRegNo = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlayerName();
  }

  Future<void> _fetchPlayerName() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Fetch the user document from Firestore
        DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          setState(() {
            _playerName = userDoc.data()?['name'] ?? 'Player';
            _playerRegNo = userDoc.data()?['regNo'] ?? 'E404';
            _isLoading = false;
          });
        } else {
          setState(() {
            _playerName = 'Player';
            _playerRegNo = 'E404_1';
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found.')),
          );
        }
      } else {
        setState(() {
          _playerName = 'Player';
          _playerRegNo = 'E404_2';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in.')),
        );
      }
    } catch (e) {
      setState(() {
        _playerName = 'Player';
        _playerRegNo = 'E404_3';
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
    // Obtain the screen size for responsive design
    final screenSize = MediaQuery.of(context).size;

    // Define text sizes based on screen width
    double largeTextSize = screenSize.width * 0.08;
    double smallTextSize = screenSize.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? const Text('Player Home')
            : const Text('Player Home'),
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
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.05, // 5% padding
            vertical: screenSize.height * 0.02, // 2% padding
          ),
          child: Column(
            children: [
              // Profile Card
              Container(
                width: screenSize.width * 0.9,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF455781),
                      Color(0xFF20283B),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Profile Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Name and ID
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _playerName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: largeTextSize,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Open_Sans',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _playerRegNo, // Replace with dynamic ID if available
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: smallTextSize,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        // Profile Image
                        Container(
                          width: screenSize.width * 0.26,
                          height: screenSize.height * 0.15,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8E1EA),
                            border: Border.all(
                              color: const Color(0xFF94A4C9),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'assets/images/IMG_3976.JPG', // Ensure the image exists
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Overall
                        Column(
                          children: [
                            Text(
                              '87%',
                              style: TextStyle(
                                fontSize: largeTextSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Open_Sans',
                              ),
                            ),
                            Text(
                              'Overall',
                              style: TextStyle(
                                fontSize: smallTextSize,
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        // Present
                        Column(
                          children: [
                            Text(
                              '13',
                              style: TextStyle(
                                fontSize: largeTextSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Open_Sans',
                              ),
                            ),
                            Text(
                              'Present',
                              style: TextStyle(
                                fontSize: smallTextSize,
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                        // Total
                        Column(
                          children: [
                            Text(
                              '15',
                              style: TextStyle(
                                fontSize: largeTextSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Open_Sans',
                              ),
                            ),
                            Text(
                              'Total',
                              style: TextStyle(
                                fontSize: smallTextSize,
                                color: Colors.white,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              // First Row of Buttons (Attendance and Leave)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Attendance Button
                  Expanded(
                    child: Container(
                      height: screenSize.height * 0.17,
                      padding: const EdgeInsets.all(3.7),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const AttendancePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xC7C0CFFA),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 25,
                              left: 12,
                              child: Text(
                                'Attendance',
                                style: TextStyle(
                                  fontSize: smallTextSize + 7,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Open_Sans',
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 9,
                              child: Icon(
                                Icons.class_outlined,
                                size: screenSize.height * 0.06,
                                color: const Color(0xFF6F83B1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenSize.width * 0.03),
                  // Leave Button
                  Expanded(
                    child: Container(
                      height: screenSize.height * 0.17,
                      padding: const EdgeInsets.all(3.7),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LeavePage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xC7C0CFFA),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 25,
                              left: 12,
                              child: Text(
                                'Leave',
                                style: TextStyle(
                                  fontSize: smallTextSize + 7,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Open_Sans',
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 9,
                              child: Icon(
                                Icons.file_copy_outlined,
                                size: screenSize.height * 0.06,
                                color: const Color(0xFF6F83B1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.023),
              // Second Row of Buttons (Analysis and Team)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Analysis Button
                  Expanded(
                    child: Container(
                      height: screenSize.height * 0.17,
                      padding: const EdgeInsets.all(3.7),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AnalysisPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xC7C0CFFA),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 25,
                              left: 12,
                              child: Text(
                                'Analysis',
                                style: TextStyle(
                                  fontSize: smallTextSize + 7,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Open_Sans',
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 9,
                              child: Icon(
                                Icons.auto_graph_outlined,
                                size: screenSize.height * 0.06,
                                color: const Color(0xFF6F83B1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenSize.width * 0.03),
                  // Team Button
                  Expanded(
                    child: Container(
                      height: screenSize.height * 0.17,
                      padding: const EdgeInsets.all(3.7),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TeamPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xC7C0CFFA),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 25,
                              left: 12,
                              child: Text(
                                'Team',
                                style: TextStyle(
                                  fontSize: smallTextSize + 7,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Open_Sans',
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 9,
                              child: Icon(
                                Icons.people_alt_outlined,
                                size: screenSize.height * 0.06,
                                color: const Color(0xFF6F83B1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
