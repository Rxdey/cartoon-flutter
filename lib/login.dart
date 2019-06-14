import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign In',
            style: TextStyle(color: Colors.black),
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
                    onChanged: (v){
                      username = v;
                    },
                    decoration: InputDecoration(hintText: '账号')),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(hintText: '密码')),
              ),
              Container(
                width: double.infinity,
                height: 40,
                child: RaisedButton(
                  color: Colors.yellow,
                  child: Text('Sign in'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  onPressed: () {
                    if (username == '') return;
                    Fluttertoast.showToast(msg: 'username: $username');
                  },
                ),
              )
            ],
          )),
        ));
  }
}
