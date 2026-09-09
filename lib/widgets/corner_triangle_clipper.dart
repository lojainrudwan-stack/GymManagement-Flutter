import 'package:flutter/material.dart';

enum CornerPosition { topRight, bottomLeft }

/// Custom clipper for warm-brown corner decorative triangles.
class CornerTriangleClipper extends CustomClipper<Path> {
  final CornerPosition corner;

  const CornerTriangleClipper({required this.corner});

  @override
  Path getClip(Size size) {
    final path = Path();
    if (corner == CornerPosition.topRight) {
      path.moveTo(size.width, 0);
      path.lineTo(0, 0);
      path.lineTo(size.width, size.height);
      path.close();
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(0, 0);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
