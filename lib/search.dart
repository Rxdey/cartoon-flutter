import 'package:flutter/material.dart';
import 'package:myapp/components/iconfont.dart';
import 'package:myapp/components/recentList.dart';
import 'package:myapp/api/api.dart';
import 'package:myapp/request/request.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // String screen;
  List manhuaList;
  bool isLoading = false;

  Future<void> _getDate(String val) async {
    print('-------------------参数：$val-------------------');
    print(isLoading);
    if (val == null || isLoading == true) return;
    setState(() {
      isLoading = true;
    });
    var res = await HttpRequest.request(Api.searchManhua, {'keywd': val});
    setState(() {
      isLoading = false;
    });
    if (res['state'] != 1) return;
    setState(() {
      manhuaList = res['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    double stateBarH = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: double.infinity,
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.yellow,
                padding: EdgeInsets.fromLTRB(15, stateBarH + 15, 15, 15),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(right: 7, left: 5, bottom: 4),
                          child: Icon(
                            IconFont.sousuo,
                            size: 18,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            onSubmitted: (v) {
                              this._getDate(v);
                            },
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                                hintText: '开车开车~  🚌 🚙',
                                border: InputBorder.none),
                          ),
                        )
                      ],
                    )),
              ),
              Expanded(
                flex: 1,
                child: isLoading
                    ? Text(
                        '加载中...',
                        style: TextStyle(color: Colors.lightBlue, height: 10),
                      )
                    : Scrollbar(
                        child: this.manhuaList != null
                            ? ListView.builder(
                                padding: EdgeInsets.all(5.0),
                                itemCount: this.manhuaList.length,
                                itemBuilder: (context, idx) {
                                  return RecentList(this.manhuaList[idx]);
                                })
                            : Text('🤣', style: TextStyle(height: 10))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
