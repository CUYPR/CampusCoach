import 'package:flutter/material.dart';

class attendance_display extends StatefulWidget {
  const attendance_display({super.key});

  @override
  _SubMainAttendanceDisplayState createState() => _SubMainAttendanceDisplayState();
}

class _SubMainAttendanceDisplayState extends State<attendance_display> {
  int _expandedIndex = -1; // To keep track of the expanded item

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double largeTextSize = screenWidth * 0.08;
    double smallTextSize = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Semester __'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Attendance statistics container
          Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.16,
            margin: const EdgeInsets.only(top: 10),
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
                _buildStatColumn('87%', 'Overall', largeTextSize, smallTextSize),
                SizedBox(width: screenWidth * 0.07),
                _buildStatColumn('13', 'Present', largeTextSize, smallTextSize),
                SizedBox(width: screenWidth * 0.07),
                _buildStatColumn('15', 'Total', largeTextSize, smallTextSize),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // Expanded to prevent layout overflow
          Expanded(
            child: ListView.builder(
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
                    color: const Color(0xC7C0CFFA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent, // Remove black lines
                      cardTheme: const CardTheme(elevation: 0), // Remove shadow
                      splashColor: Colors.transparent, // Remove splash effect
                      highlightColor: Colors.transparent, // Remove highlight color
                    ),
                    child: ExpansionTile(
                      title: SizedBox(
                        height: screenHeight * 0.1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _items[itemIndex].title,
                              style: TextStyle(
                                fontSize: smallTextSize,
                                color: const Color(0xFF566DA1),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 0), // Space between title and subtext
                            Text(
                              _items[itemIndex].subtitle,
                              style: TextStyle(
                                fontSize: largeTextSize,
                                color: const Color(0xFF566DA1),
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
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            detail,
                            style: const TextStyle(fontSize: 16, color: Color(0xFF566DA1), fontWeight: FontWeight.w600),
                          ),
                        );
                      }).toList()
                          : [],
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