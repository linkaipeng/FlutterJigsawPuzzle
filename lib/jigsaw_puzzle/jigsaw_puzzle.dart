class JigsawPuzzleData {
  
  double width = 0; 
  double height = 0;
  double left = 0;
  double top = 0;
  String borderPath = '';

  JigsawPuzzleData({
    required this.width,
    required this.height,
    required this.left,
    required this.top,
    required this.borderPath,
  });

  int id() => (borderPath.hashCode + width + height + left + top).toInt();

  @override
  String toString() {
    return 'JigsawPuzzleData{width: $width, height: $height, left: $left, top: $top, borderPath: $borderPath}';
  }
}