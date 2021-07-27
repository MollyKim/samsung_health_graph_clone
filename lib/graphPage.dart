import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:samsung_health_graph_clone/model/graph_model.dart';

// class GraphScreen extends ConsumerStatefulWidget {
//   final List<List<GraphData>> data;
//   const GraphScreen({Key? key, required this.data}) : super(key: key);
//
//   @override
//   _GraphScreenState createState() => _GraphScreenState();
// }
//
// class _GraphScreenState extends ConsumerState<GraphScreen> {
//   @override
//   void initState() {
//     ref.read(pointIndexProvider).state = widget.data.length -1;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int isMonthlyToInt = ref
//         .watch(isMonthly)
//         .state ? 1 : 0;
//
//     List<BarData> barData = [];
//     List.generate(widget.data[isMonthlyToInt].length, (index) =>
//         barData.add(
//             BarData(
//                 value: (widget.data[isMonthlyToInt][index].total ~/
//                     widget.data[isMonthlyToInt][index].count).toDouble(),
//                 label: widget.data[isMonthlyToInt][index].date,
//                 index: index)));
//     ScrollController scrollController = ScrollController(
//         initialScrollOffset: (barData.length - 1) * 60);
//
//     return Scaffold(
//       body: ProviderScope(
//         key: UniqueKey(),
//         overrides: [
//           scrollProvider.overrideWithValue(scrollController),
//           barDataListProvider.overrideWithValue(barData),
//           //pointIndexProvider.overrideWithValue(barData.length -1)
//         ],
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GraphHeader(),
//               DrawGraph(),
//               Center(child: Text('---')),
//               Content(data: barData),
//               Container(color: Colors.pink[50], height: 300,),
//               Container(color: Colors.blue[50], height: 300,),
//               Container(color: Colors.pink[50], height: 300,),
//             ],
//           ),
//
//         ),
//       ),
//     );
//   }
// }


class GraphPage extends ConsumerWidget {
  final List<List<GraphData>> data;
  const GraphPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int isMonthlyToInt = ref.watch(isMonthly).state ? 1: 0;

    List<BarData> barData = [];
    List.generate(data[isMonthlyToInt].length, (index)
    => barData.add(
        BarData(
            value: (data[isMonthlyToInt][index].total~/data[isMonthlyToInt][index].count).toDouble(),
            label: data[isMonthlyToInt][index].date,
            index: index)));

  ScrollController scrollController = ScrollController(initialScrollOffset: (barData.length)*60);
  StateController<int> initialIndex= StateController<int>(barData.length-1);

  return Scaffold(
      body: ProviderScope(
        key: UniqueKey(),
        overrides: [
          scrollProvider.overrideWithValue(scrollController),
          barDataListProvider.overrideWithValue(barData),
          pointIndexProvider.overrideWithValue(initialIndex)
        ],
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GraphHeader(),
              DrawGraph(),
              Center(child: Text('---')),
              Content(data: barData),
              Container(color: Colors.pink[50],height: 300,),
              Container(color: Colors.blue[50],height: 300,),
              Container(color: Colors.pink[50],height: 300,),
            ],
          ),

        ),
      ),
    );
  }
}

