import 'package:flutter/material.dart';

class AssetsPage extends StatefulWidget{


  @override
  State createState() => AssetsState();
}

class AssetsState extends State<AssetsPage>{

   List<Widget> assets = <Widget>[
     AssetsSummary(),
     AssetItem()
   ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        home: Scaffold(

            appBar: AppBar(
              title: const Text('资产'),
              backgroundColor: Colors.teal,
            ),
            body: ListView(
              scrollDirection: Axis.vertical,
              children: this.assets,
            )
        )
    );
  }
}


class AssetItem extends StatefulWidget{


  @override
  State createState()=> AssetState();
}

class AssetState extends State<AssetItem>{

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
                  Expanded(child: AssetData("BTC","100"))

                  ],
              ),
              Row(
                children: [
                  Expanded(child:AssetData("持仓","100")),
                  Expanded(child:AssetData("最新价格","100"))
                ],
              ),
              Row(
                children: [
                  Expanded(child:AssetData("持有收益","100%")),
                  Expanded(child:AssetData("目标收益","200%")),
                  Expanded(child:AssetData("止损收益","60%")),
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
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Container(
              child: Text(
                value,
                style: TextStyle(fontSize: 15.0),
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


