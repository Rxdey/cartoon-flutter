import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myapp/api/api.dart';
import 'package:myapp/request/request.dart';
import 'package:myapp/util/util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = '';
  String password = '';
  bool isLoading = false;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });
    var res = await HttpRequest.request(Api.login, {
      'username': username,
      'password': generateMd5(password)
    });
    setState(() {
      isLoading = false;
    });
    if (res['state'] != 1) {
      Fluttertoast.showToast(msg: res['msg'], textColor: Colors.red, gravity: ToastGravity.CENTER);
      print('---------$res--------------');
      return;
    }
    print('---------$res--------------');
    await addStringItem('userName', res['data'][0]['user_name']);
    await addStringItem('userId', res['data'][0]['id'].toString());
    Navigator.pop(context, 'success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign In',
            // style: TextStyle(color: Colors.black),
          ),
          // iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextField(
                    autofocus: true,
                    onChanged: (v) {
                      setState(() {
                        username = v;
                      });
                    },
                    decoration: InputDecoration(hintText: '账号')),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                    obscureText: true,
                    onChanged: (v) {
                      setState(() {
                        password = v;
                      });
                    },
                    decoration: InputDecoration(hintText: '密码')),
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: FlatButton(color: Colors.yellow, child: Text('Sign in'), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)), disabledColor: Colors.yellow[200], onPressed: (username == '' || password == '') || isLoading ? null : _login),
              )
            ],
          )),
        ));
  }
}
