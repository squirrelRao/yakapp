import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';

import 'asset_setting.dart';
import 'common_setting.dart';

class AssetsPage extends StatefulWidget{


  @override
  State createState() => AssetsState();
}

class AssetsState extends State<AssetsPage>{

  late Map datas;
  int listCount = 0;
  var upate_time = "";

  void getUserAssets() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if(uid == ""){
      return;
    }

    ((NetClient()).post(Configs.getAssetsApi, {"user_id":uid}, (data){


              if(data["rc"] == 0) {

                // upate_time = data["data"]["update_time_desc"];
                upate_time = "";

                listCount = data["data"]["snapshots"].length + 1;
                datas = data["data"];

                for(var item in datas["snapshots"]){

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


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> getUserAssets());


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
                        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                        child:Column(

                            children: [
                              Text(
                                  "总资产("+datas["price_unit"]+")",
                                  style: TextStyle(fontSize: 16.0,color: Color(0xfff3f3f3))
                              ),
                              SizedBox(height: 10),

                              Text(
                                  datas["accumulates_free"].toString(),
                                  style: TextStyle(fontSize: 25.0,color: Colors.white,fontWeight: FontWeight.w500)
                              )
                            ]
                    )),
            Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child:Row(
                    children: [
                  Expanded(
                      child:(
                          Column(
                              children: [
                                Text(
                                    "收益周期(天)",
                                    style: TextStyle(fontSize: 13.0,color: Color(0xfff3f3f3))
                                ),
                                SizedBox(height: 10),
                                Text(
                                    datas["ror_duration"].toString(),
                                    style: TextStyle(fontSize: 16.0,color: Colors.white,fontWeight: FontWeight.w500)
                                )
                              ])
                      )),
                  Expanded(
                      child:(
                          Column(
                              children: [
                                Text(
                                    "收益("+datas["price_unit"]+")",
                                    style: TextStyle(fontSize: 13.0,color: Color(0xfff3f3f3))
                                ),
                                SizedBox(height: 10),
                                Text(
                                    datas["accumulates_return"].toString(),
                                    style: TextStyle(fontSize: 16.0,color: Colors.white,fontWeight: FontWeight.w500)
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
                                SizedBox(height: 10),
                                Text(
                                    datas["accumulates_ror"].toString()+"%",
                                    style: TextStyle(fontSize: 16.0,color: Colors.white,fontWeight: FontWeight.w500)
                                ),


                              ])
                      )),

                ]

            )),
            Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 40),
                child:Row(
                children: [
                  Expanded(
                      child:(
                          Column(
                              children: [
                                Text(
                                    "目标收益达成: "+datas["ror_touch"],
                                    style: TextStyle(fontSize: 11.0,color: Color(0xfff3f3f3))
                                ),
                              ])
                      )),
                  Expanded(
                      child:(
                          Column(
                              children: [
                                Text(
                                    "最低收益达成: "+ datas["l_ror_touch"],
                                    style: TextStyle(fontSize: 11.0,color: Color(0xfff3f3f3))
                                )
                              ])
                      )),
                ]

            )),
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
                          Padding(padding: EdgeInsets.only(left:14,top:10,right:14),
                          child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    item["asset"],
                                    style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500)
                                ),

                                Text(
                                    item["free"],
                                    style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500)
                                )
                              ])),
              Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "收益",
                            style: TextStyle(fontSize: 15.0)
                        ),

                        Text(
                            item["return"].toString(),
                            style: TextStyle(fontSize: 15.0,color:item["return_color"])
                        )
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "当前收益率",
                            style: TextStyle(fontSize: 15.0)
                        ),

                        Text(
                            item["ror"].toString()+"%",
                            style: TextStyle(fontSize: 15.0,color:item["ror_color"])
                        )
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "目标收益率",
                            style: TextStyle(fontSize: 15.0)
                        ),
                        Text(
                            item["target_ror"].toString()+"%",
                            style: TextStyle(fontSize: 15.0)
                        ),
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:2,right:14,bottom:0),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "达成自动卖出",
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        ),

                        Text(
                            item["t_sell"].toString()+"%",
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        )
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:8,right:14,bottom: 0),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "最低收益率",
                            style: TextStyle(fontSize: 15.0)
                        ),

                        Text(
                            item["lowest_ror"].toString()+"%",
                            style: TextStyle(fontSize: 15.0)
                        )
                      ])),
              Padding(padding: EdgeInsets.only(left:14,top:2,right:14,bottom:20),
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "达成自动卖出",
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        ),

                        Text(
                            item["l_sell"].toString()+"%",
                            style: TextStyle(fontSize: 11.0,color:Colors.grey)
                        )
                      ])),
            ]
        )

    ),
      onTap: (){
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (content){return AssetSettingPage(asset : item["asset"]);}));
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
                Padding(padding: EdgeInsets.only(left:14,top:12,right:14,bottom:16),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              item["asset"],
                              style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500)
                          ),

                          Text(
                              item["free"],
                              style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500)
                          )
                        ]))
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
              title: const Text('资产',style:TextStyle(color:Colors.white)),
              backgroundColor:Color(0xff48ABFD),
              elevation: 0,
              actions: [
                // Center(
                 Container(
                  child:  Text(upate_time,style: TextStyle(fontSize: 13)),
                  padding: const EdgeInsets.fromLTRB(0,0,5,10.0),
                  alignment: Alignment.bottomCenter,
               // )
                )
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
                              margin: EdgeInsets.only(top:180),
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



