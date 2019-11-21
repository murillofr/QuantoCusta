import 'package:flutter/material.dart';

class NavCustomPainter extends CustomPainter {
    double loc;
    double s;
    Color color;
    TextDirection textDirection;

    NavCustomPainter(double startingLoc, int itemsLength, this.color,
        this.textDirection) {
        final span = 1.0 / itemsLength;
        s = 0.2;
        double l = startingLoc + (span - s) / 2;
        loc = textDirection == TextDirection.rtl ? 0.8 - l : l;
    }

    @override
    void paint(Canvas canvas, Size size) {
        final paint = Paint()
            ..color = color
            ..style = PaintingStyle.fill;

        final path = Path()
            ..moveTo(0, 0)
            ..lineTo((loc - 0) * 300.0, 0)
            ..cubicTo(
                (loc + s * 0.15) * 300.0,
                40.0 * 0.0,
                loc * 300.0,
                40.0 * 0.60,
                (loc + s * 0.50) * 300.0,
                40.0 * 0.64,
            )..cubicTo(
                (loc + s) * 300.0,
                40.0 * 0.60,
                (loc + s - s * 0.20) * 300.0,
                40.0 * 0.0,
                (loc + s + 0.002) * 300.0,
                0,
            )
            ..lineTo(size.width, 0)..lineTo(size.width, size.height)..lineTo(
                0, size.height)
            ..close();
        //canvas.drawShadow(path, Colors.black, 1.0, true);
        canvas.drawPath(path, paint);
    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
        return this != oldDelegate;
    }
}
