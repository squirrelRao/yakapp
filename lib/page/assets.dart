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

  void getUserAssets() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if(uid == ""){
      return;
    }

    ((NetClient()).post(Configs.getAssetsApi, {"user_id":uid}, (data){


              if(data["rc"] == 0) {
                listCount = data["data"]["snapshots"].length + 1;
                datas = data["data"];
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

    if(datas["ror_touch"] == "auto"){
      datas["ror_touch"] = "自动卖出";
    }else if(datas["ror_touch"] == "notify"){
      datas["ror_touch"] = "发送提醒";
    }else{
      datas["ror_touch"] = "不执行";
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
                                  "总资产",
                                  style: TextStyle(fontSize: 15.0)
                              ),
                              Text(
                                  datas["accumulates_free"].toString()+" "+datas["price_unit"],
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
                                  "收益周期",
                                  style: TextStyle(fontSize: 15.0)
                              ),
                              Text(
                                  datas["ror_duration"].toString()+"天",
                                  style: TextStyle(fontSize: 15.0)
                              )
                            ])
                    ))
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
                                    "累计收益",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    datas["accumulates_return"].toString()+" "+datas["price_unit"],
                                    style: TextStyle(fontSize: 15.0)
                                )
                              ])
                      )),
                  Expanded(
                      child:(
                          Column(
                              children: [
                                Text(
                                    "累计收益率",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    datas["accumulates_ror"].toString()+"%",
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
                                    "盈损智能",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    datas["ror_touch"],
                                    style: TextStyle(fontSize: 15.0)
                                )
                              ])
                      )),
                  Expanded(
                      child:(
                          Column(
                              children: [
                                Text(
                                    "更新时间",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    datas["update_time_str"],
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
                                      item["return"].toString()+"%",
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
              title: const Text('资产'),
              backgroundColor: Colors.teal,
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



