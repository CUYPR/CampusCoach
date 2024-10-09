import 'package:flutter/material.dart';
import 'Attendance/MyAtt_Student_MainHomePageNavAttendance.dart';
import 'Attendance/MyAbs_Student_MainHomePageNavAttendance.dart';
import 'Attendance/MyPta_Student_MainHomePageNavAttendance.dart';
import 'Attendance/MyUps_Student_MainHomePageNavAttendance.dart';

class Student_MainHomePageNavAttendance extends StatelessWidget {
  // Define constants
  final String playerName;
  final String playerRegNo;
  final String overall;
  final String present;
  final String total;
  final String imageURL;

  Student_MainHomePageNavAttendance({
    Key? key,
    required this.playerName,
    required this.playerRegNo,
    required this.overall,
    required this.present,
    required this.total,
    required this.imageURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double largeTextSize = screenWidth * 0.07;
    double smallTextSize = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.3,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF455781),
                      Color(0xFF20283B),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                playerName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: largeTextSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                playerRegNo,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: smallTextSize,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: screenWidth * 0.02),
                            child: Container(
                              width: screenWidth * 0.26,
                              height: screenHeight * 0.33,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD8E1EA),
                                border: Border.all(
                                  color: const Color(0xFF94A4C9),
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30), // Ensure the image corners match the container
                                child: Image.asset(
                                  imageURL, // Use the defined image URL
                                  fit: BoxFit.cover, // Adjust this to your needs (e.g., BoxFit.fill, BoxFit.contain)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  overall,
                                  style: TextStyle(
                                    fontSize: largeTextSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Overall',
                                  style: TextStyle(
                                    fontSize: smallTextSize,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.07),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  present,
                                  style: TextStyle(
                                    fontSize: largeTextSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Present',
                                  style: TextStyle(
                                    fontSize: smallTextSize,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.07),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  total,
                                  style: TextStyle(
                                    fontSize: largeTextSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: smallTextSize,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomElevatedButton(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                text: 'My\nAttendance',
                destinationPage: MyAtt_Student_MainHomePageNavAttendance(
                  overall: overall,
                  present: present,
                  total: total,
                ),
                icon: Icons.arrow_circle_right,
                color: const Color(0xFF6F83B1),
                context: context,
              ),
              SizedBox(width: screenWidth * 0.03),
              CustomElevatedButton(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                text: 'Absent\nDetails',
                destinationPage: MyAbs_Student_MainHomePageNavAttendance(),
                icon: Icons.arrow_circle_right,
                color: const Color(0xFF6F83B1),
                context: context,
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.023),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomElevatedButton(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                text: 'PTA\nDetails',
                destinationPage: MyPta_Student_MainHomePageNavAttendance(),
                icon: Icons.arrow_circle_right,
                color: const Color(0xFF6F83B1),
                context: context,
              ),
              SizedBox(width: screenWidth * 0.03),
              CustomElevatedButton(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                text: 'Update\nStatus',
                destinationPage: MyUps_Student_MainHomePageNavAttendance(),
                icon: Icons.arrow_circle_right,
                color: const Color(0xFF6F83B1),
                context: context,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String text;
  final Widget destinationPage;
  final IconData icon;
  final Color color;
  final BuildContext context;

  CustomElevatedButton({
    required this.screenWidth,
    required this.screenHeight,
    required this.text,
    required this.destinationPage,
    required this.icon,
    required this.color,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    double smallTextSize = screenWidth * 0.04;

    return Container(
      width: screenWidth * 0.44,
      height: screenHeight * 0.155,
      padding: const EdgeInsets.all(3.7),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destinationPage));
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color(0xFF566DA1);
            }
            return const Color(0xFFCBD6F6);
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
                text,
                style: TextStyle(
                  fontSize: smallTextSize + 7,
                  fontWeight: FontWeight.bold,
                  height: 0.9,
                ),
              ),
            ),
            Positioned(
              bottom: 11,
              right: 9,
              child: Icon(
                icon,
                size: screenHeight * 0.05,
                  color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
