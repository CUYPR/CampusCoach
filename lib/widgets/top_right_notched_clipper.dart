// lib/widgets/top_right_notched_clipper.dart

import 'package:flutter/material.dart';

class TopRightNotchedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double notchWidth = 50.0; // Width of the notch
    double notchHeight = 50.0; // Height of the notch
    double borderRadius = 24.0; // Radius for other corners

    // Start from the top-left corner with a rounded radius
    path.moveTo(borderRadius, 0);
    path.quadraticBezierTo(0, 0, 0, borderRadius);

    // Left side
    path.lineTo(0, size.height - borderRadius);
    path.quadraticBezierTo(0, size.height, borderRadius, size.height);

    // Bottom side
    path.lineTo(size.width - borderRadius, size.height);
    path.quadraticBezierTo(size.width, size.height, size.width, size.height - borderRadius);

    // Right side up to the notch
    path.lineTo(size.width, notchHeight + borderRadius);
    path.quadraticBezierTo(
      size.width,
      notchHeight,
      size.width - borderRadius,
      notchHeight,
    );

    // Create the upward notch
    path.lineTo(size.width - notchWidth, 0);

    // Top side with rounded corner
    path.lineTo(borderRadius, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // Since our clipper has no dynamic properties, we return false.
    return false;
  }
}
