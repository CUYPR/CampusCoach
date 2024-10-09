import 'package:flutter/material.dart';

import 'Leave/LeaveApplication_StudentformLeave.dart';
import 'Leave/LeaveStatus_StudentformLeaveStatus.dart';

class Student_MainHomePageNavLeave extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double largeTextSize = screenWidth * 0.08;
    double smallTextSize = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          ProfileContainer(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            largeTextSize: largeTextSize,
            smallTextSize: smallTextSize,
          ),
          SizedBox(height: screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              CustomElevatedButton(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                text: 'Apply For\nLeave',
                icon: Icons.arrow_circle_right,
                color: const Color(0xFF6F83B1),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveApplication_StudentformLeave()));
                },
              ),
              SizedBox(width: screenWidth * 0.03),
              
              CustomElevatedButton(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                text: 'Application\nStatus',
                icon: Icons.arrow_circle_right,
                color: const Color(0xFF6F83B1),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveStatus_StudentformLeaveStatus()));
                },
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.023),
        ],
      ),
    );
  }
}


class CustomElevatedButton extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  CustomElevatedButton({
    required this.screenWidth,
    required this.screenHeight,
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double smallTextSize = screenWidth * 0.04;

    return Container(
      width: screenWidth * 0.44,
      height: screenHeight * 0.155,
      padding: const EdgeInsets.all(3.7),
      child: ElevatedButton(
        onPressed: onPressed,
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


class ProfileContainer extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final double largeTextSize;
  final double smallTextSize;

  ProfileContainer({
    required this.screenWidth,
    required this.screenHeight,
    required this.largeTextSize,
    required this.smallTextSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                          'Rudraksh',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: largeTextSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '2241340',
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
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/images/IMG_3976.JPG',
                            fit: BoxFit.cover,
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
                    ProfileStat(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      value: '87%',
                      label: 'Overall',
                      largeTextSize: largeTextSize,
                      smallTextSize: smallTextSize,
                    ),
                    SizedBox(width: screenWidth * 0.07),
                    ProfileStat(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      value: '13',
                      label: 'Present',
                      largeTextSize: largeTextSize,
                      smallTextSize: smallTextSize,
                    ),
                    SizedBox(width: screenWidth * 0.07),
                    ProfileStat(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      value: '15',
                      label: 'Total',
                      largeTextSize: largeTextSize,
                      smallTextSize: smallTextSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class ProfileStat extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String value;
  final String label;
  final double largeTextSize;
  final double smallTextSize;

  ProfileStat({
    required this.screenWidth,
    required this.screenHeight,
    required this.value,
    required this.label,
    required this.largeTextSize,
    required this.smallTextSize,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: largeTextSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: smallTextSize,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
