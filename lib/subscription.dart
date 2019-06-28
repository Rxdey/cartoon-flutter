import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/login.dart';
import 'package:myapp/util/util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/api/api.dart';
import 'package:myapp/request/request.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

RefreshController _refreshController = RefreshController(initialRefresh: false);

class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> with AutomaticKeepAliveClientMixin {
  bool isLogin = false;
  String userName;
  String userId;
  List subscriptionList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._userInfo();
    print(userName);
  }

  Future _onRefresh() async {
    await this._getData(userId, userName);
    _refreshController.refreshCompleted();
    print('>>>>>>>loading>>>>>');
  }

  Future<void> _getData(id, name) async {
    var res = await HttpRequest.request(Api.sublist, {
      'userId': id,
      'username': name,
      'st': new DateTime.now().millisecondsSinceEpoch
    });
    if (res['state'] != 1) {
      Fluttertoast.showToast(msg: res['msg'], textColor: Colors.red, gravity: ToastGravity.CENTER);
      return false;
    }
    setState(() {
      subscriptionList = res['data'];
    });
    return true;
  }

  Future<bool> _userInfo() async {
    String userName = await getStringItem('userName');
    String userId = await getStringItem('userId');
    if (userName != null && userId != null) {
      setState(() {
        isLogin = true;
        userName = userName;
        userId = userId;
      });
      _getData(userId, userName);
      return true;
    }
    return false;
  }

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double stateBarH = MediaQuery.of(context).padding.top;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
      child: Container(
        width: double.infinity,
        child: isLogin
            ? Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    color: Colors.yellow,
                    padding: EdgeInsets.fromLTRB(15, stateBarH + 15, 15, 15),
                    child: Text(
                      '订阅',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: SmartRefresher(
                          enablePullDown: true,
                          header: defaultTargetPlatform == TargetPlatform.iOS ? WaterDropHeader() : WaterDropMaterialHeader(),
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          // onLoading: _onLoading,
                          child: subscriptionList.length == 0
                              ? Text(
                                  '暂无订阅',
                                  style: TextStyle(color: Colors.lightBlue, height: 10),
                                )
                              : GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // 每行三列
                                    childAspectRatio: 0.59, // 显示区域宽高相等
                                    crossAxisSpacing: 10, // 水平间距
                                    mainAxisSpacing: 10, // 垂直间距
                                  ),
                                  padding: EdgeInsets.all(5.0),
                                  itemCount: subscriptionList.length,
                                  itemBuilder: (BuildContext context, idx) {
                                    return SubscriptionCard(subscriptionList[idx]);
                                  },
                                ),
                        ),
                      ))
                ],
              )
            : UnLogin((value) => {
                  setState(() {
                    isLogin = value == 'success';
                  })
                }),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SubscriptionCard extends StatelessWidget {
  final Map card;
  SubscriptionCard(this.card);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/image/v.png',
              image: card['cover'],
              fit: BoxFit.cover,
              // width: 150,
              // height: 198,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(card['name']),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              card['last_chapter'] >= 0 ? '看到' + card['last_chapter'].toString() + '话' : '未看',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class UnLogin extends StatelessWidget {
  final Function callBack;
  UnLogin(this.callBack);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: Text('要登陆的哦'),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Text(
              '登录',
              // style: TextStyle(color: Colors.white),
            ),
            color: Colors.yellow,
            onPressed: () => {
              // Navigator.of(context).pushNamed('/login')
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return LoginPage();
              })).then((value) => {
                    callBack(value)
                  })
            },
          ),
        ],
      ),
    );
  }
}
