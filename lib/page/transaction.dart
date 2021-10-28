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
            item["type"] = "限价卖出";
            item["price"] = item["price"].toString()+" USDT";

          }else if(item["type"] == "MARKET"){
            item["type"] = "市价卖出";
            item["price"] = "市场最新价";
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
                                    "交易对",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    item["symbol"]+"/USDT",
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
                                    "类型",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    item["type"],
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
                                      "数量",
                                      style: TextStyle(fontSize: 15.0)
                                  ),
                                  Text(
                                      item["origQty"].toString(),
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
                                      "价格",
                                      style: TextStyle(fontSize: 15.0)
                                  ),
                                  Text(
                                      item["price"].toString(),
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
                                    "订单状态",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    item["status_str"].toString(),
                                    style: TextStyle(fontSize: 15.0)
                                )
                              ])
                      )),
                  Expanded(
                      child:(
                          Column(
                              children: [
                                Text(
                                    "下单时间",
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                Text(
                                    item["update_time_sr"],
                                    style: TextStyle(fontSize: 15.0)
                                )
                              ])
                      )),
                ],

              ),
              SizedBox(height: 10),
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
              title: const Text('交易'),
              backgroundColor: Colors.teal,
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



