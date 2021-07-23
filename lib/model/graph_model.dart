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

  final ScrollController? scrollController;

  ChartData({
        this.selectedColor = Colors.lime,
      this.selectedTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.lime),
      this.unselectedColor = Colors.grey,
      this.unselectedTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
      required this.chartWidth,
      required this.chartHeight,
      this.barWidth = 10,
      this.scrollController
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
    double graphHeight;
    ScrollController? scrollController;

  Graph({
    this.isMonthly = true,
    this.graphHeight = 250,
    this.scrollController
  });

}

ChartData chartData = ChartData(
    chartWidth: 150,
    chartHeight: 250,
    );

Graph initialGraph = Graph();

final graphProvider = StateProvider<Graph>((ref)=>initialGraph);
final monthlyOrWeeklyProvider = StateProvider<bool>((ref)=>initialGraph.isMonthly);
final pointedIndexProvider = StateProvider<int>((ref)=>0);


bool lock = false;
