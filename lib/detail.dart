import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:fluttertoast/fluttertoast.dart';
import './request/request.dart';
import './api/api.dart';

class Detail extends StatefulWidget {
  String id;
  Detail({Key key, this.id}) : super(key: key);
  @override
  _DetailState createState() => _DetailState(id);
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
  String id;
  int index = 10;
  int active = 0;
  bool showCover = false;
  bool sort = true;

  _DetailState(this.id);

  @override
  void initState() {
    super.initState();
    // print(head);
    this._getDate(id);
  }

  _getDate(String id) async {
    var res = await HttpRequest.request(manhuaContent, {'id': id, 'st': 1});
    if (res['state'] != 1) return;
    // print(res['data']['head']);
    setState(() {
      this.lists = res['data']['lists'];
      List tempArr = this.lists.sublist(0, this.index);
      int len = this.lists.length;
      tempArr.add({'name': '...', 'url': 'more'});
      tempArr.add(this.lists[len - 1]);
      this.currentLists = tempArr;
      this.head = res['data']['head'];
    });
  }

  List<Widget> createChaper(List array, BuildContext context) {
    return array
        .asMap()
        .map((key, item) => MapEntry(
            key,
            GestureDetector(
              onTap: () {
                if (item['url'] == 'more') {
                  this._showModalBottomSheet(context);
                  return;
                }
              },
              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  width: 83.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: this.active == key
                              ? Colors.orange[200]
                              : Colors.grey,
                          width: 1.0),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(
                    item['name'],
                    textAlign: TextAlign.center,
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
                          bottom: BorderSide(
                              color: Color(0XFFE5E5E5), width: 1.0))),
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
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Color(0XFFE5E5E5), width: 1.0))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            head['author'],
                            style: TextStyle(
                                color: Color(0XFF999999), fontSize: 12.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            '更新: ' + head['date'],
                            style: TextStyle(
                                color: Color(0XFF999999), fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(head['state']),
                  ),
                  Text(
                    head['desc'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Color(0XFF999999)),
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
            ),
          ]),
        ),
      ),
    );
  }
}
