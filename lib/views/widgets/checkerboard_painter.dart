import 'package:flutter/material.dart';

class CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.grey.withOpacity(0.1);
    double squareSize = 20;

    for (double i = 0; i < size.width; i += squareSize) {
      for (double j = 0; j < size.height; j += squareSize) {
        if ((i / squareSize).floor() % 2 == (j / squareSize).floor() % 2) {
          canvas.drawRect(Rect.fromLTWH(i, j, squareSize, squareSize), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
