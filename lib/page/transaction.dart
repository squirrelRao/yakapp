import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';

class TransactionPage extends StatefulWidget{


  @override
  State createState() => TransactionState();
}

class TransactionState extends State<TransactionPage>{

  List datas = [];
  int listCount = 0;

  void getUserTransactions() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if(uid == ""){
      return;
    }

    ((NetClient()).post(Configs.getUserTransactionsApi, {"user_id":uid}, (data){



      if(data["rc"] == 0) {
        listCount = data["data"].length;
        datas = data["data"];

        for(var item in datas){

          item["symbol"] = item["symbol"].replaceAll("USDT","");
          if(item["type"] == "LIMIT"){
            item["type"] = "卖出";
            item["price"] = item["price"].toString()+" USDT";
            item["type_color"] = Colors.redAccent;

          }else if(item["type"] == "MARKET"){
            item["type"] = "卖出";
            item["price"] = "市场最新价";
            item["type_color"] = Colors.redAccent;

          }

          item["origQty"] = item["origQty"].toString()+" "+item["symbol"].replaceAll("USDT","");
          item["status_prefix"] = "";
          if(item["status"] == "FAILED"){
            item["status_str"] = "失败("+item["status_str"]+")";

          }
        }
      }


              setState(() {

              });
    }));

  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> getUserTransactions());


  }

  //build asset summary
  Widget buildTransactionDetail(index){

    var item  = datas[index];


    return GestureDetector(
        child:Card(

        elevation: 1,
        margin: const EdgeInsets.all(10.0),
        color: Colors.white,
        child:Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child:(
                          Row(
                              children: [
                                Card(
                                    color: item["type_color"],
                                    elevation: 0,
                                    margin: EdgeInsets.only(top: 0.0,bottom: 0.0,left: 10.0,right: 10.0),
                                child:
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                        child:Text(
                                    item["type"],
                                    style: TextStyle(fontSize: 12.0,color: Colors.white)
                                )
                                )),
                                Text(
                                    item["symbol"]+"/USDT",
                                    style: TextStyle(fontSize: 16.0)
                                )
                              ])
                      )),
                  Expanded(
                      child:(
                          Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                    "订单时间",
                                    style: TextStyle(fontSize: 13.0,color:Colors.grey)
                                ),
                                Text(
                                    item["update_time_sr"],
                                    style: TextStyle(fontSize: 16.0)
                                )
                              ])
                      )),
                ],
              ),
              SizedBox(height: 20),
              Divider(height: 1.0,indent: 10,endIndent: 10,color: Colors.grey),
              SizedBox(height: 20),
              Row(
                  children: [
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                      item["origQty"].toString(),
                                      style: TextStyle(fontSize: 16.0)
                                  ),
                                  Text(
                                      "数量",
                                      style: TextStyle(fontSize: 13.0)
                                  )
                                ])
                        )),
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                      item["price"].toString(),
                                      style: TextStyle(fontSize: 16.0)
                                  ),
                                  Text(
                                      "价格",
                                      style: TextStyle(fontSize: 13.0)
                                  )
                                ])
                        )),
                    Expanded(
                        child:(
                            Column(
                                children: [
                                  Text(
                                      item["status_str"].toString(),
                                      style: TextStyle(fontSize: 16.0)
                                  ),
                                  Text(
                                      "状态",
                                      style: TextStyle(fontSize: 13.0)
                                  )
                                ])
                        )),
                  ]

              ),
              SizedBox(height: 30),
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
              title: const Text('交易',style:TextStyle(color:Colors.black)),
              backgroundColor: Colors.white70,
              elevation: 0  ,
            ),
            body:
            RefreshIndicator(

            onRefresh: () async {

              listCount = 0;
              datas.clear();
              getUserTransactions();

            },
            child:ListView.builder(
                itemCount: listCount,
                itemBuilder: (BuildContext context,int index) {

                      return buildTransactionDetail(index);

                    }



            )
            )

    );
  }
}



