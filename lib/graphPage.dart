import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class GraphPage extends StatelessWidget {
  const GraphPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("samsung health graph clone"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GraphHeader(),
            Graph(),
            Container(color: Colors.pink[50],height: 300,),
          ],
        ),
      ),
    );
  }
}


class GraphHeader extends ConsumerStatefulWidget {
  const GraphHeader({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  ConsumerState<ConsumerStatefulWidget> createState() {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

class Graph extends ConsumerStatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  ConsumerState<ConsumerStatefulWidget> createState() {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}