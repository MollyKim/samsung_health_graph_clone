import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:samsung_health_graph_clone/model/graph_model.dart';
import 'package:intl/intl.dart';

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

  ScrollController scrollController = ScrollController(initialScrollOffset: (barData.length-1)*chartData.barSpace);
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
              SizedBox(height: 10),
              GraphHeader(),
              DrawGraph(),
              SizedBox(height: 10,),
              Content(data: barData),
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
                child: Text("weekly",style: TextStyle(fontSize: 15,color: Colors.white)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: isMonth ? Colors.purple[200] : Colors.grey ,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("monthly",style: TextStyle(fontSize: 15,color: Colors.white)),
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
          if(!touchLock) {
            int nearestBarIndex = _nearestBar(notification.metrics.extentBefore);
            if (nearestBarIndex >= ref.read(barDataListProvider).length)
              nearestBarIndex = ref.read(barDataListProvider).length - 1;
            if (ref.read(pointIndexProvider).state != nearestBarIndex) {
              ref.read(pointIndexProvider).state = nearestBarIndex;
            }
          }
        } else if(notification is ScrollEndNotification){
          if (!scrollLock) {
            scrollLock = true;
            int nearestBarIndex = _nearestBar(notification.metrics.extentBefore);
            if(nearestBarIndex >= ref.read(barDataListProvider).length)
              nearestBarIndex = ref.read(barDataListProvider).length -1;
            ref.read(pointIndexProvider).state = nearestBarIndex;
            ref.watch(scrollProvider).animateTo(nearestBarIndex * chartData.barSpace, duration: Duration(milliseconds: 300),curve : Curves.fastOutSlowIn);
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
    double index = now / chartData.barSpace;
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
      onTapDown: (down){
        touchLock = true;
      },
      onTapUp: (_) {
        if (!isScrolling) {
          ref.watch(scrollProvider).animateTo(barData.index * chartData.barSpace, duration: Duration(milliseconds: 300),curve : Curves.fastOutSlowIn);
          ref.read(pointIndexProvider).state = barData.index;
          Future.delayed(Duration(milliseconds: 300),()=> touchLock = false);
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
      size: Size(chartData.barSpace, 200),
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

    canvas.drawLine(Offset(chartData.barSpace/2,size.height), Offset(chartData.barSpace/2,(size.height-ratio*180)), paint);
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
    bool isMonth = ref.watch(isMonthly.notifier).state;

    String dateText = data[index.state].label.toString();
    if(!isMonth) {
      DateTime dateTime = DateFormat("MM/dd").parse(dateText);
      dateTime = dateTime.add(Duration(days: 6));
      dateText = dateText + "~" + dateTime.month.toString()+"/"+dateTime.day.toString();
    } else
      dateText = dateText + "월";

    return Center(
      child: Column(
        children: [
          Text(dateText,style: TextStyle(fontSize: 30, color: Colors.indigo[800]),),
          SizedBox(height: 10,),
          CircleAvatar(
            radius: 100.0,
            backgroundColor: Colors.blueGrey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('평균 시간',style: TextStyle(fontSize: 30)),
                  Text('${data[index.state].value.toInt().toString()}',style: TextStyle(fontSize: 30)),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(index.state-1 >0 ? "${data[index.state-1].value.toInt().toString()}분\n걷기" : "0분\n걷기",style: TextStyle(fontSize: 15)),
              Icon(Icons.directions_walk,size: 50,),
              SizedBox(width: 50),
              Icon(Icons.directions_run_outlined,size: 50,),
              Text("${data[index.state].value.toInt().toString()}분\n뛰기",style: TextStyle(fontSize: 15)),
            ],
          )
        ],
      ),
    );
  }
}






