import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samsung_health_graph_clone/graphPage.dart';
import 'package:samsung_health_graph_clone/model/graph_model.dart';
import 'dart:math';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GraphPage(data: fetchTimelog(context, true)),
    );
  }
}


List<List<GraphData>> fetchTimelog(BuildContext context, bool isActivity ) {
  DateTime now = DateTime.now();
  List<GraphData> graphDataWeek = [];
  List<GraphData> graphDataMonth = [];

  var thisWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1));
  Random random = new Random();
  num value;

  if(isActivity){
    for (var i=3; i>0; i--){
      value = 10+ random.nextInt(40);
      String month = (now.month-i).toString();
      graphDataMonth.add(GraphData(date: month,total: value*28,count: 25+i));
    }
    graphDataMonth.add(GraphData(date: now.month.toString(), total: 10*15, count: 15));

    String week = "${thisWeek.month}/${thisWeek.day}";
    graphDataWeek.add(GraphData(date: week, total: 100*4, count: 4));
    for(var i=10; i>0; i--){
      value = 100 + random.nextInt(40);
      thisWeek = thisWeek.subtract(Duration(days: 7));
      String week = "${thisWeek.month}/${thisWeek.day}";
      graphDataWeek.add(GraphData(date: week, total: value*7, count: 7));
    }
  } else {
    for (var i=3; i>0; i--){
      value = 8.3 + random.nextInt(20)*0.01;
      String month = (now.month-i).toString();
      graphDataMonth.add(GraphData(date: month,total: value*28,count: 25+i));
    }
    graphDataMonth.add(GraphData(date: now.month.toString(), total: 8.3*15, count: 15));

    String week = "${thisWeek.year}-${thisWeek.month}-${thisWeek.day}";
    graphDataWeek.add(GraphData(date: week, total: 8.3*4, count: 4));
    for(var i=10; i>0; i--){
      value = 8.3 + random.nextInt(20)*0.01;
      thisWeek = thisWeek.subtract(Duration(days: 7));
      String week = "${thisWeek.month}/${thisWeek.day}";
      graphDataWeek.add(GraphData(date: week, total: value*7, count: 7));
    }
  }

  graphDataWeek = graphDataWeek.reversed.toList();

  return [graphDataWeek, graphDataMonth];
}