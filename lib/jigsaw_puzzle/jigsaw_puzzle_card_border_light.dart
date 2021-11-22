import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jigsaw_puzzle_demo/jigsaw_puzzle/jigsaw_puzzle.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

class JigsawPuzzleCardBorderLightWidget extends StatefulWidget {

  final JigsawPuzzleData data;
  final Color color;

  JigsawPuzzleCardBorderLightWidget({
    required this.data,
    required this.color,
  });

  @override
  _JigsawPuzzleCardBorderLightWidgetState createState() => _JigsawPuzzleCardBorderLightWidgetState();
}

class _JigsawPuzzleCardBorderLightWidgetState extends State<JigsawPuzzleCardBorderLightWidget> {

  @override
  Widget build(BuildContext context) {
    return _JigsawPuzzleCardWidget(
      borderPath: widget.data.borderPath,
      width: widget.data.width,
      height: widget.data.height,
      color: widget.color,
    );
  }
}

class _JigsawPuzzleCardWidget extends StatelessWidget {

  final String borderPath;
  final double width;
  final double height;
  final Color color;

  _JigsawPuzzleCardWidget({
    required this.borderPath,
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _JigsawPuzzleCardPainter(borderPath, color),
      size: Size(width, height),
    );
  }
}

class _JigsawPuzzleCardPainter extends CustomPainter {

  Path path = Path();
  final String borderPath;
  final Color color;

  _JigsawPuzzleCardPainter(this.borderPath, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    _initPath();
    _drawBorderLight(canvas);
  }

  void _initPath() {
    path = parseSvgPath(borderPath);
  }

  void _drawBorderLight(Canvas canvas) {
    Paint paint = Paint()..color = color;
    paint.maskFilter = MaskFilter.blur(BlurStyle.outer, 25);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
