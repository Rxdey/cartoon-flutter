import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import './components/recentList.dart';
import './components/iconfont.dart';
import './components/loading.dart';
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
  List manhuaList;
  bool reTry = false;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    this._getData();
  }

  Future<void> _getData() async {
    // print(222);
    var res = await HttpRequest.request(recent);
    if (res['state'] != 1) {
      setState(() {
        reTry = true;
      });
      return;
    }
    // print(res['data']);
    setState(() {
      manhuaList = res['data'];
      reTry = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _reload() {
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return new NetLoadingDialog(
    //         dismissDialog: _disMissCallBack,
    //         outsideDismiss: false,
    //       );
    //     });
    setState(() {
      reTry = false;
    });
    this._getData();
  }
  // void _disMissCallBack() {
    
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.yellow, //阴影颜色
                  blurRadius: 10.0, //阴影大小
                ),
              ]),
              child: ClipRect(
                child: FadeInImage.assetNetwork(
                  image:
                      'https://ws1.sinaimg.cn/large/005O2C54gy1g3zkb812hcj30go0nk0x6.jpg',
                  placeholder: 'assets/image/default.png',
                  fit: BoxFit.cover,
                ),
              )),
          Expanded(
            flex: 1,
            child: reTry
                ? Container(
                    // height: double.infinity,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: _reload,
                      child: Text('点击重试',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.lightBlue)),
                    ))
                : Container(
                    width: double.infinity,
                    height: 200,
                    color: Color(0xFFF7F7F7),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          children: manhuaList != null
                              ? manhuaList
                                  .map((item) => RecentList(item))
                                  .toList()
                              : <Widget>[],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        fixedColor: Color(0XFFf7971a),
        iconSize: 18,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(IconFont.zhuye), title: Text('首页')),
          BottomNavigationBarItem(
              icon: Icon(IconFont.wenjian), title: Text('订阅')),
          BottomNavigationBarItem(
              icon: Icon(IconFont.sousuo), title: Text('搜索')),
          BottomNavigationBarItem(icon: Icon(IconFont.wode), title: Text('我的')),
        ],
      ),
    );
  }
}
