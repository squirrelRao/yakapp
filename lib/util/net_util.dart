import 'dart:convert';
import 'package:dio/dio.dart';

import 'common_util.dart';

class NetClient {

  String contentType = "application/json";
  late Dio dio;

  NetClient(){

    dio = Dio();
    dio.options.connectTimeout = 5000;
    dio.options.contentType = contentType;
  }

   get(url, Function function) async {

          var response = await dio.get(url);

          try{

            if (response.statusCode == 200){

              Map data = new Map<String, dynamic>.from(response.data);
              LogUtil.i(data);
              return function.call(data);


            }else{
              LogUtil.e(response);
            }

          } on DioError catch (e){

        LogUtil.e(e.toString());
        return;
      }
  }

    post(url, param, Function function) async {

    var response = await dio.post(url, data: param);

    try{

      if (response.statusCode == 200){

        Map data = new Map<String, dynamic>.from(response.data);
        LogUtil.i(data);
        function.call(data);

      }else{
        LogUtil.e(response);
      }

    } on DioError catch (e){

      LogUtil.e(e.toString());
      return;
    }
  }



}

