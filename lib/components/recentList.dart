import 'package:flutter/material.dart';
import '../api/api.dart' show HOST;
import '../detail.dart';

class RecentList extends StatelessWidget {
  final Map data;
  RecentList(this.data);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (BuildContext context) {
              return new Detail(id: data['id']);
            }));
          },
          child: Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 97.5,
                  height: 128.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/image/default.png',
                      image: HOST + '/gethanhanimage?url=' + data['cover'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 128.7,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          data['name'],
                          maxLines: 1,
                          style: TextStyle(
                              color: Color(0XFFf7971a),
                              height: 1.5,
                              fontSize: 18.0),
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
                          style:
                              TextStyle(height: 1.3, color: Colors.redAccent),
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
          ),
        ),
      ),
    );
  }
}
