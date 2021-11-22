import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:jigsaw_puzzle_demo/jigsaw_puzzle/jigsaw_puzzle_data.dart';

class JigsawPuzzlePickAreaWidget extends StatelessWidget {
  final ui.Image srcImage;
  final List<int> correctIdList;

  JigsawPuzzlePickAreaWidget({
    required this.srcImage,
    required this.correctIdList,
  });

  @override
  Widget build(BuildContext context) {
    return _buildPickAreaWidget(context, _generatePickCardMap(correctIdList));
  }

  Widget _buildPickAreaWidget(BuildContext context, Map<int, Widget> pickCardMap) {
    List<Widget> widgetList = pickCardMap.keys.map((key) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        child: pickCardMap[key],
      );
    }).toList();

    return Expanded(
      flex: 440,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 52),
        child: Column(
          children: widgetList,
        ),
      ),
    );
  }

  Map<int, Widget> _generatePickCardMap(List<int> correctIdList) {
    Map<int, Widget> dataMap = JigsawPuzzleDataGenerator.generatePickJigsawPuzzleCardWidgetMap(
      image: srcImage,
      correctIdList: correctIdList,
    );
    List<int> keys = dataMap.keys.toList();

    Map<int, Widget> pickCardMap = Map();
    keys.forEach((element) {
      if (dataMap[element] != null) {
        pickCardMap[element] = dataMap[element]!;
      }
    });
    return pickCardMap;
  }
}
