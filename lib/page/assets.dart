import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';

class AssetsPage extends StatefulWidget{


  @override
  State createState() => AssetsState();
}

class AssetsState extends State<AssetsPage>{

  dynamic datas;

  void getUserAssets() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString("uid");
    if(uid == ""){
      return;
    }

    ((NetClient()).post(Configs.getAssetsApi, {"user_id":uid}, (data){

            setState(() {
                datas = data;
            });
    }));

  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> getUserAssets());


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

            appBar: AppBar(
              title: const Text('资产'),
              backgroundColor: Colors.teal,
            ),
            body: ListView.builder(
                itemCount: datas.length,
                itemBuilder: (BuildContext context,int index) {


                    if(index == 0){

                      var total_ror = datas["accumulates_ror"];
                      var total_return = datas["accumulates_ror_return"];
                      var total_free = datas["accumulates_ror_free"];
                      var price_unit = datas["price_unit"];
                      var ror_duration = datas["ror_duration"];
                      return AssetsSummary(total_ror, total_return, total_free, price_unit, ror_duration);

                    }else{

                      dynamic data = datas[index];

                      var name = data["asset"];
                      var free = data["free"];
                      var price = data["price"];
                      var ror = data["ror"];
                      var ror_return = data["return"];
                      var target_ror=data["target_ror"];
                      var lowest_ror=data["lowest_ror"];
                      var price_unit = data["price_unit"];
                      return AssetItem(name,free,price,ror,ror_return,target_ror,lowest_ror,price_unit);


                    }



            })

    );
  }
}


class AssetItem extends StatefulWidget{

  AssetItem(name,free,price,ror,ror_return,target_ror,lowest_ror,price_unit);


  var name;
  var free;
  var price;
  var ror;
  var ror_return;
  var target_ror="-";
  var lowest_ror="-";
  var price_unit;


  @override
  State createState()=> AssetState(name,free,price,ror,ror_return,target_ror,lowest_ror,price_unit);
}

class AssetState extends State<AssetItem>{

  AssetState(name,free,price,ror,ror_return,target_ror,lowest_ror,price_unit);
  
  var name;
  var free;
  var price;
  var ror;
  var ror_return;
  var target_ror="-";
  var lowest_ror="-";
  var price_unit;

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
                  Expanded(child: AssetData("币种:",name))
                  ],
              ),
              Row(
                children: [
                  Expanded(child:AssetData("持仓:",free)),
                  Expanded(child:AssetData("价格",price+price_unit)),
                  Expanded(child:AssetData("收益:",ror_return+price_unit))
                ],
              ),
              Row(
                children: [
                  Expanded(child:AssetData("收益率:",ror)),
                  Expanded(child:AssetData("目标收益:",target_ror)),
                  Expanded(child:AssetData("止损收益:",lowest_ror))
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

  AssetsSummary(this.total_ror,this.total_return,this.total_free,this.price_unit,this.ror_duration);

  var total_ror;
  var total_return;
  var total_free;
  var price_unit;
  var ror_duration;

  @override
  State<StatefulWidget> createState() => AssetsSummaryState(total_ror,total_return,total_free,ror_duration,price_unit);
}

class AssetsSummaryState extends State<AssetsSummary>{

  AssetsSummaryState(this.total_ror,this.total_return,this.total_free,ror_duration,price_unit);

  var total_ror;
  var total_return;
  var total_free;
  var ror_duration;
  var price_unit;


  @override
  Widget build(BuildContext context) {

    return Center(

      child: Card(

          elevation: 1,
          margin: const EdgeInsets.all(4.0),
          color: Colors.white60,
          child:Row(

            children: [
              Row(
                children: [
                  Expanded(child: AssetData("总资产:",total_ror+price_unit)),
                  Expanded(child: AssetData("累计收益:",total_return+price_unit)),
                  Expanded(child: AssetData("累计收益率:",total_free)),
                  Expanded(child: AssetData("收益天数:",ror_duration))
                ],
              ),
              ],
            )

          ),
         );

  }


}


