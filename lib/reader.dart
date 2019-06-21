import 'package:flutter/material.dart';
import './request/request.dart';
import './api/api.dart';

class Reader extends StatefulWidget {
  final String url;
  Reader({Key key, this.url}) : super(key: key);
  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: double.infinity,
        ),
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}
