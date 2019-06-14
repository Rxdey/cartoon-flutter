import 'package:flutter/material.dart';

class RecentList extends StatelessWidget {
  final Map data;
  RecentList(this.data);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: 97.5,
              height: 128.7,
              padding: EdgeInsets.all(3),
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                // child: Image.network( 'http://10.255.74.163:3000/gethanhanimage?url=' + data['cover']),
                child: FadeInImage.assetNetwork(
                  placeholder:
                      'https://ws1.sinaimg.cn/large/005O2C54gy1g40rlsndyxj309l04ogld.jpg',
                  image: 'http://10.255.74.163:3000/gethanhanimage?url=' +
                      data['cover'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 128.7,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data['name'],
                      maxLines: 1,
                      style: TextStyle(color: Color(0XFFf7971a), height: 1.5, fontSize: 18.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      data['author'],
                      maxLines: 1,
                      style: TextStyle(height: 1.3),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '最新话' + data['last'],
                      maxLines: 1,
                      style: TextStyle(height: 1.3, color: Colors.redAccent),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      data['date'],
                      maxLines: 1,
                      style: TextStyle(height: 1.3),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        // decoration: BoxDecoration(boxShadow: [
        //   BoxShadow(
        //     color: Color(0xFFE5E5E5), //阴影颜色
        //     blurRadius: 5.0, //阴影大小
        //   ),
        // ]),
      ),
    );
  }
}
