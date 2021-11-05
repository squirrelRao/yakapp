import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/create_pre_order.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';

class NoticePage extends StatefulWidget{


  @override
  State createState() => NoticeState();
}

class NoticeState extends State<NoticePage>{

  List datas = [];
  int listCount = 0;

  void getNotices() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    ((NetClient()).post(Configs.getNoticeApi, {"user_id":userId}, (data){


      if(data["rc"] == 0) {
        listCount = data["data"].length;
        datas = data["data"];

        for(var i in datas){
          i["pre_order_status"] = i["pre_order_status"] == 0 ? "未预购" : "已预购";
          var symbols = "";
          for(var item in i["symbols"]){
            if(item.toString().contains("USDT")){
              i["asset"] = item.toString().replaceAll("/USDT", "");
            }
            symbols += item+",";
          }

          if(symbols.length > 1  && symbols.contains(",")){
            symbols = symbols.substring(0,symbols.length-1);
          }
          i["symbols"] = symbols;
        }

      }


              setState(() {

              });
    }));

  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> getNotices());


  }

  //build asset summary
  Widget buildNotice(index){

    var item  = datas[index];


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
                                    "新币信息",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    item["title"],
                                    style: TextStyle(fontSize: 15.0)
                                )
                              ])
                      )
              )
                ]),
              SizedBox(height: 10),
              Row(
                  children: [
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                      "上线时间",
                                      style: TextStyle(fontSize: 15.0)
                                  ),
                                  Text(
                                      item["open_time"].toString(),
                                      style: TextStyle(fontSize: 15.0)
                                  )
                                ])
                        ))

              ]),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child:(
                          Column(
                              children: [
                                Text(
                                    "支持交易对",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    item["symbols"].toString(),
                                    style: TextStyle(fontSize: 15.0)
                                )
                              ])
                      ))
              ]),
              SizedBox(height: 10),
              Row(
                  children: [
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                      "预购订单",
                                      style: TextStyle(fontSize: 15.0)
                                  ),
                                  Text(
                                      item["pre_order_status"].toString(),
                                      style: TextStyle(fontSize: 15.0)
                                  )
                                ])
                        ))
                  ]),
              SizedBox(height: 10),

            ]
        )


    ),
      onTap: (){
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (content){return CreatePreOrderPage(asset : item["asset"], open_time: item["open_time"]);}));
          });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

            appBar: AppBar(
              title: const Text('新币'),
              backgroundColor: Colors.teal,
            ),
            body:
            RefreshIndicator(

            onRefresh: () async {

              listCount = 0;
              datas.clear();
              getNotices();

            },
            child:ListView.builder(
                itemCount: listCount,
                itemBuilder: (BuildContext context,int index) {

                      return buildNotice(index);

                    }



            )
            )

    );
  }
}



