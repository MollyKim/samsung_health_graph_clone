import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samsung_health_graph_clone/model/graph_model.dart';

final graphDataProvider = StateNotifierProvider<GraphViewModel,Graph>((ref) {
    return GraphViewModel(ref);
  });

class GraphViewModel extends StateNotifier<Graph>{
  final ProviderRefBase ref;

  GraphViewModel(this.ref ) : super(ref.read(graphProvider).state);

  void isChange( ){
    state.isMonthly = !state.isMonthly;
    //ref.read(monthlyOrWeeklyProvider).state = !ref.read(monthlyOrWeeklyProvider).state;
  }
}