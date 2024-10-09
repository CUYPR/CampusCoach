import 'package:flutter/material.dart';

class LeaveStatus_StudentformLeaveStatus extends StatefulWidget {
  @override
  _MainLeaveStatusState createState() => _MainLeaveStatusState();
}

class _MainLeaveStatusState extends State<LeaveStatus_StudentformLeaveStatus> {
  String _filter = 'All';

  
  final List<_Item> _items = [
    _Item(
      registerNumber: '2241340',
      subjectLeaved: 'Sick Leave',
      startDate: DateTime(2024, 9, 1),
      endDate: DateTime(2024, 9, 5),
      appliedOn: DateTime(2024, 8, 30),
      reviewedOn: DateTime(2024, 8, 31),
      result: 'Pending',
    ),
    _Item(
      registerNumber: '2241341',
      subjectLeaved: 'Annual Leave',
      startDate: DateTime(2024, 9, 10),
      endDate: DateTime(2024, 9, 15),
      appliedOn: DateTime(2024, 9, 1),
      reviewedOn: DateTime(2024, 9, 2),
      result: 'Approved',
    ),
    _Item(
      registerNumber: '2241342',
      subjectLeaved: 'Emergency Leave',
      startDate: DateTime(2024, 9, 20),
      endDate: DateTime(2024, 9, 22),
      appliedOn: DateTime(2024, 9, 15),
      reviewedOn: DateTime(2024, 9, 16),
      result: 'Rejected',
    ),
  ];

  void _setFilter(String filter) {
    setState(() {
      _filter = filter;
    });
  }

  List<_Item> get _filteredItems {
    switch (_filter) {
      case 'Pending':
        return _items.where((item) => item.result == 'Pending').toList();
      case 'Reviewed':
        return _items.where((item) => item.result != 'Pending').toList();
      default:
        return _items;
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
        title: Text('Application Status'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusButton(
                  context,
                  'All\nLeaves',
                  '56', 
                      () {
                    
                  },
                ),
                _buildStatusButton(
                  context,
                  'Approved\nLeaves',
                  '42', 
                      () {
                    
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterButton(context, 'All', () => _setFilter('All')),
                SizedBox(width: screenWidth * 0.02),
                _buildFilterButton(context, 'Pending', () => _setFilter('Pending')),
                SizedBox(width: screenWidth * 0.02),
                _buildFilterButton(context, 'Reviewed', () => _setFilter('Reviewed')),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return _buildItemCard(_filteredItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context, String title, String number, VoidCallback onPressed) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double smallTextSize = screenWidth * 0.04;

    return Container(
      width: MediaQuery.of(context).size.width * 0.44,
      height: MediaQuery.of(context).size.height * 0.17,
      padding: const EdgeInsets.all(3.7),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color(0xFF566DA1);
            }
            return const Color(0xC7C0CFFA);
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white;
            }
            return Colors.black;
          }),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
          minimumSize: MaterialStateProperty.all(const Size(10, 10)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 25,
              left: 12,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: smallTextSize + 7,
                  height: 1.08,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 9,
              child: Text(
                number,
                style: TextStyle(
                  fontSize: screenHeight * 0.06,
                  color: const Color(0xFF6F83B1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String label, VoidCallback onPressed) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double smallTextSize = screenWidth * 0.04;

    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            const Color(0xFF566DA1),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            Colors.white,
          ),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          minimumSize: MaterialStateProperty.all(Size(screenWidth * 0.25, screenHeight * 0.05)),
        ),
        child: Container(
          height: screenHeight * 0.04,
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: smallTextSize - 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(_Item item) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double smallTextSize = screenWidth * 0.04;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), 
      ),
      color: const Color(0xFFCBD6F6), 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardText('Register Number:', item.registerNumber, smallTextSize),
            SizedBox(height: 8),
            _buildCardText('Subject:', item.subjectLeaved, smallTextSize),
            SizedBox(height: 8),
            _buildCardText('Start Date:', item.startDate.toLocal().toString().split(' ')[0], smallTextSize),
            _buildCardText('End Date:', item.endDate.toLocal().toString().split(' ')[0], smallTextSize),
            SizedBox(height: 8),
            _buildCardText('Applied On:', item.appliedOn.toLocal().toString().split(' ')[0], smallTextSize),
            _buildCardText('Reviewed On:', item.reviewedOn.toLocal().toString().split(' ')[0], smallTextSize),
            SizedBox(height: 8),
            Text(
              'Result: ${item.result}',
              style: TextStyle(
                fontSize: smallTextSize,
                fontWeight: FontWeight.bold,
                color: item.result == 'Approved'
                    ? Colors.green
                    : item.result == 'Rejected'
                    ? Colors.red
                    : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardText(String label, String value, double smallTextSize) {
    return Row(
      children: [
        Text(
          '$label ',
          style: TextStyle(
            fontSize: smallTextSize,
            fontWeight: FontWeight.w500,
            color: Colors.black, 
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: smallTextSize,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF384F85), 
            ),
          ),
        ),
      ],
    );
  }
}

class _Item {
  final String registerNumber;
  final String subjectLeaved;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime appliedOn;
  final DateTime reviewedOn;
  final String result;

  _Item({
    required this.registerNumber,
    required this.subjectLeaved,
    required this.startDate,
    required this.endDate,
    required this.appliedOn,
    required this.reviewedOn,
    required this.result,
  });
}
