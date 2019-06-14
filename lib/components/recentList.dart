import 'package:flutter/material.dart';

class RecentList extends StatelessWidget {
  final Map data;
  RecentList(this.data);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: 75.0,
              height: 99.0,
              child: Image.network(
                  'http://10.255.74.163:3000/gethanhanimage?url=' +
                      data['cover']),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 99.0,
                color: Colors.white,
                child: Text('测试'),
              ),
            )
          ],
        ),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.yellow, //阴影颜色
            blurRadius: 5.0, //阴影大小
          ),
        ]),
      ),
    );
  }
}
