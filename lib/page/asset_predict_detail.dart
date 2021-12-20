
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/asset_market_setting.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_echarts/flutter_echarts.dart';


class AssetPredictDetailPage extends StatefulWidget{

  AssetPredictDetailPage({required this.asset, required this.interval});

  var asset ="";
  var interval;

  @override
  State createState()  => AssetPredictDetailState(asset: asset, interval: interval);
}

class AssetPredictDetailState extends State<AssetPredictDetailPage>{

  AssetPredictDetailState({required this.asset, required this.interval});

  var asset;
  var title = "价格预测";
  var data;
  var interval;


  Widget showPredictChart(){

    if(data == null){
      return Container();
    }

    var history_x = [];
    var history_y = [];

    var y = [];
    var inter = 10;
    var m = inter+1;
    while( m >= 1){
      if(data["history_predict"]["x"].length-m < 0){
        m-=1;
        continue;
      }
      var n = data["history_predict"]["x"][data["history_predict"]["x"].length-m];
      history_x.add(n);
      if(data["history_kline"][n] != null){
        history_y.add(data["history_kline"][n]);
      }else{
        history_y.add("-");
      }
      y.add("-");
      m-=1;
    }
    if(y.length > 0 ) {
      y.remove(y.last);
    }
    var predict = data["predict"];

    if(predict["y"] != null && predict["y"].length > 0) {
      if (history_y.length - 1 > 0) {
        predict["y"][0] = history_y[history_y.length - 1];
      } else {
        predict["y"].add(0);
      }
    }

    var x = history_x;
    if(x.length > 0) {
      x.remove(x.last);
    }
    x.addAll(predict["x"]);
    y.addAll(predict["y"]);

    var line_x = "[";

    var i = 0;
    for(var j in x){
      if(i >= 0){
        // if(i == inter-1){
        //   j = "现在";
        // }
        var item = "'"+j+"'";
        line_x = line_x + item;
        if(i != x.length-1){
          line_x = line_x +",";
        }
      }
      i+=1;
    }
    line_x = line_x +"]";

    var line_y = "[";
    i = 0;
    for(var j in y){
      if(j == null){
        i+=1;
        continue;
      }
      var item = "'"+j.toString()+"'";
      line_y = line_y + item;
      if(i != y.length-1){
        line_y = line_y +",";
      }
      i += 1;
    }
    line_y = line_y +"]";

    var line_history_y = "[";
    i = 0;
    for(var j in history_y){
      var item = "'"+j+"'";
      line_history_y = line_history_y + item;
      if(i != history_y.length-1){
        line_history_y = line_history_y +",";
      }
      i += 1;
    }
    line_history_y = line_history_y +"]";

    var option ='''
    {
      title: {
        left: 'center',
        text: '价格走势',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 14},
        top: '6%'
      },
      color:['#48ABFD'],
      tooltip:{
        show:true,
        trigger: 'axis',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 14}
      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: $line_x,
        axisLabel:{
          show:true,
          textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 10},
        }
       
      },
      color:['#48ABFD','#02AC8F'],
       legend: {
        data: ['实际价格', '预测价格'],
        x:'center',
        y:'bottom',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 10},

    },
      yAxis: {
        type: 'value',
        scale:true,
        axisLabel:{
          margin:3,
          show:true,
          textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 9},
        }
      },
      series: [{
        data: $line_y,
        name:'预测价格',
        type: 'line',
        smooth: false,
        showSymbol: false,
        lineStyle:{
          normal:{
            color:"#48ABFD",
            width:1.8,
            type:'dotted'      
          } 
        }
      },
      {
        data: $line_history_y,
        type: 'line',
        name:'实际价格',
        smooth: false,
        showSymbol: false,
        lineStyle:{
          normal:{
            color:"#02AC8F",
            width:2,
          } 
        }
      }]
    }
  ''';


    return Container(
            alignment: Alignment.center,
            height: 300.0,
            width:600,
            child:Echarts(option:option),
    );

  }

