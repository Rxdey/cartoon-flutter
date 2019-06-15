import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './request/request.dart';
import './api/api.dart';

class Detail extends StatefulWidget {
  String id;
  Detail({Key key, this.id}) : super(key: key);
  @override
  _DetailState createState() => _DetailState(id);
}

class _DetailState extends State<Detail> {
  var lists;
  var head;
  String id;
  _DetailState(this.id);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getDate(id);
  }

  _getDate(String id) async {
    var res = await HttpRequest.request(manhuaContent, {'id': id, 'st': 1});
    if (res['state'] != 1) return;
    print(res['data']['head']);
    setState(() {
      lists = res['data']['lists'];
      head = res['data']['head'];
      // print(res['data']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Container(
          width: double.infinity,
          height: 300.0,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/image/default.png',
            image: HOST + '/gethanhanimage?url=' + head['cover'],
            fit: BoxFit.cover,
          ),
        ),
      ]),
    );
  }
}
