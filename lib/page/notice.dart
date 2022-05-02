import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/create_pre_order.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';

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

    var top_margin = 10.0;
    if(index == 0){
      top_margin = 30.0;
    }
    Widget card = GestureDetector(
        child:Card(
        elevation: 1,
        margin: EdgeInsets.only(top: top_margin,left:28,right: 28),
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
        color: Colors.white,
        child:Column(
            children: [
              Padding( padding: EdgeInsets.only(left:14,top:13),
              child:
              Row(
                  children: [
                            Image(
                            width:20,
                            height:20,
                            image: AssetImage("images/notice_icon.png"),
                          ),
                          SizedBox(width:8),
                          Text(
                              "新币信息",
                              style: TextStyle(fontSize: 15.0,color:Color(0xff999999))
                          )
                  ])),

              Padding( padding: EdgeInsets.only(left:44,top:6,right:12),
               child:Row(
                children: [
               Expanded(

               child:Text(
                                    item["title"],
                                    maxLines:2,
                                    style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500)
                                ))
                              ])
                ),
            Padding( padding: EdgeInsets.only(left:44,top:10,right:12),
              child:Row(
                  children: [
                                  Expanded(
                                  child:Text(
                                      "交易对:"+item["symbols"].toString(),
                                      maxLines:3,
                                      style: TextStyle(fontSize: 12.0,color:Color(0xff6D7580))
                                  ))
                                ])

              ),
            Padding( padding: EdgeInsets.only(left:44,top:12),
            child:Row(
                  children: [
                            Column(
                                children: [
                                  Text(
                                      item["open_time"],
                                      style: TextStyle(fontSize: 12.0,color:Color(0xff6D7580))
                                  ),
                                  Text(
                                      "上线时间",
                                      style: TextStyle(fontSize: 11.0,color:Color(0xff6C7682))
                                  )
                                ]),
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                    item["pre_order_status"].toString(),
                                      style: TextStyle(fontSize: 12.0,color:Color(0xff6D7580))
                                  ),
                                  Text(
                                      "预购",
                                      style: TextStyle(fontSize: 11.0,color:Color(0xff6C7682))
                                  )
                                ])
                        ))
                  ])),
              SizedBox(height: 14),

            ]
        )
        ),
      onTap: (){
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (content){return CreatePreOrderPage(asset : item["asset"], open_time: item["open_time"]);}));
          });
      },
    );


    if(index == 0){

      return Stack(
        children: [
          Positioned(
          child:Container(
            height: 70,
              decoration: BoxDecoration(
                color: Color(0xff48ABFD),
                  borderRadius:BorderRadius.only(bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14))
              )
             )),
             card
        ],
      );

    }else{

      return card;
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

            appBar: AppBar(
              title: const Text('新币',style:TextStyle(color:Colors.white,fontSize:17)),
              backgroundColor: Color(0xff48ABFD),
              elevation: 0,
                leading: IconButton(
                  icon:Image(
                    width:24,
                    height:24,
                    image: AssetImage("images/back.png"),
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  IconButton(
                      icon: Icon(Icons.wifi_tethering_rounded,size: 22,color: Colors.white),
                      onPressed: () {
                        showSimpleNotification(
                            Text("正在为您实时监测新币上市信息 ..."),
                            duration: Duration(seconds: 3,milliseconds: 600),
                            leading: Icon(Icons.wifi_tethering_rounded,color:Colors.white),
                            background: Color(0xff48ABFD));
                      }
                  )
                ]
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



