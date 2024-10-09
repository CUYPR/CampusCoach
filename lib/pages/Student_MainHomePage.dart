import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Student_MainHomePageNav/Student_MainHomePageNavAnalysis.dart';
import 'Student_MainHomePageNav/Student_MainHomePageNavLeave.dart';
import 'Student_MainHomePageNav/Student_MainHomePageNavAttendance.dart';
import 'Student_MainHomePageNav/Student_MainHomePageNavTeam.dart';

class PlayerHomePage extends StatefulWidget {
  const PlayerHomePage({super.key});
  @override
  _PlayerHomePageState createState() => _PlayerHomePageState();
}

class _PlayerHomePageState extends State<PlayerHomePage> {

  String _playerName = 'loading..';
  String _playerRegNo = 'loading..';
  String _overall = '80';
  String present = '13';
  String total = '15';
  String imageURL = 'assets/images/IMG_3976.JPG';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlayerName();
  }

  Future<void> _fetchPlayerName() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Fetch the user document from Firestore
        DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          setState(() {
            _playerName = userDoc.data()?['name'] ?? 'Player';
            _playerRegNo = userDoc.data()?['regNo'] ?? 'E404';
            _isLoading = false;
          });
        } else {
          setState(() {
            _playerName = 'Player';
            _playerRegNo = 'E404_1';
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data not found.')),
          );
        }
      } else {
        setState(() {
          _playerName = 'Player';
          _playerRegNo = 'E404_2';
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is currently signed in.')),
        );
      }
    } catch (e) {
      setState(() {
        _playerName = 'Player';
        _playerRegNo = 'E404_3';
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(

        child: Column(
          children: [
            HeaderWidget(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              userName: _playerName,
              userId: _playerRegNo,
              overall: '$_overall%',
              present: present,
              total: total,
              imageURL: imageURL,
            ),
            SizedBox(height: screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuButton(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  label: 'Attendance',
                  icon: Icons.class_outlined,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Student_MainHomePageNavAttendance()),
                    );
                  },
                ),
                SizedBox(width: screenWidth * 0.03),
                MenuButton(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  label: 'Leave',
                  icon: Icons.file_copy_outlined,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Student_MainHomePageNavLeave()),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.023),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MenuButton(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  label: 'Analysis',
                  icon: Icons.auto_graph_outlined,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Student_MainHomePageNavAnalysis()),
                    );
                  },
                ),
                SizedBox(width: screenWidth * 0.03),
                MenuButton(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  label: 'Team',
                  icon: Icons.people_alt_outlined,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Student_MainHomePageNavTeam()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class HeaderWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String userName;
  final String userId;
  final String overall;
  final String present;
  final String total;
  final String imageURL;

  const HeaderWidget({
    required this.screenWidth,
    required this.screenHeight,
    required this.userName,
    required this.userId,
    required this.overall,
    required this.present,
    required this.total,
    required this.imageURL,
  });

  @override
  Widget build(BuildContext context) {
    double largeTextSize = screenWidth * 0.08;
    double smallTextSize = screenWidth * 0.04;

    return Center(
      child: Container(
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
                        userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: largeTextSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userId,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: smallTextSize,
                        ),
                      ),
                    ],
                  ),

                  ProfilePictureWidget(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      image: imageURL),
                ],
              ),
            ),

            StatWidget(
              screenWidth: screenWidth,
              largeTextSize: largeTextSize,
              smallTextSize: smallTextSize,
              overall: overall,
              present: present,
              total: total,
            ),
          ],
        ),
      ),
    );
  }
}


class StatWidget extends StatelessWidget {
  final double screenWidth;
  final double largeTextSize;
  final double smallTextSize;
  final String overall;
  final String present;
  final String total;

  const StatWidget({
    required this.screenWidth,
    required this.largeTextSize,
    required this.smallTextSize,
    required this.overall,
    required this.present,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildStatColumn(overall, 'Overall', largeTextSize, smallTextSize),
          SizedBox(width: screenWidth * 0.07),
          buildStatColumn(present, 'Present', largeTextSize, smallTextSize),
          SizedBox(width: screenWidth * 0.07),
          buildStatColumn(total, 'Total', largeTextSize, smallTextSize),
        ],
      ),
    );
  }

  Widget buildStatColumn(
      String value, String label, double largeTextSize, double smallTextSize) {
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


class ProfilePictureWidget extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String image;

  const ProfilePictureWidget(
      {required this.screenWidth,
        required this.screenHeight,
        required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}


class MenuButton extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const MenuButton({
    required this.screenWidth,
    required this.screenHeight,
    required this.label,
    required this.icon,
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
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          minimumSize: MaterialStateProperty.all(const Size(10, 10)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 25,
              left: 12,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: smallTextSize + 7,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 9,
              child: Icon(
                icon,
                size: screenWidth * 0.155,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
