import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAtt_Student_MainHomePageNavAttendance extends StatefulWidget {
  final String overall;
  final String present;
  final String total;

  MyAtt_Student_MainHomePageNavAttendance({
    Key? key,
    required this.overall,
    required this.present,
    required this.total,
  }) : super(key: key);

  @override
  _MainAttendanceMyAttState createState() => _MainAttendanceMyAttState();
}

class _MainAttendanceMyAttState extends State<MyAtt_Student_MainHomePageNavAttendance> {
  int _expandedIndex = -1;
  List<_Item> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoriesData();
  }

  Future<void> _fetchCategoriesData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Reference to the categories collection
        CollectionReference<Map<String, dynamic>> categoriesRef = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('attendance')
            .doc('currentSemester')
            .collection('categories');

        // Fetch all categories
        QuerySnapshot<Map<String, dynamic>> categoriesSnapshot = await categoriesRef.get();

        List<_Item> items = [];

        for (var doc in categoriesSnapshot.docs) {
          String docId = doc.id;
          Map<String, dynamic>? data = doc.data();

          // Extract fields
          double totalHoursConducted = (data['totalHoursConducted'] ?? 0).toDouble();
          double totalPresent = (data['totalPresent'] ?? 0).toDouble();
          double totalAbsent = (data['totalAbsent'] ?? 0).toDouble();

          // Calculate percentage
          String percentage = '0';
          if (totalHoursConducted > 0) {
            double percent = (totalPresent / totalHoursConducted) * 100;
            percentage = percent.toStringAsFixed(2);
          }

          // Convert docId to display title
          String title = _convertDocIdToTitle(docId);

          // Create _Item instance
          _Item item = _Item(
            title: title,
            subtitle: '$percentage%',
            details: [
              'Conducted: ${totalHoursConducted.toStringAsFixed(0)}',
              'Attended: ${totalPresent.toStringAsFixed(0)}',
              'Absent: ${totalAbsent.toStringAsFixed(0)}',
              'Overall: $percentage%',
            ],
          );

          items.add(item);
        }

        setState(() {
          _items = items;
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

  // Helper function to convert docId to title
  String _convertDocIdToTitle(String docId) {
    // Example: 'practiceSessions' -> 'Practice Sessions'
    String title = docId.replaceAllMapped(RegExp(r'([A-Z])'), (Match m) => ' ${m[0]}');
    title = title[0].toUpperCase() + title.substring(1);
    return title.trim();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double largeTextSize = screenWidth * 0.08;
    double smallTextSize = screenWidth * 0.04;

    // Remove the constants and use the values from the widget
    String overall = widget.overall;
    String present = widget.present;
    String total = widget.total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF455781)),
        elevation: 0, // Remove shadow
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Attendance statistics container
          AttendanceStatsContainer(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            overall: overall,
            present: present,
            total: total,
            largeTextSize: largeTextSize,
            smallTextSize: smallTextSize,
          ),
          SizedBox(height: screenHeight * 0.03),

          // Expanded to prevent layout overflow
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _items.isEmpty
                ? Center(child: Text('No attendance data found.'))
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              itemCount: _items.length * 2, // For SizedBox after each item
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  // Return a SizedBox between items
                  return SizedBox(height: screenHeight * 0.02);
                }
                int itemIndex = index ~/ 2;

                return Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFCBD6F6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent, // Remove black lines
                      cardTheme: CardTheme(elevation: 0), // Remove shadow
                      splashColor: Colors.transparent, // Remove splash effect
                      highlightColor: Colors.transparent, // Remove highlight color
                    ),
                    child: ExpansionTile(
                      key: Key('$itemIndex'), // Add a unique key
                      initiallyExpanded: _expandedIndex == itemIndex,
                      title: Container(
                        height: screenHeight * 0.1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _items[itemIndex].title,
                              style: TextStyle(
                                fontSize: smallTextSize,
                                color: Color(0xFF566DA1),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 0), // Space between title and subtext
                            Text(
                              _items[itemIndex].subtitle,
                              style: TextStyle(
                                fontSize: largeTextSize,
                                color: Color(0xFF566DA1),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _expandedIndex = expanded ? itemIndex : -1;
                        });
                      },
                      children: _items[itemIndex].details.map((detail) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            detail,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF566DA1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceStatsContainer extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String overall;
  final String present;
  final String total;
  final double largeTextSize;
  final double smallTextSize;

  AttendanceStatsContainer({
    required this.screenWidth,
    required this.screenHeight,
    required this.overall,
    required this.present,
    required this.total,
    required this.largeTextSize,
    required this.smallTextSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.16,
      margin: EdgeInsets.only(top: 10),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatColumn(overall, 'Overall', largeTextSize, smallTextSize),
          SizedBox(width: screenWidth * 0.07),
          _buildStatColumn(present, 'Present', largeTextSize, smallTextSize),
          SizedBox(width: screenWidth * 0.07),
          _buildStatColumn(total, 'Total', largeTextSize, smallTextSize),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
      String value, String label, double largeTextSize, double smallTextSize) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: largeTextSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: smallTextSize,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 0.1),
        ],
      ),
    );
  }
}

class _Item {
  final String title;
  final String subtitle;
  final List<String> details;

  _Item({required this.title, required this.subtitle, required this.details});
}
