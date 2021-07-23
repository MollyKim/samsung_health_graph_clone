import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:samsung_health_graph_clone/model/graph_model.dart';
import 'package:samsung_health_graph_clone/view_model/graph_view_model.dart';


class GraphPage extends ConsumerWidget {
  final List<List<GraphData>> data;
  const GraphPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Graph graph = ref.watch(graphDataProvider);
    int isMonthlyToInt = graph.isMonthly ? 1 : 0;

    List<BarData> barData = [];
    List.generate(data[isMonthlyToInt].length, (index)
    => barData.add(
        BarData(
            value: (data[isMonthlyToInt][index].total~/data[isMonthlyToInt][index].count).toDouble(),
            label: data[isMonthlyToInt][index].date,
            index: index)));


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
            DrawGraph(data: barData),
            Content(data: barData),
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

  Widget build(BuildContext context, WidgetRef ref) {
  Graph graph = ref.watch(graphDataProvider);
  var graphProvider = ref.read(graphDataProvider.notifier);

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


class DrawGraph extends ConsumerStatefulWidget {
  final List<BarData> data;
  const DrawGraph({Key? key, required this.data}) : super(key: key);

  @override
  ConsumerState<DrawGraph> createState() {
    return _GraphScreenState();
  }
}

class _GraphScreenState extends ConsumerState<DrawGraph> {

  @override
  void initState() {
      ref.read(pointedIndexProvider.notifier).state = widget.data.length -1;
    ref.read(graphDataProvider).scrollController = ScrollController(initialScrollOffset: widget.data.length * 60.0);
    super.initState();
  }
  @override
  void didUpdateWidget(covariant DrawGraph oldWidget) {
    Future.delayed(Duration.zero, () {
      ref.watch(pointedIndexProvider).state = widget.data.length -1;
      ref.read(graphDataProvider).scrollController!.jumpTo(widget.data.length * 60);
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
        Graph graph = ref.watch(graphDataProvider);
    StateController<int> pointedIndex = ref.watch(pointedIndexProvider);
    bool isScrolling = false;

        return NotificationListener(
      onNotification: (notification){
        if(!lock) {
          if (notification is ScrollStartNotification) {
            isScrolling = true;
          }
          if (isScrolling) {
            if (notification is ScrollEndNotification) {
              isScrolling = false;
              int indexValue = graph.scrollController!.offset ~/ 60;
                pointedIndex.state = indexValue-1;
              graph.scrollController!.jumpTo(indexValue*60.0);
            }
          }
          if(notification is ScrollUpdateNotification){
            int indexValue = graph.scrollController!.offset ~/ 60;
            pointedIndex.state = indexValue-1;
            if(pointedIndex.state<0)
              pointedIndex.state = 0;
          }
        }
        return true;
      },
      child: DrawBars(data: widget.data),
    );

  }
}


class DrawBars extends ConsumerWidget{
  final List<BarData> data;
  DrawBars({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Graph graph = ref.watch(graphDataProvider);

    StateController<int> pointedIndex = ref.watch(pointedIndexProvider);
    double blank = MediaQuery. of(context). size. width / 2;
    double maxBarHeight = data.reduce((a, b) => a.value<b.value ? b : a).value;
    double minBarHeight = data.reduce((a, b) => a.value<b.value ? a : b).value;

    return SizedBox(
      height: 250,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: graph.scrollController,
        child: Row(
          children: [
            SizedBox(width: blank),
            ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              primary: false,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTapDown:(down){
                        lock = true;
                        pointedIndex.state = index;
                        graph.scrollController!.jumpTo(index * 60.0);
                      },
                      onTapCancel:(){
                        lock = false;
                      },
                      onTapUp: (up){
                        lock = false;
                      },
                      child: DrawBarNLabel(
                        data: data[index],
                        index: index,
                        minBarHeight: minBarHeight,
                        maxBarHeight: maxBarHeight,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(data[index].label!,style: (index == pointedIndex.state) ? chartData.selectedTextStyle : chartData.unselectedTextStyle,),
                  ],
                );
              },
            ),
            SizedBox(width: blank),
          ],
        ),
      ),
    );
  }
}

class DrawBarNLabel extends ConsumerWidget{
  final BarData data;
  final int index;
  final double minBarHeight;
  final double maxBarHeight;

  DrawBarNLabel({required this.data,required this.index, required this.maxBarHeight, required this.minBarHeight});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int pointedIndex = ref.read(pointedIndexProvider.notifier).state;
    ref.watch(pointedIndexProvider.select((value) => value.state == index));

    return CustomPaint(
      painter: DrawStick(
          data,
          maxBarHeight,
          minBarHeight,
          pointedIndex),
      size: Size(60, 200),
    );
  }
}

class DrawStick extends CustomPainter{
  final BarData barData;
  final double max;
  final double min;
  final int selectedIndex;
  DrawStick(this.barData, this.max, this.min, this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = barData.index == selectedIndex ? chartData.selectedColor : chartData.unselectedColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    double ratio = 0.8;

    if(barData.value != min)
      ratio = (barData.value-min)/(max-min);

    canvas.drawLine(Offset(0,size.height), Offset(0,(size.height-ratio*180)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}

class Content extends ConsumerWidget {
  final List<BarData> data;

  const Content({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var index = ref.watch(pointedIndexProvider);
    return Container(
      height: 300,
      color: index.state % 2 == 1? Colors.blue[200] : Colors.red[200],
    );
  }
}
