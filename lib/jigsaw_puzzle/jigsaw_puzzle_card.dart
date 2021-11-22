import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:jigsaw_puzzle_demo/jigsaw_puzzle/jigsaw_puzzle.dart';
import 'package:jigsaw_puzzle_demo/jigsaw_puzzle/jigsaw_puzzle_card_placeholder.dart';
import 'package:svg_path_parser/svg_path_parser.dart';

class DraggableJigsawPuzzleCardWidget extends StatelessWidget {
  final JigsawPuzzleData data;
  final ui.Image srcImage;

  DraggableJigsawPuzzleCardWidget({
    Key? key,
    required this.data,
    required this.srcImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget childWidget = _JigsawPuzzleCardWidget(
      srcImage: srcImage,
      borderPath: data.borderPath,
      width: data.width,
      height: data.height,
      left: -data.left,
      top: -data.top,
      active: true,
    );
    return Draggable<JigsawPuzzleData>(
      data: data,
      maxSimultaneousDrags: 1,
      feedback: childWidget,
      childWhenDragging: _buildCardPlaceHolder(data),
      child: childWidget,
    );
  }

  Widget _buildCardPlaceHolder(JigsawPuzzleData data) {
    return JigsawPuzzleCardPlaceHolderWidget(
      borderPath: data.borderPath,
      width: data.width,
      height: data.height,
    );
  }
}

class DragTargetJigsawPuzzleCardWidget extends StatefulWidget {
  final JigsawPuzzleData data;
  final ui.Image srcImage;
  final Function(int id, JigsawPuzzleData data) onCorrectCallback;
  final Function(int id, JigsawPuzzleData data) onErrorCallback;

  DragTargetJigsawPuzzleCardWidget({
    Key? key,
    required this.data,
    required this.srcImage,
    required this.onCorrectCallback,
    required this.onErrorCallback,
  }) : super(key: key);

  @override
  _DragTargetJigsawPuzzleCardWidgetState createState() =>
      _DragTargetJigsawPuzzleCardWidgetState();
}

class _DragTargetJigsawPuzzleCardWidgetState extends State<DragTargetJigsawPuzzleCardWidget> {
  JigsawPuzzleStatus _jigsawPuzzleStatus = JigsawPuzzleStatus.NORMAL;
  int? _willAcceptId;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    list.add(_buildDragTargetWidget());
    if (_jigsawPuzzleStatus == JigsawPuzzleStatus.CORRECT) {
      _jigsawPuzzleStatus = JigsawPuzzleStatus.NORMAL;
    }
    return Stack(
      children: list,
    );
  }

  Widget _buildDragTargetWidget() {
    _JigsawPuzzleCardWidget jigsawPuzzleCardWidget = _JigsawPuzzleCardWidget(
      srcImage: widget.srcImage,
      borderPath: widget.data.borderPath,
      width: widget.data.width,
      height: widget.data.height,
      left: -widget.data.left,
      top: -widget.data.top,
      active: _jigsawPuzzleStatus == JigsawPuzzleStatus.CORRECT,
      needCover: _willAcceptId == widget.data.id(),
    );
    if (_jigsawPuzzleStatus == JigsawPuzzleStatus.CORRECT) {
      return jigsawPuzzleCardWidget;
    }
    return DragTarget(
      builder: (
        BuildContext context,
        List<dynamic> candidateData,
        List<dynamic> rejectedData,
      ) {
        return jigsawPuzzleCardWidget;
      },
      onWillAccept: (JigsawPuzzleData? value) {
        setState(() {
          _willAcceptId = widget.data.id();
        });
        return true;
      },
      onLeave: (JigsawPuzzleData? value) {
        setState(() {
          _willAcceptId = null;
        });
      },
      onMove: (_) {
        print('onMove');
      },
      onAccept: (JigsawPuzzleData? value) {
        setState(() {
          _willAcceptId = null;
        });
        if (value == null) {
          return;
        }
        setState(() {
          bool correct = value.id() == widget.data.id();
          if (correct) {
            _jigsawPuzzleStatus = JigsawPuzzleStatus.CORRECT;
            widget.onCorrectCallback(value.id(), widget.data);
          } else {
            _jigsawPuzzleStatus = JigsawPuzzleStatus.ERROR;
            widget.onErrorCallback(value.id(), widget.data);
          }
        });
      },
    );
  }
}

class _JigsawPuzzleCardWidget extends StatelessWidget {
  final ui.Image srcImage;
  final String borderPath;
  final double top;
  final double left;

  final double width;
  final double height;

  final bool active;
  final bool needCover;

  _JigsawPuzzleCardWidget({
    required this.srcImage,
    required this.borderPath,
    required this.width,
    required this.height,
    this.active = true,
    this.top = 0,
    this.left = 0,
    this.needCover = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _JigsawPuzzleCardPainter(srcImage, borderPath, top, left, active, needCover),
      size: Size(width, height),
    );
  }
}

class _JigsawPuzzleCardPainter extends CustomPainter {
  Path path = Path();
  final ui.Image srcImage;
  final String borderPath;
  final double top;
  final double left;
  final bool active;
  final bool needCover;

  _JigsawPuzzleCardPainter(
    this.srcImage,
    this.borderPath,
    this.top,
    this.left,
    this.active,
    this.needCover,
  );

  @override
  void paint(Canvas canvas, Size size) {
    _initPath();
    _drawImageCard(canvas, size);
    _drawCover(canvas);
    _drawBorder(canvas, size);
  }

  void _initPath() {
    path = parseSvgPath(borderPath);
  }

  void _drawImageCard(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.isAntiAlias = true;
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawPath(path, paint);
    paint.blendMode =  BlendMode.srcIn;
    if (!active) {
      paint.colorFilter = ColorFilter.mode(Colors.grey, BlendMode.color);
    }

    canvas.drawImageRect(
      srcImage,
      Rect.fromLTWH(
        0,
        0,
        srcImage.width.toDouble(),
        srcImage.height.toDouble(),
      ),
      Rect.fromLTWH(left, top, 480, 480),
      paint,
    );
    canvas.restore();
  }

  void _drawBorder(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0XFFF0F0F0);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 8;
    paint.isAntiAlias = true;
    canvas.drawPath(path, paint);
  }

  void _drawCover(Canvas canvas) {
    if (needCover) {
      Paint paint = Paint()
        ..color = Colors.black54
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

enum JigsawPuzzleStatus {
  NORMAL,
  CORRECT,
  ERROR,
}
