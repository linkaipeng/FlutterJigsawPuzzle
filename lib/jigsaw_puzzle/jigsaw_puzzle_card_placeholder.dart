import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

class JigsawPuzzleCardPlaceHolderWidget extends StatelessWidget {

  final String borderPath;
  final double width;
  final double height;
  
  JigsawPuzzleCardPlaceHolderWidget({
    required this.borderPath,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _JigsawPuzzleCardPlaceHolderWidget(borderPath),
      size: Size(width, height),
    );
  }
}

class _JigsawPuzzleCardPlaceHolderWidget extends CustomPainter {

  Path path = Path();
  final String borderPath;

  _JigsawPuzzleCardPlaceHolderWidget(this.borderPath);

  @override
  void paint(Canvas canvas, Size size) {
    _initPath();
    _drawBorder(canvas, size);
  }

  void _initPath() {
    path = parseSvgPath(borderPath);
  }

  void _drawBorder(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..isAntiAlias = true
      ..color = Colors.black12;

    List<Offset> points = _getIconOffsets();
    for (int i = 0; i < points.length - 1; i++) {
      if (i % 2 == 0) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  List<Offset> _getIconOffsets() {
    try {
      PathMetrics pms = path.computeMetrics();
      PathMetric pm = pms.elementAt(0);
      int len = pm.length ~/ 10;
      double start = pm.length % 10 / 2;
      List<Offset> iconOffsets = [];
      for (int i = 0; i <= len; i++) {
        Tangent? t = pm.getTangentForOffset(i.toDouble() * 10 + start);
        Offset point = t!.position;
        double x = point.dx;
        double y = point.dy;
        iconOffsets.add(Offset(x, y));
      }
      return iconOffsets;
    } catch (e) {
      return List.empty();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