class GraphHeader extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    bool isMonth = ref.watch(isMonthly.notifier).state;
    return Padding(
      padding: const EdgeInsets.only(left: 15,top: 30),
      child: GestureDetector(
        onTap: () {
        ref.watch(isMonthly).state = !isMonth;
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMonth ? Colors.grey : Colors.purple[200],
                borderRadius: BorderRadius.circular(5.0),
              ),
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("주별",style: TextStyle(fontSize: 20,color: Colors.white)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: isMonth ? Colors.purple[200] : Colors.grey ,
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
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationListener(
      onNotification: (notification){
          if (notification is ScrollStartNotification) {
            isScrolling = true;
          } else if(notification is ScrollUpdateNotification){
            int nearestBarIndex =
            _nearestBar(notification.metrics.extentBefore);
            if (ref.read(pointIndexProvider).state != nearestBarIndex) {
              ref.read(pointIndexProvider).state = nearestBarIndex;
            }
          } else if(notification is ScrollEndNotification){
            if (!scrollLock) {
              scrollLock = true;
              int nearestBarIndex = _nearestBar(notification.metrics.extentBefore);
              ref.read(pointIndexProvider).state = nearestBarIndex;
              ref.watch(scrollProvider).jumpTo(
                  nearestBarIndex * 60);
              scrollLock = false;
            }
            isScrolling = false;
          }
        return true;
      },
      child: DrawBars(),
    );
  }
  int _nearestBar(double now) {
    double index = now / 60;
    int left = index.round();
    return left;
  }
}

class DrawBars extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double blank = MediaQuery. of(context). size. width / 2;
    return SizedBox(
      height: 250,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: ref.watch(scrollProvider),
        child: Row(
          children: [
            SizedBox(width: blank),
            ListView.builder(
              primary: false,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ProviderScope(overrides: [
                  barDataProvider.overrideWithValue(ref.watch(barDataListProvider)[index])
                ], child: const BarItem());
              },
              itemCount: ref.read(barDataListProvider).length,
            ),
            SizedBox(width: blank),
          ],
        ),
      ),
    );
  }
}

class BarItem extends ConsumerWidget {
  const BarItem();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BarData barData = ref.watch(barDataProvider);

    double maxBarHeight = ref.read(barDataListProvider).reduce((a, b) => a.value<b.value ? b : a).value;
    double minBarHeight = ref.read(barDataListProvider).reduce((a, b) => a.value<b.value ? a : b).value;

    return GestureDetector(
      onTapUp: (_) {
        if (!isScrolling) {
          ref.watch(scrollProvider)
              .animateTo(barData.index * 60, duration: Duration(milliseconds: 300),curve : Curves.fastOutSlowIn);
          ref.read(pointIndexProvider).state = barData.index;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DrawBar(maxBarHeight: maxBarHeight, minBarHeight: minBarHeight,),
          SizedBox(height: 20,),
          BarText()
        ],
      ),
    );
  }
}

class DrawBar extends ConsumerWidget{
  final double minBarHeight;
  final double maxBarHeight;
  const DrawBar({required this.maxBarHeight, required this.minBarHeight});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BarData barData = ref.watch(barDataProvider);
    bool isPointed = ref.watch(pointIndexProvider.select((value) => value.state == barData.index));

    return CustomPaint(
      painter: BarPainter(
          barData,
          maxBarHeight,
          minBarHeight,
          isPointed),
      size: Size(60, 200),
    );
  }
}

class BarPainter extends CustomPainter{
  final BarData barData;
  final double max;
  final double min;
  final bool isPointed;
  const BarPainter(this.barData, this.max, this.min, this.isPointed);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = isPointed ? chartData.selectedColor : chartData.unselectedColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;

    double ratio = 0.8;

    if(barData.value != min)
      ratio = (barData.value-min)/(max-min);

    canvas.drawLine(Offset(30,size.height), Offset(30,(size.height-ratio*180)), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BarText extends ConsumerWidget {
  const BarText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BarData barData = ref.watch(barDataProvider);
    bool isPointed = ref.watch(pointIndexProvider.select((value) {
      return value.state == barData.index;
    }));

    return Center(
      child: Text(
        barData.label ?? '', textAlign: TextAlign.center, style: isPointed ? chartData.selectedTextStyle : chartData.unselectedTextStyle,
      ),
    );
  }
}


class Content extends ConsumerWidget {
  final List<BarData> data;

  const Content({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var index = ref.watch(pointIndexProvider);
    return Container(
      height: 300,
      color: index.state % 2 == 1? Colors.blue[200] : Colors.red[200],
    );
  }
}






