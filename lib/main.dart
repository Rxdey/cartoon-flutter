import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'subscription.dart';
import 'login.dart';
import 'home.dart';
import 'user.dart';
import 'search.dart';
import './components/iconfont.dart';
// import './components/loading.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class TabList {
  String name;
  String key;
  Icon icon;
  Widget page;
  TabList(this.name, this.key, this.icon, this.page);
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // int _selectedIndex = 0;
  TabController _tabController; //需要定义一个Controller
  List<TabList> tabs = [
    TabList('首页', 'home', Icon(IconFont.zhuye), Home()),
    TabList('订阅', 'sub', Icon(IconFont.wenjian), Subscription()),
    TabList('搜索', 'search', Icon(IconFont.sousuo), Search()),
    TabList('我的', 'user', Icon(IconFont.wode), User()),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: TabBarView(
          controller: _tabController,
          children: tabs
              .map((item) => Stack(
                    children: <Widget>[item.page],
                  ))
              .toList(),
          // children: tabs.map((val) => Text(val['label'])).toList(),
        ),
      ),
      bottomNavigationBar: Container(
        child: SafeArea(
          child: TabBar(
              indicatorWeight: 1,
              indicator: const BoxDecoration(),
              labelColor: Colors.orange,
              labelPadding: EdgeInsets.only(top: 5, bottom: 5),
              unselectedLabelColor: Colors.black,
              unselectedLabelStyle: TextStyle(fontSize: 12, height: 0.2),
              labelStyle: TextStyle(fontSize: 12),
              controller: _tabController,
              tabs: tabs
                  .map((item) => Tab(
                        icon: item.icon,
                        // text: item.name,
                      ))
                  .toList()),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   fixedColor: Color(0XFFf7971a),
      //   iconSize: 18,
      //   selectedFontSize: 12,
      //   unselectedFontSize: 12,
      //   onTap: _onItemTapped,
      //   type: BottomNavigationBarType.fixed,
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         icon: Icon(IconFont.zhuye), title: Text('首页')),
      //     BottomNavigationBarItem(
      //         icon: Icon(IconFont.wenjian), title: Text('订阅')),
      //     BottomNavigationBarItem(
      //         icon: Icon(IconFont.sousuo), title: Text('搜索')),
      //     BottomNavigationBarItem(icon: Icon(IconFont.wode), title: Text('我的')),
      //   ],
      // ),
    );
  }
}
