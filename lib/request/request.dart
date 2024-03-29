import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api/api.dart';

/*
 * 封装 restful 请求
 * 
 * GET、POST、DELETE、PATCH
 * 主要作用为统一处理相关事务：
 *  - 统一处理请求前缀；
 *  - 统一打印请求信息；
 *  - 统一打印响应信息；
 *  - 统一打印报错信息；
 */
class HttpRequest {
  /// global dio object
  static Dio dio;

  /// default options
  // static const String API_PREFIX = ''; // base 地址
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 3000;

  /// http request methods
  static const String GET = 'GET';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  /// request method
  static Future<Map> request(Interface config,
      [Map<String, dynamic> data]) async {
    data = data ?? {};
    String method = config.method ?? 'GET';
    String url = config.url ?? '';
    String baseUrl = config.baseUrl ?? '';

    /// restful 请求处理
    /// /gysw/search/hist/:user_id        user_id=27
    /// 最终生成 url 为     /gysw/search/hist/27
    data.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });

    /// 打印请求相关信息：请求地址、请求方式、请求参数
    print('请求地址：【' + method + '  ' + baseUrl + url + '】');
    print('请求参数：' + data.toString());

    Dio dio = createInstance(baseUrl);
    var result;

    try {
      // Response response = await dio.request(url,
      //     data: data, options: new Options(method: 'GET'));

      // result = response.data;
      Response response;
      if (method.toLowerCase() == 'get') {
        response = await dio.get(url, queryParameters: data);
      }
      if (method.toLowerCase() == 'post') {
        response = await dio.post(url, data: data);
      }
      result = response.data;

      /// 打印响应相关信息
      print('状态：' + response.data['state'].toString());
    } on DioError catch (e) {
      /// 打印请求失败相关信息
      print('请求出错：' + e.toString());
      Fluttertoast.showToast(msg: '网络异常', textColor: Colors.red);
      result = {'state': 0};
    }

    return result;
  }

  /// 创建 dio 实例对象
  static Dio createInstance(String baseUrl) {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = new BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
      );

      dio = new Dio(options);
    }

    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }
}
