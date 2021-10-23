import 'dart:convert';
import 'package:dio/dio.dart';

import 'common_util.dart';

class NetClient {

  Dio dio = Dio();
  String contentType = "application/json";

  static late NetClient instance ;

  factory NetClient() => getInstance();

  static NetClient getInstance(){

    if(instance == null){
      instance = NetClient._internal();
    }
    return instance;
  }
  NetClient._internal(){

    dio.options.connectTimeout = 5000;
    dio.options.contentType = contentType;
  }

  void get(url) async {

          var response = await dio.get(url);

          try{

            if (response.statusCode == 200){

              Map data = new Map<String, dynamic>.from(response.data);
              LogUtil.i(data);


            }else{
              LogUtil.e(response);
            }

          } on DioError catch (e){

        LogUtil.e(e.toString());
        return;
      }
  }

  void post(url, param) async {

    var response = await dio.post(url, queryParameters: param);

    try{

      if (response.statusCode == 200){

        Map data = new Map<String, dynamic>.from(response.data);
        LogUtil.i(data);


      }else{
        LogUtil.e(response);
      }

    } on DioError catch (e){

      LogUtil.e(e.toString());
      return;
    }
  }



}

