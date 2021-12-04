import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';



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

          // if(item["fluidity_abs"] < 100){
          //   item["fluidity_color"] = Color(0xffE95555);
          // }else{
          //   item["fluidity_color"] = Color(0xff02AC8F);
          // }
          //
          // if(item["volume_up_change"] < 100){
          //   item["volume_up_color"] = Color(0xffE95555);
          // }else{
          //   item["volume_up_color"] = Color(0xff02AC8F);
          // }
          //
          // if(Decimal.parse(item["ticker"]["priceChangePercent"].toString()).abs() < Decimal.parse("1")){
          //   item["priceChangePercent_color"] = Color(0xffE95555);
          // }else{
          //   item["priceChangePercent_color"] = Color(0xff02AC8F);
          // }


            // item["status_str_color"] = Color(0xffE95555);
            // item["status_str_color"] = Color(0xff02AC8F);
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

  //build asset summary
  Widget buildFitValueDetail(index){

    var item  = datas[index];

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
                          // Card(
                          //     color: item["type_color"],
                          //     elevation: 0,
                          //     margin: EdgeInsets.only(top: 0.0,bottom: 0.0,left: 10.0,right: 0.0),
                          //     child:
                          //     Padding(
                          //         padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                          //         child:Text(
                          //             item["side"],
                          //             style: TextStyle(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.w500)
                          //         )
                          //     )),
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
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "买卖价差",
                              style: TextStyle(fontSize: 11,color:Colors.grey)
                          ),
                          Text(
                              Decimal.parse(item["ask_bid_price_change"].toString()).toString()+"%",
                              style: TextStyle(fontSize: 11,color:Colors.grey)
                          ),
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14,bottom:0),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "价格弹性",
                              style: TextStyle(fontSize: 11,color:Colors.grey)
                          ),

                          Text(
                              Decimal.parse(item["price_elastic"].toString()).toString()+"%",
                              style: TextStyle(fontSize: 11,color:Colors.grey)
                          )
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "价格深度",
                              style: TextStyle(fontSize: 11,color:Colors.grey)
                          ),

                          Text(
                              Decimal.parse(item["price_depth_change"].toString()).toString()+"%",
                              style: TextStyle(fontSize: 11,color:Colors.grey)
                          )
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14,bottom:0),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "挂单深度",
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
                              Decimal.parse(item["ticker"]["priceChangePercent"].toString()).toString()+"%",
                              style: TextStyle(fontSize: 14,color:item["priceChangePercent_color"])
                          )
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14,bottom:14),
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
                          )
                        ])),


                // Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                //     child:Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //               "流动方向",
                //               style: TextStyle(fontSize: 13.5)
                //           ),
                //
                //           Text(
                //               item["fluidity_desc"].toString(),
                //               style: TextStyle(fontSize: 13.5)
                //           )
                //         ])),

                // Padding(padding: EdgeInsets.only(left:14,top:8,right:14,bottom:14),
                //     child:Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //               "深度含义",
                //               style: TextStyle(fontSize: 13.5)
                //           ),
                //
                //           Text(
                //              item["price_depth_desc"]+" "+item["order_depth_desc"],
                //               style: TextStyle(fontSize: 13.5)
                //           )
                //         ])),
              ]
          )

      ),
      onTap: (){
        setState(() {
          // Navigator.push(context, MaterialPageRoute(builder: (content){return AssetSettingPage(asset : item["asset"]);}));
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
                          Text("成交量基线: "+volume_base+" usdt"),
                          subtitle:Text("深度: "+depth.toString()),
                          duration: Duration(seconds: 5,milliseconds: 0),
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

                        // return Padding(padding: EdgeInsets.only(left:14,top:14,right:14),
                        //     child:Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //               "相关数值根据最近24小时价格及深度数据计算",
                        //               style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        //           )
                        //         ]));

                        return buildFitValueDetail(index);


                    })

            )

    );
  }
}



