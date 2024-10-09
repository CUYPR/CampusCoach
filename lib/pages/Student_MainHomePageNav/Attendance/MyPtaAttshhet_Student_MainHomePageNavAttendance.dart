import 'package:flutter/material.dart';

class MyPtaAttshhet_Student_MainHomePageNavAttendance extends StatefulWidget {
  @override
  _SubMainAttendanceDisplayState createState() => _SubMainAttendanceDisplayState();
}

class _SubMainAttendanceDisplayState extends State<MyPtaAttshhet_Student_MainHomePageNavAttendance> {
  int _expandedIndex = -1; // To keep track of the expanded item

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double largeTextSize = screenWidth * 0.08;
    double smallTextSize = screenWidth * 0.04;



    return Scaffold(
      appBar: AppBar(
        title: Text('Semester __'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAttendanceStatsContainer(screenWidth, screenHeight, largeTextSize, smallTextSize),
          SizedBox(height: screenHeight * 0.03),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              itemCount: _items.length * 2, // For SizedBox after each item
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return SizedBox(height: screenHeight * 0.02);
                }
                int itemIndex = index ~/ 2;
                return _buildExpandableItem(context, itemIndex, largeTextSize, smallTextSize);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for the attendance statistics container
  Widget _buildAttendanceStatsContainer(double screenWidth, double screenHeight, double largeTextSize, double smallTextSize) {

    final String overall = "87%";
    final String present= '13';
    final String total= '15';

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

  // Helper widget for the stats column
  Widget _buildStatColumn(String value, String label, double largeTextSize, double smallTextSize) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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

  // Helper widget for the expandable item
  Widget _buildExpandableItem(BuildContext context, int itemIndex, double largeTextSize, double smallTextSize) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xC7C0CFFA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          cardTheme: CardTheme(elevation: 0),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Container(
            height: MediaQuery.of(context).size.height * 0.1,
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
                SizedBox(height: 0),
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
          children: _expandedIndex == itemIndex
              ? _items[itemIndex].details.map((detail) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                detail,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF566DA1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList()
              : [],
        ),
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

final List<_Item> _items = [
  _Item(
    title: 'Basketball Training',
    subtitle: '78%',
    details: [
      'Conducted: 21',
      'Attended: 21',
      'Absent: 0',
      'Overall: 100%',
    ],
  ),
  _Item(
    title: 'Basketball Practice',
    subtitle: '89%',
    details: [
      'Conducted: 21',
      'Attended: 21',
      'Absent: 0',
      'Overall: 100%',
    ],
  ),
  _Item(
    title: 'Basketball Tournament',
    subtitle: '92%',
    details: [
      'Conducted: 21',
      'Attended: 21',
      'Absent: 0',
      'Overall: 100%',
    ],
  ),
];
