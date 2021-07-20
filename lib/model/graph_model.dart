import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  ChartData({
        this.selectedColor = Colors.indigo,
      this.selectedTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      this.unselectedColor = Colors.grey,
      this.unselectedTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
      required this.chartWidth,
      required this.chartHeight,
      this.barWidth = 10,
      required this.scrollController
  });
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


class Graph{
    bool isMonthly;
    int index;

  Graph({
    this.isMonthly = true,
    this.index = 0,
});

}

Graph initialGraph = Graph();
final graphProvider = StateProvider<Graph>((ref)=>initialGraph);
final monthlyOrWeeklyProvider = StateProvider<bool>((ref)=>initialGraph.isMonthly);
final pointedIndex = StateProvider<int>((ref)=>initialGraph.index);