import 'package:flutter/material.dart';
// import 'package:flutter_advanced_networkimage/transition.dart';
// import 'package:flutter_advanced_networkimage/provider.dart';
// import 'package:flutter_advanced_networkimage/transition.dart';
// import 'package:flutter_advanced_networkimage/zoomable.dart';

import './request/request.dart';
import './api/api.dart';

// // 测试用
// const List TESTIMAGE = [
//   'https://ws1.sinaimg.cn/large/005O2C54gy1fz9p8wvsmej30u01dqq5n.jpg',
//   'https://ws1.sinaimg.cn/large/005O2C54gy1fzopn84ptgj30jg0yl0vh.jpg',
//   'https://ws1.sinaimg.cn/large/005O2C54gy1g30vsehl2ej30cl0cjqc0.jpg',
//   'https://ws1.sinaimg.cn/large/005O2C54gy1g3zkb812hcj30go0nk0x6.jpg',
// ];

class Reader extends StatefulWidget {
  final String url;
  Reader({Key key, this.url}) : super(key: key);
  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  List imageList;
  @override
  void initState() {
    super.initState();
    this._getDate(widget.url);
  }

  _getDate(String url) async {
    var res = await HttpRequest.request(Api.manhuaImage, {'url': url});
    if (res['state'] != 1) return;
    setState(() {
      this.imageList = res['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: double.infinity,
        ),
        child: Container(
          color: Colors.black,
          child: this.imageList != null
              ? ListView.builder(
                  itemCount: this.imageList.length,
                  itemBuilder: (context, idx) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/image/default.png',
                        image: this.imageList[idx]['url'],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                )
              : Text('loading...'),
        ),
      ),
    );
  }
}
