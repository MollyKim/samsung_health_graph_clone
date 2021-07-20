import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samsung_health_graph_clone/model/graph_model.dart';

final graphDataProvider = StateNotifierProvider.autoDispose<GraphViewModel,Graph>((ref) =>GraphViewModel());

class GraphViewModel extends StateNotifier{
  GraphViewModel() : super(const []);

  bool selectMontyOrWeek(bool isMonthly) {
    return !isMonthly;
  }



}