import 'package:flutter/material.dart';

class BarData {
  final double value;
  final String? label;
  final int index;

  BarData({required this.value, required this.label, required this.index});
}

class ChartData {
  final Color selectedColor;
  final TextStyle selectedTextStyle;

  final Color unselectedColor;
  final TextStyle unselectedTextStyle;

  final double chartWidth;
  final double chartHeight;

  final double barWidth;

  final ScrollController scrollController;

  ChartData(
      this.selectedColor,
      this.selectedTextStyle,
      this.unselectedColor,
      this.unselectedTextStyle,
      this.chartWidth,
      this.chartHeight,
      this.barWidth,
      this.scrollController);
}

class GraphData{
  final int count;
  final double total;
  final String date;

  GraphData({
    this.count = 0,
    this.total = 0,
    this.date =  '',
  });

}
