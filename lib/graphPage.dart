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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        title: Text("samsung health graph clone"),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GraphHeader(),
            DrawGraph(data),
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
          graphProvider.isChange();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: graph.isMonthly ? Colors.grey : Colors.purple[200],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("주별",style: TextStyle(fontSize: 20,color: Colors.white)),
                ),
            ),
            Container(
                decoration: BoxDecoration(
                  color: graph.isMonthly ? Colors.purple[200] : Colors.grey ,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("월별",style: TextStyle(fontSize: 20,color: Colors.white)),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawGraph extends ConsumerWidget {
  final List<List<GraphData>> data;

  const DrawGraph({Key? key,required this.data}) : super(key: key);


  Widget build(BuildContext context, WidgetRef ref) {
    double blank = MediaQuery. of(context). size. width / 2;
    var graphProvider = ref.read(graphDataProvider.notifier);
    Graph graph = ref.watch(graphDataProvider);

    List<GraphData> graphData = graph.isMonthly ? data[1] : data[0];
    ScrollController scrollController = ScrollController();

    ChartData chartData = ChartData(
        chartWidth: 150,
        chartHeight: graph.graphHeight,
        scrollController: scrollController);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: chartData.scrollController,
      key: UniqueKey(),
      child: Row(
        children: [
          SizedBox(width: blank),
          ListView.builder(
            shrinkWrap: true,
            itemCount: graphData.length,
            primary: false,
            itemBuilder: (BuildContext context, int index){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomPaint(
                    painter: DrawStick(index, ),
                    size: Size(60, data.max),
                  ),
                  SizedBox(height: 25),
                  Text(),
                ],
              );
            },
          ),
          SizedBox(width: blank),
        ],
      ),
    );
  }
}


class DrawStick extends CustomPainter{
  final int index;
  final double value;

  DrawStick(this.index,this.value);

  ChartData chartData = ChartData(
      chartWidth: 150,
      chartHeight: 250,
      scrollController: scrollController);


  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = chartData.unselectedColor
      ..style = PaintingStyle.fill;

    ///how to call provider in here
    //막대기의 크기는 10으로 고정
    final rect = Rect.fromPoints(Offset(0,250), Offset(10,(250-value)));

    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(30)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

}