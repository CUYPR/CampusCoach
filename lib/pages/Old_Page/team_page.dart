// lib/pages/team_page.dart

import 'package:flutter/material.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with title
      appBar: AppBar(
        title: const Text('Team'),
        backgroundColor: const Color(0xFF455781),
      ),
      body: const Center(
        child: Text(
          'Team Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
