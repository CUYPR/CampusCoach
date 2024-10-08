// lib/pages/attendance_page.dart

import 'package:flutter/material.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: const Color(0xFF455781), // Consistent with your player home page
      ),
      body: const Center(
        child: Text(
          'Attendance Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
