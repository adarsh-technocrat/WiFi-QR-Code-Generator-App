import 'package:flutter/material.dart';

class SizeConfig {
  static double screenWidth;
  static double screenHeight;
  static double blocksizeHorizontal = 0;
  static double blocksizeVertical = 0;
  static double textMultiplier;
  static double imageSizeMultiplier;
  static double hightMultiplier;

  static init(BoxConstraints constraints, Orientation orientation) {
    // if (orientation == Orientation.portrait) {
    screenWidth = constraints.minWidth;
    screenHeight = constraints.maxHeight;
    
    // }else {
    //   screenWidth = constraints.minHeight;
    // screenHeight = constraints.maxWidth;
    // }

    // screenWidth = constraints.minWidth;
    // screenHeight = constraints.maxHeight;

    blocksizeHorizontal = screenWidth / 100;
    blocksizeVertical = screenHeight / 100;

    textMultiplier = blocksizeVertical;
    imageSizeMultiplier = blocksizeHorizontal;
    hightMultiplier = blocksizeVertical;

    print(blocksizeVertical);
    print(blocksizeHorizontal);
  }
}