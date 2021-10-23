import 'package:flutter/material.dart';

class TransactionsPage extends StatefulWidget{


  @override
  State createState() => TransactionsState();
}

class TransactionsState extends State<TransactionsPage>{

   List<Widget> transactions = <Widget>[
     TransactionItem()
   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

            appBar: AppBar(
              title: const Text('交易记录'),
              backgroundColor: Colors.teal,

            ),
            body: ListView(
              scrollDirection: Axis.vertical,
              children: this.transactions,
            )
    );
  }
}


class TransactionItem extends StatefulWidget{


  @override
  State createState()=> TransactionState();
}

class TransactionState extends State<TransactionItem>{

  @override
  Widget build(BuildContext context) {

    return Center(

          child: Card(
          elevation: 1,
          margin: const EdgeInsets.all(4.0),
          color: Colors.white60,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: AssetData("交易对","BTCUSDT")),
                  Expanded(child:AssetData("订单类型","卖出")),
                  Expanded(child:AssetData("订单时间","2021-10-21 10:10:10"))
                ],
              ),
              Row(
                children: [
                  Expanded(child:AssetData("成交价格","100")),
                  Expanded(child:AssetData("成交金额","100")),
                  Expanded(child:AssetData("订单状态","完成")),

                ],
              )
            ],

          )

        ),
    );
  }
}


class AssetData extends StatefulWidget{

  String title = "";
  String value = "";

  AssetData(title,value, {Key? key}) : super(key: key){
    this.title = title;
    this.value = value;
  }

  @override
  State<StatefulWidget> createState() => AssetDataState(title,value);

}

class AssetDataState extends State<AssetData>{

  String title = "";
  String value = "";


  AssetDataState(this.title, this.value);

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [
            Container(
              child: Text(
                title,
                style: TextStyle(fontSize: 13.0),
              ),
            ),
            Container(
              child: Text(
                value,
                style: TextStyle(fontSize: 13.0),
              ),
            )
      ],
    );
  }
}

class AssetsSummary extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => AssetsSummaryState();
}

class AssetsSummaryState extends State<AssetsSummary>{

  @override
  Widget build(BuildContext context) {

    return Center(

      child: Card(

          elevation: 1,
          margin: const EdgeInsets.all(4.0),
          color: Colors.white60,
          child:Row(

            children: [
                Expanded(
                  child: Container(
                    child: Text(
                      "总资产(UDST)",
                      style: TextStyle(fontSize: 15.0),
                    ),
                  )
                  ),
                Expanded(
                    child:Container(
                          child: Text(
                            "100",
                            style: TextStyle(fontSize: 15.0),
                          ),
                        )
                ),
                Expanded(
                    child: Container(
                      child: Text(
                        "总收益",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    )
                ),
                Expanded(
                    child:Container(
                      child: Text(
                        "100%",
                        style: TextStyle(fontSize: 15.0),
                      ),
                    )
                ),
              ],
            )

          ),
         );

  }


}


