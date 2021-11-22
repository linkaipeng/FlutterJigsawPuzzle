import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class ImageUtils {

  static Future<ui.Image?> loadAssetImage(String imgPath) async {
    Completer<ui.Image?> completer = Completer<ui.Image?>();
    ImageStreamListener? listener;
    ImageStream stream = AssetImage(imgPath).resolve(ImageConfiguration.empty);
    listener = ImageStreamListener(
          (ImageInfo frame, bool sync) {
        completer.complete(frame.image);
        if (listener != null) {
          stream.removeListener(listener);
        }
      },
      onError: (Object exception, StackTrace? stackTrace) {
        completer.complete(null);
        if (listener != null) {
          stream.removeListener(listener);
        }
      },
    );
    stream.addListener(listener);
    return completer.future;
  }

}

