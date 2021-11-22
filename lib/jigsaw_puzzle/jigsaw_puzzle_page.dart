import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jigsaw_puzzle_demo/jigsaw_puzzle/jigsaw_puzzle_pick_area.dart';
import 'package:jigsaw_puzzle_demo/jigsaw_puzzle/jigsaw_puzzle_preview.dart';

import '../utils.dart';


class JigsawPuzzlePage extends StatefulWidget {

  @override
  _JigsawPuzzlePageState createState() => _JigsawPuzzlePageState();
}

class _JigsawPuzzlePageState extends State<JigsawPuzzlePage> {

  ui.Image? _srcImage;

  List<int> _correctIdList = [];

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    _srcImage =
    await ImageUtils.loadAssetImage('images/test_img.jpg');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_srcImage == null) {
      return Container();
    }
    return _buildPageContentWidget();
  }

  Widget _buildPageContentWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.blueGrey,
      child: Row(
        children: [
          JigsawPuzzlePreviewWidget(
            srcImage: _srcImage!,
            correctCallback: (id) {
              setState(() {
                _correctIdList.add(id);
              });
            },
          ),
          JigsawPuzzlePickAreaWidget(
            srcImage: _srcImage!,
            correctIdList: _correctIdList,
          ),
        ],
      ),
    );
  }
}
