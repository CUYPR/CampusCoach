// lib/pages/leave_page.dart

import 'package:flutter/material.dart';

class LeavePage extends StatelessWidget {
  const LeavePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title
      appBar: AppBar(
        title: const Text('Leave'),
        backgroundColor: const Color(0xFF455781),
      ),
      body: const Center(
        child: Text(
          'Leave Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
