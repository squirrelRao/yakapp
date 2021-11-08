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

                upate_time = "数据时间:"+data["data"]["update_time_str"];
                listCount = data["data"]["snapshots"].length + 1;
                datas = data["data"];

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
        color: Color(0xd33094FE),
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

    return GestureDetector(
        child:Card(

        elevation: 1,
        margin: const EdgeInsets.all(4.0),
        color: Colors.white60,
        child:Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child:(
                          Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                    "币种",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    item["asset"],
                                    style: TextStyle(fontSize: 15.0)
                                )
                              ])
                      )),
                  Expanded(
                      child:(
                          Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                    "可用",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    item["free"].toString(),
                                    style: TextStyle(fontSize: 15.0)
                                )
                              ])
                      )),


                  Expanded(
                      child:(
                          Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                    "冻结",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    item["locked"].toString(),
                                    style: TextStyle(fontSize: 15.0)
                                )
                              ])
                      )),

                ],
              ),
              SizedBox(height: 10),
              Row(
                  children: [
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                      "累计收益率",
                                      style: TextStyle(fontSize: 15.0)
                                  ),
                                  Text(
                                      item["ror"].toString()+"%",
                                      style: TextStyle(fontSize: 15.0)
                                  )
                                ])
                        )),
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                      "目标收益率",
                                      style: TextStyle(fontSize: 15.0)
                                  ),
                                  Text(
                                      item["target_ror"].toString()+"%",
                                      style: TextStyle(fontSize: 15.0)
                                  )
                                ])
                        )),
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                      "止损收益率",
                                      style: TextStyle(fontSize: 15.0)
                                  ),
                                  Text(
                                      item["lowest_ror"].toString()+"%",
                                      style: TextStyle(fontSize: 15.0)
                                  )
                                ])
                        )),

                  ]

              ),
              SizedBox(height: 10),
              Row(
                  children: [
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                      "累计收益",
                                      style: TextStyle(fontSize: 15.0)
                                  ),
                                  Text(
                                      item["return"].toString(),
                                      style: TextStyle(fontSize: 15.0)
                                  )
                                ])
                        )),
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                      "目标达成卖出",
                                      style: TextStyle(fontSize: 15.0)
                                  ),
                                  Text(
                                      item["t_sell"].toString()+"%",
                                      style: TextStyle(fontSize: 15.0)
                                  )
                                ])
                        )),
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                      "止损触发卖出",
                                      style: TextStyle(fontSize: 15.0)
                                  ),
                                  Text(
                                      item["l_sell"].toString()+"%",
                                      style: TextStyle(fontSize: 15.0)
                                  )
                                ])
                        )),

                  ]

              ),
              SizedBox(height: 10),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

            appBar: AppBar(
              title: const Text('资产',style:TextStyle(color:Colors.white)),
              backgroundColor:Color(0xd33094FE),
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

                      return buildAssetSummary();


                    }else{

                      return buildAssetDetail(index-1);

                    }
            })
            )

    );
  }
}



