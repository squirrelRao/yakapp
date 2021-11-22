import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';

import 'asset_setting.dart';
import 'common_setting.dart';
import 'package:decimal/decimal.dart';


class AssetsPage extends StatefulWidget{


  @override
  State createState() => AssetsState();
}

class AssetsState extends State<AssetsPage>{

  late Map datas;
  int listCount = 0;
  var upate_time = "";
  var _timer;

  void getUserAssets() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if(uid == ""){
      return;
    }

    ((NetClient()).post(Configs.getAssetsApi, {"user_id":uid}, (data){


              if(data["rc"] == 0) {

                // upate_time = data["data"]["update_time_desc"];
                upate_time = upate_time = data["data"]["update_time_str"];

                listCount = data["data"]["snapshots"].length + 1;
                datas = data["data"];

                for(var item in datas["snapshots"]){

                  if(item["price"]<0){
                    item["price"] = 0;
                  }
                  if(item["ror"] < 0){
                    item["ror_color"] = Color(0xffE95555);
                  }else{
                    item["ror_color"] = Color(0xff02AC8F);
                  }

                  if(item["return"] < 0){
                    item["return_color"] = Color(0xffE95555);
                  }else{
                    item["return_color"] = Color(0xff02AC8F);
                  }

                  if(item["price_change"] < 0){
                    item["price_change_color"] = Color(0xffE95555);
                  }else{
                    item["price_change_color"] = Color(0xff02AC8F);
                  }
                }

                if(datas["ror_touch"] == "auto_limit"){
                  datas["ror_touch"] = "限价卖出";
                }else if(datas["ror_touch"] == "auto_market") {
                  datas["ror_touch"] = "市价卖出";
                }else if(datas["ror_touch"] == "notify"){
                  datas["ror_touch"] = "发送提醒";
                }else{
                  datas["ror_touch"] = "不执行";
                }

                if(datas["l_ror_touch"] == "auto_limit"){
                  datas["l_ror_touch"] = "限价卖出";
                } else if(datas["l_ror_touch"] == "auto_market"){
                  datas["l_ror_touch"] = "市价卖出";
                }else if(datas["l_ror_touch"] == "notify"){
                  datas["l_ror_touch"] = "发送提醒";
                }else{
                  datas["l_ror_touch"] = "不执行";
                }

              }

              setState(() {});
    }));

  }

  void RefreshDataPeriodic(){
    _timer = Timer.periodic(Duration(seconds: 2), (timestamp)=>getUserAssets());
    getUserAssets();
}

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timestamp) => RefreshDataPeriodic());
  }

  @override
  void dispose(){

    super.dispose();
    _timer.cancel();
  }

  //build asset summary
  Widget buildAssetSummary(){


    return GestureDetector(

      child:Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight:Radius.zero ,
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0))),
        elevation: 0,
        margin: const EdgeInsets.all(0.0),
        color: Color(0xff48ABFD),
        child:Column(
            children: [
                        Container(
                        margin: EdgeInsets.fromLTRB(16, 10, 16, 0),
                        child:Column(

                            children: [
                              Text(
                                  "总额(USDT)",
                                  style: TextStyle(fontSize: 13.0,color: Color(0xfff3f3f3))
                              ),
                              SizedBox(height: 8),
                              Text(
                                  Decimal.parse(datas["accumulates_free"].toString()).toString(),
                                  style: TextStyle(fontSize: 27.0,color: Colors.white,fontWeight: FontWeight.w500)
                              )
                            ]
                    )),
            Container(
                margin: EdgeInsets.fromLTRB(6, 20, 6, 0),
                child:Row(
                    children: [
                  Expanded(
                      child:(
                          Column(
                              children: [
                                Text(
                                    "环比周期(天)",
                                    style: TextStyle(fontSize: 13.0,color: Color(0xfff3f3f3))
                                ),
                                SizedBox(height: 8),
                                Text(
                                    datas["ror_duration"].toString(),
                                    style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.w500)
                                )
                              ])
                      )),
                  Expanded(
                      child:(
                          Column(
                              children: [
                                Text(
                                    "收益(USDT)",
                                    style: TextStyle(fontSize: 13.0,color: Color(0xfff3f3f3))
                                ),
                                SizedBox(height: 8),
                                Text(
                                    Decimal.parse(datas["accumulates_return"].toString()).toString(),
                                    style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.w500)
                                ),
                              ])
                      )),
                  Expanded(
                      child:(
                          Column(
                              children: [
                                Text(
                                    "收益率",
                                    style: TextStyle(fontSize: 13.0,color: Color(0xfff3f3f3))
                                ),
                                SizedBox(height: 8),
                                Text(
    Decimal.parse(datas["accumulates_ror"].toString()).toString()+"%",
                                    style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.w500)
                                ),


                              ])
                      )),

                ]

            )),
            Container(
                margin: EdgeInsets.fromLTRB(6, 20, 6, 40),
                child:
                    Padding(
                      padding: EdgeInsets.only(left:33.5,right:33.5),
                    child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                                Text(
                                    "估值(CNY): "+ Decimal.parse(datas["accumulates_free_cny"].toString()).toString(),
                                    style: TextStyle(fontSize: 11.0,color: Color(0xfff3f3f3))
                                ),

                                Text(
                                    "智能辅助: "+ datas["smart"],
                                    style: TextStyle(fontSize: 11.0,color: Color(0xfff3f3f3))
                                )
                            ]

            ))),
          ]
        )


    ),
    onTap: (){
      setState(() {
        Navigator.push(context, MaterialPageRoute(builder: (content){return CommonSettingPage();}));
      });
    },
    );
  }

  //build asset summary
  Widget buildAssetDetail(index){

    var item  = datas["snapshots"][index];
    if(item["ror"]==-0.0){
      item["ror"] = 0.0;
    }

    if(item["asset"] == 'USDT'){
      return SizedBox();
    }

    return GestureDetector(
        child:Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
        elevation: 1.5,
        margin: const EdgeInsets.only(left:20,right:20,top:12),
        color: Colors.white,
        child:Column(
            children: [
                          Padding(padding: EdgeInsets.only(left:14,top:14,right:14),
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    item["asset"],
                                    style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500)
                                ),

                                Text(
                                    Decimal.parse(item["free"].toString()).toString(),
                                    style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w400)
                                )
                              ])),
              Padding(padding: EdgeInsets.only(left:14,top:2,right:14,bottom:0),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "估值(CNY)",
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        ),

                        Text(
                            Decimal.parse(item["cny_value"].toString()).toString(),
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        )
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "价格",
                            style: TextStyle(fontSize: 14.0)
                        ),

                        Text(
                            Decimal.parse(item["price"].toString()).toString(),
                            style: TextStyle(fontSize: 14.0)
                        )
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:2,right:14,bottom:0),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "环比",
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        ),

                        Text(
                            Decimal.parse(item["capital_price"].toString()).toString(),
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        )
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "收益",
                            style: TextStyle(fontSize: 14.0)
                        ),

                        Text(
                            Decimal.parse(item["return"].toString()).toString(),
                            style: TextStyle(fontSize: 14.0,color:item["return_color"])
                        )
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "收益率",
                            style: TextStyle(fontSize: 14.0)
                        ),

                        Text(
                            Decimal.parse(item["ror"].toString()).toString()+"%",
                            style: TextStyle(fontSize: 14.0,color:item["ror_color"])
                        )
                      ])),

              Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "价格涨幅",
                            style: TextStyle(fontSize: 14.0)
                        ),

                        Text(
                            Decimal.parse(item["price_change"].toString()).toString()+"%",
                            style: TextStyle(fontSize: 14.0,color:item["price_change_color"])
                        )
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "目标涨幅",
                            style: TextStyle(fontSize: 12.0)
                        ),
                        Text(
                            Decimal.parse(item["target_ror"].toString()).toString()+"%",
                            style: TextStyle(fontSize: 12.0)
                        ),
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:2,right:14,bottom:0),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "达成卖出("+item["asset"]+")",
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        ),

                        Text(
                            Decimal.parse(item["t_sell"].toString()).toString(),
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        )
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "加仓涨幅",
                            style: TextStyle(fontSize: 12.0)
                        ),
                        Text(
                            Decimal.parse(item["lowest_ror"].toString()).toString()+"%",
                            style: TextStyle(fontSize: 12.0)
                        ),
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:2,right:14,bottom:14),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "达成加仓("+item["asset"]+")",
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        ),

                        Text(
                            Decimal.parse(item["l_buy"].toString()).toString(),
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        )
                      ])),

            ]
        )

    ),
      onTap: (){
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (content){return AssetSettingPage(asset : item["asset"], price: item["price"],compare_price: item["capital_price"],free: double.parse(item["free"]), ror : item["price_change"],free_usdt:double.parse(datas["snapshots"][0]["free"]));}));
          });
      },
    );
  }

  //build asset summary
  Widget buildUSDTDetail(index){

    var item  = datas["snapshots"][index];
    if(item["ror"]==-0.0){
      item["ror"] = 0.0;
    }

    return GestureDetector(
      child:Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
          elevation: 1.5,
          margin: const EdgeInsets.only(left:20,right:20,top:12),
          color: Colors.white,
          child:Column(
              children: [
                Padding(padding: EdgeInsets.only(left:14,top:14,right:14,bottom:0),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              item["asset"],
                              style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500)
                          ),

                          Text(
                              Decimal.parse(item["free"].toString()).toString(),
                              style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w400)
                          )
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:2,right:14,bottom:12),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "估值(CNY)",
                              style: TextStyle(fontSize: 11.0,color:Colors.grey)
                          ),

                          Text(
                              Decimal.parse(item["cny_value"].toString()).toString(),
                              style: TextStyle(fontSize: 11.0,color:Colors.grey)
                          )
                        ])),
              ]
          )

      ),
      onTap: (){
        setState(() {
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

            appBar: AppBar(
              title: const Text('资产',style:TextStyle(color:Colors.white,fontSize:17)),
              backgroundColor:Color(0xff48ABFD),
              elevation: 0,

              actions: [
                // Center(
                //  Container(
                //   child:  Text(upate_time,style: TextStyle(fontSize: 13)),
                //   padding: const EdgeInsets.fromLTRB(0,0,5,10.0),
                //   alignment: Alignment.bottomCenter,
               // )
               // )
              ],
            ),
            body:
            RefreshIndicator(

            onRefresh: () async {

              listCount = 0;
              datas.clear();
              getUserAssets();


            },
            child:ListView.builder(
                    itemCount: listCount,
                    itemBuilder: (BuildContext context,int index) {

                      if(index == 0){

                        return Stack(

                          children:[
                            Container(
                            height:200,
                            child:buildAssetSummary()),
                            Container(
                              margin: EdgeInsets.only(top:174),
                              decoration:BoxDecoration(
                                color: Colors.white,
                              borderRadius: BorderRadius.horizontal(left: Radius.circular(16)
                              ,right:Radius.circular(16)),
                              ),
                              child:buildUSDTDetail(index)
                            )
                          ]

                        );

                      }else{

                        return buildAssetDetail(index-1);

                     }
                    }

      ))




    );
  }
}



