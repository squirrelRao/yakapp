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

    var top_margin = 10.0;
    if(index == 0){
      top_margin = 24.0;
    }
    Widget card = GestureDetector(
        child:Card(
        elevation: 1,
        margin: EdgeInsets.only(top: top_margin,left:25,right: 25),
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
        color: Colors.white,
        child:Column(
            children: [
              Padding( padding: EdgeInsets.only(left:10,top:10),
              child:
              Row(
                  children: [
                          Icon(Icons.info_outlined,color:Color(0xff48ABFD)
                          ),
                          Text(
                              "新币信息",
                              style: TextStyle(fontSize: 15.0)
                          )
                  ])),

              Padding( padding: EdgeInsets.only(left:30,top:5),
               child:Row(
                children: [
                                Text(
                                    item["title"],
                                    style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500)
                                )
                              ])
                ),
            Padding( padding: EdgeInsets.only(left:30,top:15,right:10),
              child:Row(
                  children: [
                                  Expanded(
                                  child:Text(
                                      "交易对:"+item["symbols"].toString(),
                                      maxLines:2,
                                      style: TextStyle(fontSize: 14.0)
                                  ))
                                ])

              ),
            Padding( padding: EdgeInsets.only(left:30,top:15),
            child:Row(
                  children: [
                            Column(
                                children: [
                                  Text(
                                      item["open_time"],
                                      style: TextStyle(fontSize: 13.0)
                                  ),
                                  Text(
                                      "上线时间",
                                      style: TextStyle(fontSize: 11.0)
                                  )
                                ]),
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                    item["pre_order_status"].toString(),
                                      style: TextStyle(fontSize: 13.0)
                                  ),
                                  Text(
                                      "预购",
                                      style: TextStyle(fontSize: 11.0)
                                  )
                                ])
                        ))
                  ])),
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
              title: const Text('新币',style:TextStyle(color:Colors.white)),
              backgroundColor: Color(0xff48ABFD),
              elevation: 0,
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



