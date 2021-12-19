import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/asset_market_setting.dart';
import 'package:yakapp/page/asset_predict_detail.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';

import 'asset_predict.dart';



class FitValuePage extends StatefulWidget{


  @override
  State createState() => FitValueState();
}

class FitValueState extends State<FitValuePage>{

  List datas = [];
  int listCount = 0;
  var _timer;
  var volume_base = "";
  var depth = 0;

  var f = NumberFormat('###,###,###', 'en_US');


  void getFitValues() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if(uid == ""){
      return;
    }

    ((NetClient()).post(Configs.getFitValueApi, {"user_id":uid}, (data){



      if(data["rc"] == 0) {
        listCount = data["data"].length;
        datas = data["data"];

        volume_base = data["setting"]["base_volume_str"];
        depth = Decimal.parse(data["setting"]["depth_limit"].toString()).toInt();

        for(var item in datas){
          if(item["fit_value_abs"] < 100){
            item["fit_value_color"] = Color(0xffE95555);
          }else{
            item["fit_value_color"] = Color(0xff02AC8F);
          }

          if(double.parse(item["priceChangePercent"]) < 0){
            item["priceChangePercent_color"] = Color(0xffE95555);
          }else{
            item["priceChangePercent_color"] = Color(0xff02AC8F);
          }

          if(item["volume_up_change"]  < 100){
            item["volume_up_color"] = Color(0xffE95555);
          }else{
            item["volume_up_color"] = Color(0xff02AC8F);

          }
        }
      }

              setState(() {

              });
    }));

  }

  void RefreshDataPeriodic(){
    _timer = Timer.periodic(Duration(seconds: 2), (timestamp)=>getFitValues());
    getFitValues();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> RefreshDataPeriodic());


  }


  @override
  void dispose(){

    super.dispose();
    _timer.cancel();
  }

  Widget buildPredictWidget(item_index,predict_index){


    var item = datas[item_index];

    if(item["is_predict"] == 1 && predict_index < item["predict"].length) {

      var predict = item["predict"][predict_index];
      var _color = Color(0xff02AC8F);
      if (predict["price_change"] < 0) {
        _color = Color(0xffE95555);
      }

      var tip = predict["predict_hour_time"];

      return Padding(
          padding: EdgeInsets.only(left: 14, top: 8, right: 14, bottom: 0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    tip,
                    style: TextStyle(fontSize: 14)
                ),
                Text(
                    Decimal.parse(predict["predict_price"].toString()).toString(),
                    style: TextStyle(fontSize: 14)
                )
              ]));
    }else{

      return Container();
    }
  }

  Widget buildPredictDisabledWidget(item){

    if(item["is_predict"] != 1) {
      // return new Container(height:0.0,width:0.0);
      return Padding(
          padding: EdgeInsets.only(left: 14, top: 8, right: 14, bottom: 0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "预测价格",
                    style: TextStyle(fontSize: 14)
                ),
                Text(
                    item["is_predict_desc"],
                    style: TextStyle(fontSize: 14)
                )
              ]));
    }else{

      return Padding(
          padding: EdgeInsets.only(left: 14, top: 8, right: 14, bottom: 0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "预测价格",
                    style: TextStyle(fontSize: 14)
                ),
                Text(
                  item["predict_scale"],
                    style: TextStyle(fontSize: 14)
                )
              ]));
    }
  }

  Widget buildPredictChangeWidget(item_index){


    var item = datas[item_index];

    if(item["is_predict"] == 1 &&  item["predict"].length > 0) {

      var _color = Color(0xff02AC8F);
      if (item["predict_cur_change"] < 0) {
        _color = Color(0xffE95555);
      }
      return Padding(
          padding: EdgeInsets.only(left: 14, top: 2, right: 14, bottom: 0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "偏差",
                    style: TextStyle(fontSize: 11,color:Colors.grey)
                ),
                Text(
                    Decimal.parse(item["predict_cur_change"].toString()).toString()+"%",
                    style: TextStyle(fontSize: 11,color:_color)
                )
              ]));

    }else{
      return Container();
    }


  }
  //build asset summary
  Widget buildFitValueDetail(index){

    var item  = datas[index];
    var predict = item["predict"];
    var predict_count = predict.length;
    var _height = predict_count * 50;

    return GestureDetector(
      child:Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          elevation: 1.5,
          margin: const EdgeInsets.only(left:28,right:28,top:12),
          color: Colors.white,
          child:Column(
              children: [
                Padding(padding: EdgeInsets.only(left:14,top:14,right:14),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              item["asset"],
                              style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500)
                          )
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "适投值",
                              style: TextStyle(fontSize: 14)
                          ),

                          Text(
                              Decimal.parse(item["fit_value_abs"].toString()).toString(),
                              style: TextStyle(fontSize: 14,color:item["fit_value_color"])
                          )
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "流动性",
                              style: TextStyle(fontSize: 14)
                          ),

                          Text(
                              Decimal.parse(item["fluidity_abs"].toString()).toString(),
                              style: TextStyle(fontSize: 14,color:item["fluidity_color"])
                          )
                        ])),
                // Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                //     child:Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //               "买卖价差",
                //               style: TextStyle(fontSize: 11,color:Colors.grey)
                //           ),
                //           Text(
                //               Decimal.parse(item["ask_bid_price_change"].toString()).toString()+"%",
                //               style: TextStyle(fontSize: 11,color:Colors.grey)
                //           ),
                //         ])),
                // Padding(padding: EdgeInsets.only(left:14,top:2,right:14,bottom:0),
                //     child:Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //               "价格弹性",
                //               style: TextStyle(fontSize: 11,color:Colors.grey)
                //           ),
                //
                //           Text(
                //               Decimal.parse(item["price_elastic"].toString()).toString()+"%",
                //               style: TextStyle(fontSize: 11,color:Colors.grey)
                //           )
                //         ])),
                // Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                //     child:Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //               "价格深度",
                //               style: TextStyle(fontSize: 11,color:Colors.grey)
                //           ),
                //
                //           Text(
                //               Decimal.parse(item["price_depth_change"].toString()).toString()+"%",
                //               style: TextStyle(fontSize: 11,color:Colors.grey)
                //           )
                //         ])),
                Padding(padding: EdgeInsets.only(left:14,top:2,right:14,bottom:0),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "买卖深度差",
                              style: TextStyle(fontSize: 11,color:Colors.grey)
                          ),
                          Text(
                              Decimal.parse(item["order_depth_change"].toString()).toString()+"%",
                              style: TextStyle(fontSize: 11,color:Colors.grey)
                          )
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "价格变化",
                              style: TextStyle(fontSize: 14)
                          ),
                          Text(
                              Decimal.parse(item["priceChangePercent"].toString()).toString()+"%",
                              style: TextStyle(fontSize: 14,color:item["priceChangePercent_color"])
                          )
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14,bottom:0),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "成交超线",
                              style: TextStyle(fontSize: 14)
                          ),
                          Text(
                              Decimal.parse(item["volume_up_change"].toString()).toString()+"%",
                              style: TextStyle(fontSize: 14,color:item["volume_up_color"])
                          ),
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14,bottom:0),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "最近价格",
                              style: TextStyle(fontSize: 14)
                          ),
                          Text(
                              Decimal.parse(item["cur_price"].toString()).toString(),
                              style: TextStyle(fontSize: 14)
                          )
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:2,right:14,bottom:0),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "收盘时间",
                              style: TextStyle(fontSize: 11,color:Colors.grey)
                          ),
                          Text(
                              item["cur_price_time"].toString(),
                              style: TextStyle(fontSize: 11,color:Colors.grey)
                          )
                        ])),
                buildPredictDisabledWidget(item),
                buildPredictWidget(index,0),
                buildPredictChangeWidget(index),
                buildPredictWidget(index,1),
                buildPredictWidget(index,2),
                buildPredictWidget(index,3),
                // buildPredictWidget(index,4),
                // buildPredictWidget(index,5),
                // buildPredictWidget(index,6),
                SizedBox(height:14)
              ]
          )

      ),
      onTap: (){
        setState(() {
          if(item["is_predict"] != 1){
            Navigator.push(context, MaterialPageRoute(builder: (content){return AssetMarketSettingPage(asset: item["asset"]);}));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (content){return AssetPredictPage(asset: item["asset"], interval:"1m");}));
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

            appBar: AppBar(
              // title: const Text('交易',style:TextStyle(color: Color(0xff323232),fontSize: 17)),
              title: const Text('分析',style:TextStyle(color: Colors.white,fontSize: 17)),
              backgroundColor:Color(0xff48ABFD),
              elevation: 0  ,
              actions: [
                IconButton(
                    icon: Icon(Icons.info_outline_rounded,size: 22,color: Colors.white),
                    onPressed: () {
                      showSimpleNotification(
                          Text("成交量评估基线: "+volume_base+"USDT"),
                          subtitle:Text("深度: "+depth.toString()),
                          duration: Duration(seconds: 3,milliseconds: 500),
                          leading: Icon(Icons.info_outline_rounded,color:Colors.white),
                          background: Color(0xff48ABFD));
                    }
                )
              ],
            ),
            body:
            RefreshIndicator(

            onRefresh: () async {

              listCount = 0;
              datas.clear();
              getFitValues();


            },
            child:
            ListView.builder(
                itemCount: listCount,
                itemBuilder: (BuildContext context,int index) {
                        return buildFitValueDetail(index);


                    })

            )

    );
  }
}



