import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/login.dart';
import 'package:myapp/util/util.dart';

class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> with AutomaticKeepAliveClientMixin {
  bool isLogin = false;
  String userName;
  String userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._userInfo();
  }

  Future<void> _userInfo() async {
    String userName = await getStringItem('userName');
    String userId = await getStringItem('userId');
    if (!userName.isEmpty && !userId.isEmpty) {
      setState(() {
        isLogin = true;
        userName = userName;
        userId = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
      child: Container(
        child: isLogin
            ? Column(
                children: <Widget>[],
              )
            : UnLogin(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class UnLogin extends StatelessWidget {
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
              }))
            },
          ),
        ],
      ),
    );
  }
}
