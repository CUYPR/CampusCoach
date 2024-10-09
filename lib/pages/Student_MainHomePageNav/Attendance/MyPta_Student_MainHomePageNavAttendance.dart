import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MyPtaAttshhet_Student_MainHomePageNavAttendance.dart';

class MyPta_Student_MainHomePageNavAttendance extends StatefulWidget {
  @override
  State<MyPta_Student_MainHomePageNavAttendance> createState() => _MainAttendancePtattState();
}

class _MainAttendancePtattState extends State<MyPta_Student_MainHomePageNavAttendance> {
  // List to store semester data
  List<Map<String, String>> _semesterData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSemesterData();
  }

  Future<void> _fetchSemesterData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Reference to the attendance collection
        CollectionReference<Map<String, dynamic>> attendanceRef = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('attendance');

        // Fetch all semester documents
        QuerySnapshot<Map<String, dynamic>> attendanceSnapshot = await attendanceRef.get();

        List<Map<String, String>> semesterData = [];

        for (var doc in attendanceSnapshot.docs) {
          String docId = doc.id;

          // Ignore 'currentSemester' document
          if (docId == 'currentSemester') {
            continue;
          }

          Map<String, dynamic>? data = doc.data();

          double totalPresent = (data['totalPresent'] ?? 0).toDouble();
          double totalHoursConducted = (data['totalHoursConducted'] ?? 0).toDouble();

          String percentage = '0%';
          if (totalHoursConducted > 0) {
            double percent = (totalPresent / totalHoursConducted) * 100;
            percentage = percent.toStringAsFixed(2) + '%';
          }

          // Convert docId to semester name
          String semesterName = _convertDocIdToSemesterName(docId);

          semesterData.add({
            'semester': semesterName,
            'percentage': percentage,
            'docId': docId, // Store docId for navigation or further use
          });
        }

        // Sort semesters in descending order (e.g., Semester 4, Semester 3, etc.)
        semesterData.sort((a, b) => _extractSemesterNumber(b['semester']!).compareTo(_extractSemesterNumber(a['semester']!)));

        setState(() {
          _semesterData = semesterData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  String _convertDocIdToSemesterName(String docId) {
    // Example: 'semester1' -> 'Semester 1'
    if (docId.toLowerCase().startsWith('semester')) {
      String number = docId.substring(8); // Extract the number part
      return 'Semester $number';
    } else {
      // If the docId doesn't start with 'semester', return it as is
      return docId;
    }
  }

  int _extractSemesterNumber(String semesterName) {
    // Extract the number from 'Semester X' for sorting purposes
    try {
      return int.parse(semesterName.split(' ')[1]);
    } catch (e) {
      return 0;
    }
  }

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
        iconTheme: IconThemeData(color: Color(0xFF455781)),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _semesterData.isEmpty
          ? Center(child: Text('No previous semester data found.'))
          : Padding(
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
                  data['docId']!,
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
      String docId,
      ) {
    return GestureDetector(
      onTap: () {
        // Pass the docId to the next screen if needed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyPtaAttshhet_Student_MainHomePageNavAttendance(
              // semesterDocId: docId,
            ),
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
