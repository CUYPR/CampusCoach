import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAbs_Student_MainHomePageNavAttendance extends StatefulWidget {
  @override
  _MainAttendanceMyAbsState createState() => _MainAttendanceMyAbsState();
}

class _MainAttendanceMyAbsState extends State<MyAbs_Student_MainHomePageNavAttendance> {
  int _expandedIndex = -1;
  List<_Item> _items = [];
  bool _isLoading = true;
  double _totalHoursMissed = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAbsencesData();
  }

  Future<void> _fetchAbsencesData() async {
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
        double totalHoursMissed = 0.0;

        for (var categoryDoc in categoriesSnapshot.docs) {
          String categoryName = categoryDoc.id;
          String displayCategoryName = _convertDocIdToTitle(categoryName);

          // Reference to the absences subcollection
          CollectionReference<Map<String, dynamic>> absencesRef = categoriesRef
              .doc(categoryName)
              .collection('absences');

          // Fetch all absences in this category
          QuerySnapshot<Map<String, dynamic>> absencesSnapshot = await absencesRef.get();

          for (var absenceDoc in absencesSnapshot.docs) {
            Map<String, dynamic> data = absenceDoc.data();

            // Extract fields
            String date = data['absenceDate'] ?? '';
            String day = data['absenceDay'] ?? '';
            double absentHours = (data['absentHours'] ?? 0).toDouble();
            int showGreenTag = data['showGreenTag'] ?? 0;
            int showGreyTag = data['showGreyTag'] ?? 0;

            // Update total hours missed
            totalHoursMissed += absentHours;

            // Create _Item instance
            _Item item = _Item(
              title: displayCategoryName,
              subtitle: date, // We can use date as subtitle
              date: date,
              showGreenTag: showGreenTag,
              showGreyTag: showGreyTag,
              trailingText: absentHours,
            );

            items.add(item);
          }
        }

        // Sort the items by date in descending order
        items.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

        // Update state
        setState(() {
          _items = items;
          _totalHoursMissed = totalHoursMissed;
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

  // Helper function to format hours
  String formatHours(double hours) {
    if (hours % 1 == 0) {
      return hours.toInt().toString();
    } else {
      return hours.toStringAsFixed(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double largeTextSize = screenWidth * 0.08;
    double smallTextSize = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Absences'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF455781)),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTotalHoursMissed(formatHours(_totalHoursMissed)),
          SizedBox(height: screenHeight * 0.03),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _items.isEmpty
                ? Center(child: Text('No absences data found.'))
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              itemCount: _groupAndSortItems(_items).length * 2,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return SizedBox(height: screenHeight * 0.02);
                }
                int itemIndex = index ~/ 2;

                return _buildExpansionTile(
                  context,
                  _groupAndSortItems(_items)[itemIndex],
                  itemIndex,
                  largeTextSize,
                  smallTextSize,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalHoursMissed(String calmissed) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: Text(
        "Total Hours Missed: $calmissed",
        style: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w600,
          color: Color(0xFF384F85),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(
      BuildContext context,
      List<_Item> items,
      int itemIndex,
      double largeTextSize,
      double smallTextSize,
      ) {
    // Calculate the total hours for the group
    double totalHours = items.fold(0.0, (sum, item) => sum + item.trailingText);

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFCBD6F6),
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
          key: Key('$itemIndex'),
          initiallyExpanded: _expandedIndex == itemIndex,
          title: _buildListTile(
            items.first,
            largeTextSize,
            smallTextSize,
            formatHours(totalHours),
          ),
          onExpansionChanged: (bool expanded) {
            setState(() {
              _expandedIndex = expanded ? itemIndex : -1;
            });
          },
          children: items.map((item) {
            return CustomDropdownItem(
              date: item.date,
              hour: formatHours(item.trailingText),
              tags: [
                if (item.showGreenTag == 1)
                  {'color': Colors.green, 'text': 'Green Tag'},
                if (item.showGreyTag == 1)
                  {'color': Colors.grey, 'text': 'Grey Tag'},
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  List<List<_Item>> _groupAndSortItems(List<_Item> items) {
    final Map<String, List<_Item>> groupedItems = {};

    // Group items by title and date
    for (var item in items) {
      final titleDateKey = '${item.title} - ${item.date}';

      if (groupedItems.containsKey(titleDateKey)) {
        groupedItems[titleDateKey]!.add(item);
      } else {
        groupedItems[titleDateKey] = [item];
      }
    }

    // Sort groups by date in descending order
    final sortedGroups = groupedItems.entries.toList()
      ..sort((a, b) => DateTime.parse(b.value.first.date).compareTo(DateTime.parse(a.value.first.date)));

    return sortedGroups.map((entry) => entry.value).toList();
  }

  Widget _buildListTile(
      _Item item,
      double largeTextSize,
      double smallTextSize,
      String totalHours,
      ) {
    DateTime parsedDate = DateTime.parse(item.date);
    String formattedDate = "${parsedDate.day}-${parsedDate.month}-${parsedDate.year}";

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        item.title,
        style: TextStyle(
          fontSize: smallTextSize,
          color: Color(0xFF566DA1),
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        formattedDate,
        style: TextStyle(
          fontSize: largeTextSize - 6,
          color: Color(0xFF566DA1),
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Text(
        totalHours,
        style: TextStyle(
          fontSize: smallTextSize,
          color: Color(0xFF566DA1),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class CustomDropdownItem extends StatelessWidget {
  final String date;
  final String hour;
  final List<Map<String, dynamic>> tags;

  const CustomDropdownItem({
    required this.date,
    required this.hour,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(date);
    String dayName = "${parsedDate.dayOfWeek}";

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$dayName - $hour',
            style: TextStyle(fontSize: 20, color: Color(0xFF566DA1)),
          ),
          Row(
            children: tags.map((tag) {
              return Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: tag['color'] as Color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag['text'] as String,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String get dayOfWeek {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }
}

class _Item {
  final String title;
  final String subtitle;
  final String date;
  final int showGreenTag;
  final int showGreyTag;
  final double trailingText;

  _Item({
    required this.title,
    required this.subtitle,
    String? date,
    this.showGreenTag = 0,
    this.showGreyTag = 0,
    this.trailingText = 1.0,
  }) : date = date ?? subtitle;
}
