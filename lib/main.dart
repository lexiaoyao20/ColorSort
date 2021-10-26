import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _color = Colors.blue;
  List<Color> _colors = [];

  var _slot = 0;
  final _globalKey = GlobalKey();
  double _offset = 0;

  _shuffle() {
    setState(() {
      _color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
      _colors = List.generate(8, (index) => _color[(index + 1) * 100]!);
      _colors.shuffle();
    });
  }

  _checkWindCondition() {
    List<double> lum = _colors.map((e) => e.computeLuminance()).toList();
    bool success = true;
    for (int i = 0; i < lum.length - 1; i++) {
      if (lum[i] > lum[i + 1]) {
        success = false;
        break;
      }
    }
    print(success ? "win" : "");
  }

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _shuffle,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Text(
              "Welcome:",
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 32),
            Container(
              child: const Icon(
                Icons.lock_outline,
                color: Colors.white,
              ),
              width: Box.width - Box.margin * 2,
              height: Box.height - Box.margin * 2,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(height: Box.margin * 2),
            Expanded(
              child: Listener(
                onPointerMove: (event) {
                  final y = event.position.dy - _offset;
                  if (y > (_slot + 1) * Box.height) {
                    if (_slot == _colors.length - 1) return;
                    setState(() {
                      final c = _colors[_slot];
                      _colors[_slot] = _colors[_slot + 1];
                      _colors[_slot + 1] = c;
                      _slot++;
                    });
                  } else if (y < _slot * Box.height) {
                    if (_slot == 0) return;
                    setState(() {
                      final c = _colors[_slot];
                      _colors[_slot] = _colors[_slot - 1];
                      _colors[_slot - 1] = c;
                      _slot--;
                    });
                  }
                },
                child: SizedBox(
                  width: Box.width,
                  child: Stack(
                    key: _globalKey,
                    children: List.generate(_colors.length, (i) {
                      return Box(
                        x: 0,
                        y: i * Box.height,
                        onDrag: (Color color) {
                          final index = _colors.indexOf(color);
                          final renderBox = (_globalKey.currentContext
                              ?.findRenderObject() as RenderBox);
                          _offset = renderBox.localToGlobal(Offset.zero).dy;
                          print("on dart $index, app bar height = $_offset");
                          _slot = index;
                        },
                        onEnd: _checkWindCondition,
                        color: _colors[i],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Box extends StatelessWidget {
  static const width = 250.0;
  static const height = 50.0;
  static const margin = 2.0;
  final Function(Color color) onDrag;
  final Function() onEnd;

  final Color color;
  final double x, y;

  late final container = Container(
    width: width - margin * 2,
    height: height - margin * 2,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  Box(
      {required this.x,
      required this.y,
      required this.onDrag,
      required this.onEnd,
      required this.color})
      : super(key: ValueKey(color));

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      top: y,
      left: x,
      child: Draggable(
        onDragStarted: () => onDrag(color),
        onDragEnd: (detail) => onEnd(),
        child: container,
        feedback: container,
        childWhenDragging: Visibility(
          visible: false,
          child: container,
        ),
      ),
    );
  }
}
