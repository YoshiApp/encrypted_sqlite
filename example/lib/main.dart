import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_example/exp_test_page.dart';
import 'package:sqflite_example/deprecated_test_page.dart';
import 'model/main_item.dart';
import 'open_test_page.dart';
import 'package:sqflite_example/exception_test_page.dart';
import 'raw_test_page.dart';
import 'slow_test_page.dart';
import 'src/main_item_widget.dart';
import 'type_test_page.dart';
import 'todo_test_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => new _MyAppState();
}

const String testRawRoute = "/test/simple";
const String testOpenRoute = "/test/open";
const String testSlowRoute = "/test/slow";
const String testThreadRoute = "/test/thread";
const String testTodoRoute = "/test/todo";
const String testExceptionRoute = "/test/exception";
const String testExpRoute = "/test/exp";
const String testDeprecatedRoute = "/test/deprecated";

class _MyAppState extends State<MyApp> {
  var routes = <String, WidgetBuilder>{
    '/test': (BuildContext context) => new MyHomePage(),
    testRawRoute: (BuildContext context) => new SimpleTestPage(),
    testOpenRoute: (BuildContext context) => new OpenTestPage(),
    testSlowRoute: (BuildContext context) => new SlowTestPage(),
    testTodoRoute: (BuildContext context) => new TodoTestPage(),
    testThreadRoute: (BuildContext context) => new TypeTestPage(),
    testExceptionRoute: (BuildContext context) => new ExceptionTestPage(),
    testExpRoute: (BuildContext context) => new ExpTestPage(),
    testDeprecatedRoute: (BuildContext context) => new DeprecatedTestPage(),
  };
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Sqflite Demo',
        theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting
          // the app, try changing the primarySwatch below to Colors.green
          // and then invoke "hot reload" (press "r" in the console where
          // you ran "flutter run", or press Run > Hot Reload App in IntelliJ).
          // Notice that the counter didn't reset back to zero -- the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: new MyHomePage(title: 'Sqflite Demo Home Page'),
        routes: routes);
  }
}

class MyHomePage extends StatefulWidget {
  final List<MainItem> items = [];

  MyHomePage({Key key, this.title}) : super(key: key) {
    items.add(new MainItem("Raw tests", "Raw SQLite operations",
        route: testRawRoute));
    items.add(new MainItem("Open tests", "Open onCreate/onUpgrade/onDowngrade",
        route: testOpenRoute));
    items.add(
        new MainItem("Type tests", "Test value types", route: testThreadRoute));
    items.add(
        new MainItem("Slow tests", "Lengthy operations", route: testSlowRoute));
    items.add(new MainItem(
        "Todo database example", "Simple Todo-like database usage example",
        route: testTodoRoute));
    items.add(new MainItem("Exp tests", "Experimental and various tests",
        route: testExpRoute));
    items.add(new MainItem("Exception tests", "Tests that trigger exceptions",
        route: testExceptionRoute));
    items.add(new MainItem("Deprecated test",
        "Keeping some old tests for deprecated functionalities",
        route: testDeprecatedRoute));

    // Uncomment to view all logs
    //Sqflite.devSetDebugModeOn(true);
  }

  // This widget is the home page of your application. It is stateful,
  // meaning that it has a State object (defined below) that contains
  // fields that affect how it looks.

  // This class is the configuration for the state. It holds the
  // values (in this case the title) provided by the parent (in this
  // case the App widget) and used by the build method of the State.
  // Fields in a Widget subclass are always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';

  int get _itemCount => widget.items.length;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Sqflite.platformVersion;
    } on PlatformException {
      platformVersion = "Failed to get platform version";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });

    print("running on: " + _platformVersion);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Center(
              child: new Text('Sqflite demo', textAlign: TextAlign.center)),
        ),
        body: new ListView.builder(
            itemBuilder: _itemBuilder, itemCount: _itemCount));
  }

  //new Center(child: new Text('Running on: $_platformVersion\n')),

  Widget _itemBuilder(BuildContext context, int index) {
    return new MainItemWidget(widget.items[index], (MainItem item) {
      Navigator.of(context).pushNamed(item.route);
    });
  }
}
