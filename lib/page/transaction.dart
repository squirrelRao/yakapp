import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';


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
          if(item["side"] == "BUY"){
            item["side"] = "买入";
            item["price"] = "市场最新价";
            item["type_color"] = Color(0xff48ABFD);

          }else if(item["side"] == "SELL"){
            item["side"] = "卖出";
            if(item["type"] == "MARKET") {
              item["price"] = "市场最新价";
            }else{
              item["price"] = item["price"].toString();
            }
            item["type_color"] = Color(0xff48ABFD);

          }

          item["origQty"] = item["origQty"].toString();
          item["status_prefix"] = "";
          if(item["status"] == "FAILED"){
            item["status_str"] = "失败("+item["status_str"]+")";
            item["status_str_color"] = Color(0xffE95555);
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
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          elevation: 1.5,
          margin: const EdgeInsets.only(left:28,right:28,top:12),
          color: Colors.white,
          child:Column(
              children: [
                Padding(padding: EdgeInsets.only(left:14,top:14,right:14),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              item["symbol"],
                              style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500)
                          ),
                          Card(
                              color: item["type_color"],
                              elevation: 0,
                              margin: EdgeInsets.only(top: 0.0,bottom: 0.0,left: 10.0,right: 0.0),
                              child:
                              Padding(
                                  padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                                  child:Text(
                                      item["side"],
                                      style: TextStyle(fontSize: 12.0,color: Colors.white,fontWeight: FontWeight.w500)
                                  )
                              )),
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "数量",
                              style: TextStyle(fontSize: 13.0)
                          ),

                          Text(
                              item["origQty"].toString(),
                              style: TextStyle(fontSize: 13.0)
                          )
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "价格(usdt)",
                              style: TextStyle(fontSize: 13.0)
                          ),

                          Text(
                              item["price"].toString(),
                              style: TextStyle(fontSize: 13.0)
                          )
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "状态",
                              style: TextStyle(fontSize: 13.0)
                          ),
                          Text(
                              item["status_str"].toString(),
                              style: TextStyle(fontSize: 13.0,color:item["status_str_color"])
                          ),
                        ])),
                Padding(padding: EdgeInsets.only(left:14,top:8,right:14,bottom:14),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "时间",
                              style: TextStyle(fontSize: 13.0)
                          ),

                          Text(
                              item["update_time_sr"].toString(),
                              style: TextStyle(fontSize: 13.0)
                          )
                        ]))
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
              // title: const Text('交易',style:TextStyle(color: Color(0xff323232),fontSize: 17)),
              title: const Text('交易',style:TextStyle(color: Colors.white,fontSize: 17)),
              backgroundColor:Color(0xff48ABFD),
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



