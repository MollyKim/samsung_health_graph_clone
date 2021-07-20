import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:samsung_health_graph_clone/model/graph_model.dart';
import 'package:samsung_health_graph_clone/view_model/graph_view_model.dart';

class GraphPage extends StatelessWidget {
  final List<List<GraphData>> data;
  const GraphPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("samsung health graph clone"),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GraphHeader(),
            //Graph(),
            Container(color: Colors.pink[50],height: 300,),
            Container(color: Colors.blue[50],height: 300,),
            Container(color: Colors.pink[50],height: 300,),
          ],
        ),
      ),
    );
  }
}


class GraphHeader extends ConsumerWidget {
  const GraphHeader({Key? key}) : super(key: key);

  Widget build(BuildContext context, WidgetRef ref) {
    var graphProvider = ref.read(graphDataProvider.notifier);
    Graph graph = ref.watch(graphDataProvider);

    return Padding(
      padding: const EdgeInsets.only(left: 15,top: 30),
      child: GestureDetector(
        onTap: () {
          print(graph.isMonthly);
          graphProvider.isChange();
          print(graph.isMonthly);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: graph.isMonthly ? Colors.grey : Colors.purple[50],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("주별",style: TextStyle(fontSize: 20)),
                ),
            ),
            Container(
                decoration: BoxDecoration(
                  color: graph.isMonthly ? Colors.purple[50] : Colors.grey ,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("월별${graph.isMonthly}",style: TextStyle(fontSize: 20)),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

// class Graph extends ConsumerStatefulWidget {
//   const Graph({Key? key}) : super(key: key);
//
//   @override
//   // ignore: no_logic_in_create_state
//   ConsumerState<ConsumerStatefulWidget> createState() {
//     throw UnimplementedError();
//   }
//
//
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Container(color: Colors.amber,);
//   }
// }