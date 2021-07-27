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

  final double strokeWidth;

  ChartData({
        this.selectedColor = Colors.lime,
      this.selectedTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.lime),
      this.unselectedColor = Colors.grey,
      this.unselectedTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w300,color: Colors.black),
      this.strokeWidth = 10,
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

ChartData chartData = ChartData();

bool scrollLock = false;
bool isScrolling = false;

final pointIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final isMonthly = StateProvider<bool>((ref) => true);
final scrollProvider = Provider<ScrollController>((ref) => throw UnimplementedError());
final barDataListProvider = Provider<List<BarData>>((ref) => throw UnimplementedError());
final barDataProvider = Provider<BarData>((ref) => throw UnimplementedError());
