// lib/pages/view_reports_page.dart

import 'package:flutter/material.dart';

class ViewReportsPage extends StatelessWidget {
  const ViewReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Reports'),
        backgroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          'View Reports Page - To be implemented',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
