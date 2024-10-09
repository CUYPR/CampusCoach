import 'package:flutter/material.dart';

class MyAbs_Student_MainHomePageNavAttendance extends StatefulWidget {
  @override
  _MainAttendanceMyAbsState createState() => _MainAttendanceMyAbsState();
}

class _MainAttendanceMyAbsState extends State<MyAbs_Student_MainHomePageNavAttendance> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double largeTextSize = screenWidth * 0.08;
    double smallTextSize = screenWidth * 0.04;
    final calmissed = '9.0';

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Absences'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTotalHoursMissed(calmissed),
          SizedBox(height: screenHeight * 0.03),
          Expanded(
            child: ListView.builder(
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
    // Calculate the total trailingText for the group of items
    double totalHours = items.fold(0.0, (sum, item) => sum + double.parse(item.trailingText));

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
          title: _buildListTile(
            items.first,
            largeTextSize,
            smallTextSize,
            totalHours.toStringAsFixed(1), // Pass totalHours to display as trailingText
          ),
          onExpansionChanged: (bool expanded) {
            setState(() {
              _expandedIndex = expanded ? itemIndex : -1;
            });
          },
          children: _expandedIndex == itemIndex
              ? items.map((item) => CustomDropdownItem(
            date: item.date,
            hour: item.trailingText, // Display trailingText directly as hour
            tags: [
              if (item.showGreenTag == 1)
                {'color': Colors.green, 'text': 'Green Tag'},
              if (item.showGreyTag == 1)
                {'color': Colors.grey, 'text': 'Grey Tag'},
            ],
          )).toList()
              : [],
        ),
      ),
    );
  }

  List<List<_Item>> _groupAndSortItems(List<_Item> items) {
    final Map<String, List<_Item>> groupedItems = {};

    // First, sort the items by subtitle (actual date) in descending order
    items.sort((a, b) => DateTime.parse(b.subtitle).compareTo(DateTime.parse(a.subtitle)));

    for (var item in items) {
      final titleDateKey = '${item.title} - ${item.date}'; // Combining title and date

      if (groupedItems.containsKey(titleDateKey)) {
        groupedItems[titleDateKey]!.add(item);
      } else {
        groupedItems[titleDateKey] = [item];
      }
    }

    // Now we need to sort the groups by date
    final sortedGroups = <List<_Item>>[];
    groupedItems.forEach((titleDateKey, itemList) {
      // Already sorted by subtitle in descending order, just add them to sortedGroups
      sortedGroups.add(itemList);
    });

    return sortedGroups;
  }

  Widget _buildListTile(
      _Item item,
      double largeTextSize,
      double smallTextSize,
      String totalHours, // Receive total hours to display
      ) {
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
        item.date,
        style: TextStyle(
          fontSize: largeTextSize - 6,
          color: Color(0xFF566DA1),
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Text(
        totalHours, // Display the total hours for the group
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  '$dayName - $hour',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Spacer(),
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
  final int showGreenTag; // 0 or 1
  final int showGreyTag; // 0 or 1
  final String trailingText; // This will represent individual item's hours

  // Set default value of 'trailingText' to '1'
  // Set 'date' default to 'subtitle'
  _Item({
    required this.title,
    required this.subtitle,
    String? date, // Nullable field, will default to subtitle
    this.showGreenTag = 0, // Default value of 0
    this.showGreyTag = 0, // Default value of 0
    this.trailingText = '1', // Default value of '1'
  }) : date = date ?? subtitle; // If date is not provided, it defaults to subtitle
}

final List<_Item> _items = [
  _Item(
    title: 'Basketball Training',
    subtitle: '2024-09-12',
    showGreenTag: 0,
    showGreyTag: 0,
  ),
  _Item(
    title: 'Foosball Training',
    subtitle: '2024-09-13',
    showGreenTag: 0,
    showGreyTag: 0,
  ),
  _Item(
    title: 'Foosball Training',
    subtitle: '2024-09-10',
    showGreenTag: 0,
    showGreyTag: 0,
  ),
  _Item(
    title: 'Basketball Practice',
    subtitle: '2024-09-13',
    showGreenTag: 0,
    showGreyTag: 0,
  ),
  _Item(
    title: 'Basketball Tournament',
    subtitle: '2024-09-14',
    showGreenTag: 1,
    showGreyTag: 0,
  ),
];
