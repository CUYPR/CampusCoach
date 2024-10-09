import 'package:flutter/material.dart';

class attendance_upses extends StatelessWidget {
  const attendance_upses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
      ),backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'Upcoming Sessions',
          style: TextStyle(fontSize: 20, height: 2),
        ),
      ),
    );
  }
}