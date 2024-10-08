// lib/pages/attendance_page.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'attendance/attendance_myatt_page.dart';
import 'attendance/attendance_myabs_page.dart';
import 'attendance/attendance_ptatt_page.dart';
import 'attendance/attendance_upses_page.dart';
import 'login_page.dart'; // For logout functionality

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String _playerName = '';
  String _playerRegNo = '';
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPlayerData();
  }

  Future<void> _fetchPlayerData() async {
    try {
      // Get the current authenticated user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Fetch the user's document from Firestore
        DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          setState(() {
            _playerName = userDoc.data()?['name'] ?? 'Player';
            _playerRegNo = userDoc.data()?['regNo'] ?? 'N/A';
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'User data not found in Firestore.';
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found. Please contact admin.')),
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
        _errorMessage = 'Error fetching user data: $e';
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
            ? const Text('Attendance')
            : Text('Attendance - $_playerName'),
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
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Name and Registration Number
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
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
                              _playerRegNo,
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
                              'assets/images/IMG_3976.JPG',
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) {
                                return const Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    ));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Stats Row
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      children: [
                        // Overall Attendance
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
                        // Present Days
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
                        // Total Days
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
              // First Row of Buttons (My Attendance and Absent Details)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // My Attendance Button
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
                                const attendance_myatt()),
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
                                'My\nAttendance',
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
                                Icons.arrow_circle_right,
                                size: screenSize.height * 0.03,
                                color: const Color(0xFF6F83B1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenSize.width * 0.03),
                  // Absent Details Button
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
                                const attendance_myabs()),
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
                                'Absent\nDetails',
                                style: TextStyle(
                                  fontSize: smallTextSize + 7,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Open_Sans',
                                  height: 0.9,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 9,
                              child: Icon(
                                Icons.arrow_circle_right,
                                size: screenSize.height * 0.03,
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
              // Second Row of Buttons (Previous Term Attendance and Upcoming Sessions)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Previous Term Attendance Button
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
                                const attendance_ptatt()),
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
                                'Previous\nTerm\nAttendance',
                                style: TextStyle(
                                  fontSize: smallTextSize + 7,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Open_Sans',
                                  height: 0.9,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 9,
                              child: Icon(
                                Icons.arrow_circle_right,
                                size: screenSize.height * 0.03,
                                color: const Color(0xFF6F83B1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenSize.width * 0.03),
                  // Upcoming Sessions Button
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
                                const attendance_upses()),
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
                                'Upcoming\nSessions',
                                style: TextStyle(
                                  fontSize: smallTextSize + 7,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Open_Sans',
                                  height: 0.9,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 9,
                              child: Icon(
                                Icons.arrow_circle_right,
                                size: screenSize.height * 0.03,
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
