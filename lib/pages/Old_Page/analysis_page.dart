// lib/pages/analysis_page.dart

import 'package:flutter/material.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title
      appBar: AppBar(
        title: const Text('Analysis'),
        backgroundColor: const Color(0xFF455781),
      ),
      body: const Center(
        child: Text(
          'Analysis Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
