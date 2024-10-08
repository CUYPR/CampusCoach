import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'attendance/attendance_myatt_page.dart';
import 'attendance/attendance_myabs_page.dart';
import 'attendance/attendance_ptatt_page.dart';
import 'attendance/attendance_upses_page.dart';


class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double largeTextSize = screenWidth * 0.08;
    double smallTextSize = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.3,
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
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rudraksh',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: largeTextSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '2241340',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: smallTextSize,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: screenWidth * 0.02),
                            child: Container(
                              width: screenWidth * 0.26,
                              height: screenHeight * 0.33,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8E1EA),
                                border: Border.all(
                                  color: const Color(0xFF94A4C9),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30), // Ensure the image corners match the container
                                child: Image.asset(
                                  'assets/images/IMG_3976.JPG', // Path to the image
                                  fit: BoxFit.cover, // Adjust this to your needs (e.g., BoxFit.fill, BoxFit.contain)
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '87%',
                                  style: TextStyle(
                                    fontSize: largeTextSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Overall',
                                  style: TextStyle(
                                    fontSize: smallTextSize,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.07),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '13',
                                  style: TextStyle(
                                    fontSize: largeTextSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Present',
                                  style: TextStyle(
                                    fontSize: smallTextSize,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.07),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '15',
                                  style: TextStyle(
                                    fontSize: largeTextSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: smallTextSize,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.44,
                height: screenHeight * 0.17,
                padding: const EdgeInsets.all(3.7),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const attendance_myatt()));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF566DA1);
                      }
                      return const Color(0xC7C0CFFA);
                    }),
                    foregroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      }
                      return Colors.black;
                    }),
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                    minimumSize:
                    WidgetStateProperty.all(const Size(10, 10)),
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
                            height: 0.9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 9,
                        child: Icon(
                          Icons.arrow_circle_right,
                          size: screenHeight * 0.03,
                          color: const Color(0xFF6F83B1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Container(
                width: screenWidth * 0.44,
                height: screenHeight * 0.17,
                padding: const EdgeInsets.all(3.7),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const attendance_myabs()));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF566DA1);
                      }
                      return const Color(0xC7C0CFFA);
                    }),
                    foregroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      }
                      return Colors.black;
                    }),
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                    minimumSize:
                    WidgetStateProperty.all(const Size(10, 10)),
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
                              height: 0.9
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 9,
                        child: Icon(
                          Icons.arrow_circle_right,
                          size: screenHeight * 0.03,
                          color: const Color(0xFF6F83B1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.023),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.44,
                height: screenHeight * 0.17,
                padding: const EdgeInsets.all(3.7),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const main_attendance_ptatt()));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF566DA1);
                      }
                      return const Color(0xC7C0CFFA);
                    }),
                    foregroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      }
                      return Colors.black;
                    }),
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                    minimumSize:
                    WidgetStateProperty.all(const Size(10, 10)),
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
                              height: 0.9
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 9,
                        child: Icon(
                          Icons.arrow_circle_right,
                          size: screenHeight * 0.03,
                          color: const Color(0xFF6F83B1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Container(
                width: screenWidth * 0.44,
                height: screenHeight * 0.17,
                padding: const EdgeInsets.all(3.7),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const attendance_upses()));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF566DA1);
                      }
                      return const Color(0xC7C0CFFA);
                    }),
                    foregroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      }
                      return Colors.black;
                    }),
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                    minimumSize:
                    WidgetStateProperty.all(const Size(10, 10)),
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
                              height: 0.9
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 9,
                        child: Icon(
                          Icons.arrow_circle_right,
                          size: screenHeight * 0.03,
                          color: const Color(0xFF6F83B1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}