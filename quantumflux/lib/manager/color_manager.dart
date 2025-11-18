import 'package:flutter/material.dart';

extension HexColor on Color {
  static Color hexString(String color) {
    color = color.replaceAll("#", "");
    if(color.length == 6) {
      color = "FF$color";
    }
    return Color(int.parse(color, radix: 16));
  }
}

class ColorManager {
  static Color black = HexColor.hexString("#000000");
  static Color white = HexColor.hexString("#FFFFFF");
  static Color iconColorStart = HexColor.hexString("#3B82F6");
  static Color iconColorend = HexColor.hexString("#8B5CF6");
  static Color settings = HexColor.hexString("#1F2937");
  static Color textBlue = HexColor.hexString("#3B82F6");
  static Color border = HexColor.hexString("#374151");
  static Color containerStart = HexColor.hexString("#111827");
  static Color containerEnd = HexColor.hexString("#1F2937");
  static Color green = HexColor.hexString("#4ADE80");
  static Color textGrey = HexColor.hexString("#9CA3AF");
  static Color textWhite = HexColor.hexString("#D1D5DB");

}