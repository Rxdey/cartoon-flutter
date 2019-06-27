// const HOST = 'http://192.168.0.112:3000';
const HOST = 'http://10.255.74.163:3000';
// const HOST = 'http://manhua.rxdey.xyz';

class Interface {
  String url;
  String method;
  String baseUrl;
  Interface({this.url, this.method = 'get', this.baseUrl = HOST});
}

class Api {
  static Interface searchManhua = Interface(url: '/hanhan/search/manhua');
  static Interface manhuaContent = Interface(url: '/hanhan/manhua/content');
  static Interface manhuaImage = Interface(url: '/hanhan/manhua/image');
  static Interface recent = Interface(url: '/hanhan/manhua/recent');
  static Interface login = Interface(url: '/login');
  static Interface subscribe = Interface(url: '/hanhan/manhua/subscribe');
  static Interface substate = Interface(url: '/hanhan/manhua/substate');
  static Interface sublist = Interface(url: '/hanhan/manhua/sublist');
  static Interface record = Interface(url: '/hanhan/manhua/record');
}