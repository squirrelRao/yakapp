
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/asset_market_setting.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';


import 'asset_predict_detail.dart';


class AssetPredictPage extends StatefulWidget{

  AssetPredictPage({required this.asset, required this.interval});

  var asset;
  var interval;

  @override
  State createState()  => AssetPredictState(asset: asset, interval: interval);
}

class AssetPredictState extends State<AssetPredictPage> with SingleTickerProviderStateMixin{

  AssetPredictState({required this.asset, required this.interval});

  var asset;
  var interval;
  late TabController tabController;

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }


  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3,initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar:AppBar(
          title: Text(asset+"价格预测",style:TextStyle(color: Color(0xff323232),fontSize: 17)),
          backgroundColor: Colors.white70,
          elevation: 0,
          centerTitle: true,
          actions: [IconButton(
              icon: Icon(Icons.segment,size: 24,color: Color(0xff323232),),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (content){return AssetMarketSettingPage(asset: asset);}));
              })],
          bottom:
            TabBar(
            controller: tabController,
            isScrollable: false,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Color(0xff333333),
            labelStyle: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w700
            ),
            unselectedLabelColor: Color(0xff999999),
            unselectedLabelStyle: TextStyle(
              fontSize: 12.0,
            ),
            indicatorColor: Color(0xff48ABFD),
            tabs: [
              Tab(
                text: "逐分钟",
              ),
              Tab(
                text: "逐小时",
              ),
              Tab(
                text: "逐天",
              ),
            ],
            // add it here
            indicator: DotIndicator(
              color: Color(0xff48ABFD),
              distanceFromCenter: 14,
              radius: 3.5,
              paintingStyle: PaintingStyle.fill,
            ),
          ),
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

      body:new TabBarView(
        controller: tabController,
        children:  <Widget>[
          AssetPredictDetailPage(asset: asset, interval: "1m"),
          AssetPredictDetailPage(asset: asset, interval: "1h"),
          AssetPredictDetailPage(asset: asset, interval: "1d"),
        ],
      )

    );
  }


}