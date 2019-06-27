import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:fluttertoast/fluttertoast.dart';
import './request/request.dart';
import './reader.dart';
import './api/api.dart';

class Detail extends StatefulWidget {
  final String id;
  Detail({Key key, this.id}) : super(key: key);
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List lists = [];
  List currentLists = [];
  Map head = {
    'author': '',
    'cover': '',
    'date': '',
    'desc': '',
    'name': '',
    'state': '',
  };
  int index = 14;
  int active = 0;
  bool showCover = false;
  bool sort = true;
  bool isSubscribe = false;

  @override
  void initState() {
    super.initState();
    // print(head);
    this._getDate(widget.id);
  }

  _getDate(String id) async {
    var res = await HttpRequest.request(Api.manhuaContent, {'id': id, 'st': 1});
    if (res['state'] != 1) return;
    // print(res['data']['head']);
    setState(() {
      this.lists = res['data']['lists'];
      this.head = res['data']['head'];
      int len = this.lists.length;
      List tempArr = this.lists;
      if (len > index + 2) {
        tempArr = this.lists.sublist(0, this.index);
        tempArr.add({'name': '...', 'url': 'more'});
        tempArr.add(this.lists[len - 1]);
      }
      this.currentLists = tempArr;
    });
  }

  List<Widget> createChaper(List array, BuildContext context) {
    return array
        .asMap()
        .map((key, item) => MapEntry(
            key,
            InkWell(
              onTap: () {
                if (item['url'] == 'more') {
                  this._showModalBottomSheet(context);
                  return;
                }
                Navigator.push(context, CupertinoPageRoute(builder: (context) {
                  return Reader(url: item['url']);
                }));
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  width: 80.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: this.active == key
                              ? Colors.orange
                              : Colors.grey[200],
                          width: 1),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    item['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: this.active == key ? Colors.orange : Colors.black,
                    ),
                  )),
            )))
        .values
        .toList();
  }

  _showModalBottomSheet(BuildContext context, {Widget child}) {
    Widget chapers = SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15.0),
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: this.createChaper(lists, context),
        ),
      ),
    );
    bool loading = false;
    child = child ?? chapers;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.grey[200], width: 1.0))),
                  child: Text(
                    '全部章节',
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: loading
                      ? Text(
                          '加载中...',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        )
                      : child,
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // if(head == null) return null;
    return Scaffold(
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  this.showCover = !this.showCover;
                  print(showCover);
                });
              },
              child: Container(
                width: double.infinity,
                height: !this.showCover ? 280.0 : null,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/image/default.png',
                  image: HOST + '/gethanhanimage?url=' + head['cover'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    head['name'],
                    style: TextStyle(fontSize: 18.0, color: Colors.orange),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 15.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0XFFE5E5E5), width: 0.5))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            head['author'],
                            style: TextStyle(
                                color: Color(0XFF999999), fontSize: 11.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            '更新: ' + head['date'],
                            style: TextStyle(
                                color: Color(0XFF999999), fontSize: 11.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      head['state'],
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                  Text(
                    head['desc'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Color(0XFF999999), fontSize: 12.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                    child: Text(
                      '全部章节(' + this.lists.length.toString() + ')',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    // alignment: WrapAlignment.center, //沿主轴方向居中
                    children: this.createChaper(this.currentLists, context),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        padding:
            EdgeInsets.only(left: 15.0, right: 15.0, top: 2.0, bottom: 2.0),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Color(0XFFE5E5E5), blurRadius: 5.0, spreadRadius: 5.0)
        ]),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    this.isSubscribe = !this.isSubscribe;
                  });
                },
                child: Row(
                  children: this.isSubscribe
                      ? <Widget>[
                          Icon(
                            Icons.favorite,
                            color: Colors.orange,
                            size: 16,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0, right: 3.0),
                            child: Text(
                              '已追',
                              style: TextStyle(color: Colors.orange),
                            ),
                          )
                        ]
                      : <Widget>[
                          Icon(
                            Icons.favorite_border,
                            size: 16,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.0, right: 3.0),
                            child: Text('追漫'),
                          )
                        ],
                ),
              ),
            ),
            Container(
              child: RaisedButton(
                color: Colors.yellow,
                // highlightColor: Colors.blue[700],
                colorBrightness: Brightness.dark,
                // splashColor: Colors.grey,
                textColor: Colors.black,
                child: Text("开始阅读"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: () => {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
