import 'package:flutter/material.dart';

class attendance_myabs extends StatefulWidget {
  const attendance_myabs({super.key});

  @override
  _MainAttendanceMyAbsState createState() => _MainAttendanceMyAbsState();
}

class _MainAttendanceMyAbsState extends State<attendance_myabs> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double largeTextSize = screenWidth * 0.08;
    double smallTextSize = screenWidth * 0.04;
    const calmissed = '9.0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Absences'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Attendance statistics container
          Container(
            margin: const EdgeInsets.only(top: 12),
            child: const Text(
              "Total Hours Missed: $calmissed",
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                color: Color(0xFF384F85),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // Expanded to prevent layout overflow
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              itemCount: _groupAndSortItems(_items).length * 2, // For SizedBox after each item
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
                      title: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          _groupAndSortItems(_items)[itemIndex].first.title,
                          style: TextStyle(
                            fontSize: smallTextSize,
                            color: const Color(0xFF566DA1),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          _groupAndSortItems(_items)[itemIndex].first.date,
                          style: TextStyle(
                            fontSize: largeTextSize,
                            color: const Color(0xFF566DA1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          _groupAndSortItems(_items)[itemIndex].first.trailingText,
                          style: TextStyle(
                            fontSize: smallTextSize,
                            color: const Color(0xFF566DA1),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onExpansionChanged: (bool expanded) {
                        setState(() {
                          _expandedIndex = expanded ? itemIndex : -1;
                        });
                      },
                      children: _expandedIndex == itemIndex
                          ? _groupAndSortItems(_items)[itemIndex].map((item) {
                        return CustomDropdownItem(
                          date: item.date,
                          hour: item.trailingText,
                          tags: [
                            if (item.showGreenTag)
                              {'color': Colors.green, 'text': 'Green Tag'},
                            if (item.showGreyTag)
                              {'color': Colors.grey, 'text': 'Grey Tag'},
                          ],
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

  List<List<_Item>> _groupAndSortItems(List<_Item> items) {
    final Map<String, Map<String, List<_Item>>> groupedItems = {};

    for (var item in items) {
      final title = item.title;
      final date = item.date;

      if (groupedItems.containsKey(title)) {
        if (groupedItems[title]!.containsKey(date)) {
          groupedItems[title]![date]!.add(item);
        } else {
          groupedItems[title]![date] = [item];
        }
      } else {
        groupedItems[title] = {date: [item]};
      }
    }

    // Convert map to a list of grouped and sorted items
    final sortedGroups = <List<_Item>>[];
    groupedItems.forEach((title, dateMap) {
      final sortedDates = dateMap.entries.toList()
        ..sort((a, b) => DateTime.parse(a.key).compareTo(DateTime.parse(b.key)));

      for (var entry in sortedDates) {
        sortedGroups.add(entry.value);
      }
    });

    return sortedGroups;
  }
}

class CustomDropdownItem extends StatelessWidget {
  final String date;
  final String hour;
  final List<Map<String, dynamic>> tags;

  const CustomDropdownItem({super.key, 
    required this.date,
    required this.hour,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.parse(date);
    String dayName = parsedDate.dayOfWeek; // Get day name

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  '$dayName - $hour',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const Spacer(),
                Row(
                  children: tags.map((tag) {
                    return Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: tag['color'] as Color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag['text'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
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
  final String subtitle; // Now corresponds to date
  final String date; // Date is non-nullable
  final bool showGreenTag;
  final bool showGreyTag;
  final String trailingText;
  final String detail; // Numeric value or other details

  _Item({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.showGreenTag,
    required this.showGreyTag,
    required this.trailingText,
    required this.detail,
  });
}

final List<_Item> _items = [
  _Item(
    title: 'Basketball Training',
    subtitle: '2024-09-12',
    date: '2024-09-12',
    showGreenTag: true,
    showGreyTag: false,
    trailingText: '2.0',
    detail: 'Conducted: 21\nAttended: 21\nAbsent: 0\nOverall: 100%',
  ),
  _Item(
    title: 'Basketball Training',
    subtitle: '2024-09-12',
    date: '2024-09-12',
    showGreenTag: true,
    showGreyTag: false,
    trailingText: '2.0',
    detail: 'Conducted: 21\nAttended: 21\nAbsent: 0\nOverall: 100%',
  ),
  _Item(
    title: 'Basketball Practice',
    subtitle: '2024-09-13',
    date: '2024-09-13',
    showGreenTag: false,
    showGreyTag: true,
    trailingText: '1.0',
    detail: 'Conducted: 15\nAttended: 14\nAbsent: 1\nOverall: 93%',
  ),
  _Item(
    title: 'Basketball Tournament',
    subtitle: '2024-09-14',
    date: '2024-09-14',
    showGreenTag: true,
    showGreyTag: true,
    trailingText: '2.0',
    detail: 'Conducted: 21\nAttended: 21\nAbsent: 0\nOverall: 100%',
  ),

];