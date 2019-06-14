import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import './components/recentList.dart';
import './request/request.dart';
import './api/api.dart' show recent;

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: HomePage(),
      routes: {'/login': (context) => LoginPage()},
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map> manhuaList = [];

  @override
  void initState() {
    super.initState();
    this._getData();
  }

  Future<void> _getData() async {
    // print(222);
    var res = await HttpRequest.request(recent);
    if (res['state'] != 1) return;
    setState(() {
      manhuaList = res['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.yellow, //阴影颜色
              blurRadius: 10.0, //阴影大小
            ),
          ]),
          child: Image(
              image: NetworkImage(
                  'https://ws1.sinaimg.cn/large/005O2C54gy1g3zkb812hcj30go0nk0x6.jpg'),
              fit: BoxFit.cover),
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            height: 200,
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: manhuaList.map((item) => RecentList(item)).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