  Widget showLatestHPChart(){

    if(data == null){
      return Container();
    }
    var predict = data["history_predict"];
    var x = predict["x"];
    var y = predict["y"];
    var deviation = data["deviation"];
    var _avg = deviation["avg"];
    var _max = deviation["max"];
    var _min = deviation["min"];

    var line_x = "[";

    var kline_ys = [];

    var i = 0;
    for(var j in x){
      if(i == 0 || i  % 1 == 0 || i == x.length-1){

        if(data["history_kline"][j] != null){
          kline_ys.add(data["history_kline"][j]);
        }else{
          kline_ys.add("-");
        }
        var item = "'"+j+"'";
        line_x = line_x + item;
        if(i != x.length-1){
          line_x = line_x +",";
        }
      }
      i+=1;
    }
    line_x = line_x +"]";

    var line_y = "[";
    i = 0;
    for(var j in y){
      var item = "'"+j+"'";
      line_y = line_y + item;
      if(i != y.length-1){
        line_y = line_y +",";
      }
      i += 1;
    }
    line_y = line_y +"]";

    var line_h = "[";
    i = 0;
    for(var j in kline_ys){
      var item = "'"+j+"'";
      line_h = line_h + item;
      if(i != y.length-1){
        line_h = line_h +",";
      }
      i += 1;
    }
    line_h = line_h +"]";

    var option ='''
    {
      title: {
        left: 'center',
        text: '实际与预测',
        subtext:'平均偏差: $_avg% 最大偏差: $_max% 最小偏差: $_min%',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 14},
        subtextStyle:{color: '#999999',fontWeight: 'normal',fontSize: 11},
        top: '5%',
      },
      grid:{
        top:'25%'
      },
       dataZoom:[{type:"inside"}],
       tooltip:{
        show:true,
        trigger: 'axis',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 14}
      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: $line_x,
        axisLabel:{
          show:true,
          textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 10},
        }
       
      },
      yAxis: {
        type: 'value',
        scale:true,
        axisLabel:{
          margin:3,
          show:true,
          textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 9},
        }
      },
      color:['#48ABFD','#02AC8F'],
       legend: {
        data: ['实际价格', '预测价格'],
        x:'center',
        y:'bottom',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 10},

    },
      series: [{
        data: $line_y,
        type: 'line',
        smooth: true,
        name:'预测价格',
        showSymbol: false,
        lineStyle:{
          normal:{
            color:"#48ABFD",
            width:1.8,
            type:'dotted'      
          } 
        }
      },
      {
        data: $line_h,
        type: 'line',
        smooth: true,
        name:'实际价格',
        showSymbol: false,
        lineStyle:{
          normal:{
            color:"#02AC8F",
            width:2,
          } 
        }
      }]
    }
  ''';


    return Container(
      alignment: Alignment.center,
      height: 300.0,
      width:600,
      child:Echarts(option:option),
    );
  }

  Widget showLossAndValLoss(){

    if(data == null){
      return Container();
    }
    var train = data["train_history"];
    var x = [];
    var y = train["loss"];

    if(y == null){
      y = [];
    }

    var i = 0;
    while(y != null && i < y.length){
      x.add(i);
      i+=1;
    }

    var line_x = "[";

    i = 0;
    for(var j in x){
      if(i != 0){

        var item = "'"+j.toString()+"'";
        line_x = line_x + item;
        if(i != x.length-1){
          line_x = line_x +",";
        }
      }
      i+=1;
    }
    line_x = line_x +"]";

    var line_y = "[";
    i = 0;
    for(var j in y){
      if(i != 0) {
        var item = "'" + j.toString() + "'";
        line_y = line_y + item;
        if (i != y.length - 1) {
          line_y = line_y + ",";
        }
      }
      i += 1;
    }
    line_y = line_y +"]";

    var line_h = "[";
    i = 0;

    var _t = train["val_loss"];
    if(_t == null){
      _t = [];
    }
    for(var j in _t){
      var item = "'"+j.toString()+"'";
      line_h = line_h + item;
      if(i != y.length-1){
        line_h = line_h +",";
      }
      i += 1;
    }
    line_h = line_h +"]";

    var option ='''
    {
      title: {
        left: 'center',
        text: 'LOSS',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 14},
        top: '5%'
      },
       tooltip:{
        show:true,
        trigger: 'axis',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 14}
      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: $line_x,
        axisLabel:{
          show:true,
          textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 10},
        }
       
      },
      yAxis: {
        type: 'value',
        scale:true,
        axisLabel:{
          margin:3,
          show:true,
          textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 8.5},
        }
      },
       color:['#02AC8F','#48ABFD'],
       legend: {
        data: ['loss', 'val_loss'],
        x:'center',
        y:'bottom',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 10},

    },
      series: [{
        data: $line_y,
        type: 'line',
        smooth: true,
        name:'loss',
        showSymbol: false,
        lineStyle:{
          normal:{
            color:"#02AC8F",
            width:2,
          } 
        }
      },
      {
        data: $line_h,
        type: 'line',
        smooth: true,
        name:'val_loss',
        showSymbol: false,
        lineStyle:{
          normal:{
            color:"#48ABFD",
            width:2,
          } 
        }
      }]
    }
  ''';


    return Container(
      alignment: Alignment.center,
      height: 300.0,
      width:600,
      child:Echarts(option:option),
    );
  }

  void queryPredictDetail() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");


      (NetClient()).post(Configs.getPredictDetail, {"user_id":userId,"asset":asset,"interval":interval}, (data){
        title = asset+"价格预测";
        if(data["rc"] == 0 && data["data"] != ""){
          this.data = data["data"];

          Future.delayed(const Duration(milliseconds: 280), ()
          {
            setState(() {

            });
          });

        }else{
          setState(() {


          });
        }


    });


  }

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> queryPredictDetail());
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

          body: RefreshIndicator(

              onRefresh: () async {


                data.clear();
                queryPredictDetail();
              },


            child: ListView(
                      children: <Widget>[
                        showPredictChart(),
                        showLatestHPChart(),
                        showLossAndValLoss(),
                        SizedBox(height:10)
                      ])

           ),

    );
  }


}
