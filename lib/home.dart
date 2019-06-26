import 'package:flutter/material.dart';
import './components/recentList.dart';
import './request/request.dart';
import './api/api.dart' show recent;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List manhuaList;
  bool reTry = false;
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

  void _reload() {
    setState(() {
      reTry = false;
    });
    this._getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: Column(
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
            child: FadeInImage.assetNetwork(
              image: 'https://ws1.sinaimg.cn/large/005O2C54gy1g3zkb812hcj30go0nk0x6.jpg',
              placeholder: 'assets/image/default.png',
              fit: BoxFit.cover,
            ),
          ),
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
    );
  }
}
