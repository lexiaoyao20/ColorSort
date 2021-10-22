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
  final boxes = [
    Box(color: Colors.blue[100]!, key: UniqueKey()),
    Box(color: Colors.blue[300]!, key: UniqueKey()),
    Box(color: Colors.blue[500]!, key: UniqueKey()),
    Box(color: Colors.blue[700]!, key: UniqueKey()),
    Box(color: Colors.blue[900]!, key: UniqueKey()),
  ];

  _shuffle() {
    setState(() {
      boxes.shuffle();
    });
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
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Row(
          children: boxes,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _shuffle,
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Box extends StatelessWidget {
  final Color color;
  const Box({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 50,
        height: 50,
        color: color,
      ),
      feedback: Container(
          margin: const EdgeInsets.all(8.0),
          width: 50,
          height: 50,
          color: color),
      childWhenDragging: Container(
        margin: const EdgeInsets.all(8.0),
        width: 50,
        height: 50,
      ),
    );
  }
}
