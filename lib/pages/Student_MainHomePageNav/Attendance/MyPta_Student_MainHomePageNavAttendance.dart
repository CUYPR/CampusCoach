import 'package:flutter/material.dart';
import 'MyPtaAttshhet_Student_MainHomePageNavAttendance.dart';

class MyPta_Student_MainHomePageNavAttendance extends StatefulWidget {
  @override
  State<MyPta_Student_MainHomePageNavAttendance> createState() => _MainAttendancePtattState();
}

class _MainAttendancePtattState extends State<MyPta_Student_MainHomePageNavAttendance> {
  // Simulated data for semesters and percentages
  final List<Map<String, String>> _semesterData = [
    {'semester': 'Semester 4', 'percentage': '23.38%'},
    {'semester': 'Semester 3', 'percentage': '20.12%'},
    {'semester': 'Semester 2', 'percentage': '18.75%'},
    {'semester': 'Semester 1', 'percentage': '15.90%'},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double containerHeight = screenHeight * 0.09; // 9% of screen height
    double containerWidth = screenWidth * 0.9; // 90% of screen width

    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Term Attendance'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _semesterData.map((data) {
            return Column(
              children: [
                _buildSemesterContainer(
                  context,
                  data['semester']!,
                  data['percentage']!,
                  containerHeight,
                  containerWidth,
                ),
                SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSemesterContainer(
      BuildContext context,
      String semester,
      String percentage,
      double height,
      double width,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyPtaAttshhet_Student_MainHomePageNavAttendance(),
          ),
        );
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Color(0xC7C0CFFA), // Background color
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                semester,
                style: TextStyle(
                  color: Color(0xFF566DA1), // Text color
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                percentage,
                style: TextStyle(
                  color: Color(0xFF566DA1), // Text color
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
