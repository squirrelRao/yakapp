
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

  AssetPredictDetailPage({required this.asset});

  var asset ="";

  @override
  State createState()  => AssetPredictDetailState(asset: asset);
}

class AssetPredictDetailState extends State<AssetPredictDetailPage>{

  AssetPredictDetailState({required this.asset});

  var asset;
  var title = "价格预测详情";
  var data;


  Widget showPredictChart(){

    if(data == null){
      return Container();
    }
    var predict = data["predict"];
    var x = predict["x"];
    var y = predict["y"];

    var line_x = "[";

    var i = 0;
    for(var j in x){
      if(i == 0 || i  % 10 == 0 || i == x.length-1){
        if(i == 0){
          j = "现在";
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

    var option ='''
    {
      title: {
        left: 'center',
        text: '未来1小时价格走势',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 14},
        top: '6%'
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
          textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 10},
        }
      },
      series: [{
        data: $line_y,
        type: 'line',
        smooth: true,
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

  Widget showLatestHPChart(){

    if(data == null){
      return Container();
    }
    var predict = data["history_predict"];
    var x = predict["x"];
    var y = predict["y"];

    var line_x = "[";

    var i = 0;
    for(var j in x){
      if(i == 0 || i  % 10 == 0 || i == x.length-1){

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
    for(var j in data["history_kline"]){
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
        text: '历史预测与实际价格对比',
        subtext:'(最近两小时)',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 14},
        top: '0%'
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
          textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 10},
        }
      },
       color:['#48ABFD','#02AC8F'],
       legend: {
        data: ['预测价格', '实际价格'],
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
            width:2,
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

    var i = 0;
    while(i < y.length){
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
    for(var j in train["val_loss"]){
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
        text: '预测损失值对比',
        textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 14},
        top: '5%'
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
          textStyle: {color: '#999999',fontWeight: 'normal',fontSize: 10},
        }
      },
       color:['#48ABFD','#02AC8F'],
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
            color:"#48ABFD",
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

  void queryPredictDetail() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getPredictDetail, {"user_id":userId,"asset":asset}, (data){
      title = asset+"价格预测详情";
      if(data["rc"] == 0 && data["data"] != ""){
        this.data = data["data"];

        setState(() {


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

          appBar:AppBar(
            title: Text(this.title,style:TextStyle(color: Color(0xff323232),fontSize: 17)),
              backgroundColor: Colors.white70,
              elevation: 0,
              centerTitle: true,
              actions: [IconButton(
                  icon: Icon(Icons.segment,size: 24,color: Color(0xff323232),),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (content){return AssetMarketSettingPage(asset: asset);}));
                  })],
              leading: IconButton(
                icon:Image(
                  width:24,
                  height:24,
                  image: AssetImage("images/back.png"),
                ),
                onPressed: () async {
                    Navigator.pop(context);
                },
              )
          ),

          body:  GestureDetector(

    behavior: HitTestBehavior.translucent,
    onTap:() {
    FocusScope.of(context).requestFocus(FocusNode());
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
