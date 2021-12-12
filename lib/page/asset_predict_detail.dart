
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/asset_market_setting.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';

class AssetPredictDetailPage extends StatefulWidget{

  AssetPredictDetailPage({required this.asset});

  var asset ="";

  @override
  State createState()  => AssetPredictDetailState(asset: asset);
}

class AssetPredictDetailState extends State<AssetPredictDetailPage>{

  AssetPredictDetailState({required this.asset});

  var asset;
  var title = "价格预测详情";

  Widget showPredictChart(){

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
        child:Column(children:[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text("未来一小时价格预测走势",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14)),

          ],
        ),
        ])
    );

  }

  Widget showLatestHPChart(){

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
        child:Column(children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text("过去一小时预测与真实价格对比",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14)),

            ],
          ),
        ])
    );

  }

  Widget showLossAndValLoss(){

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
        child:Column(children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text("预测损失对比",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14)),

            ],
          ),
        ])
    );

  }

  void queryPredictDetail() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getPredictDetail, {"user_id":userId,"asset":asset}, (data){
      title = asset+"价格预测详情";
      if(data["rc"] == 0 && data["data"] != ""){
        data = data["data"];

        setState(() {


        });
      }else{
        setState(() {


        });
      }

    });

  }

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> queryPredictDetail());
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

          appBar:AppBar(
            title: Text(this.title,style:TextStyle(color: Color(0xff323232),fontSize: 17)),
              backgroundColor: Colors.white70,
              elevation: 0,
              centerTitle: true,
              actions: [IconButton(
                  icon: Icon(Icons.segment,size: 24,color: Color(0xff323232),),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (content){return AssetMarketSettingPage(asset: asset);}));
                  })],
              leading: IconButton(
                icon:Image(
                  width:24,
                  height:24,
                  image: AssetImage("images/back.png"),
                ),
                onPressed: () async {
                    Navigator.pop(context);
                },
              )
          ),

          body:  GestureDetector(

    behavior: HitTestBehavior.translucent,
    onTap:() {
    FocusScope.of(context).requestFocus(FocusNode());
    },
    child:ListView(

            children: <Widget>[

              Form(
                  child: Container(
                  color: Color(0xffffffff),
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                  child: Column(
                      children: <Widget>[
                        showPredictChart(),
                        showLatestHPChart(),
                        showLossAndValLoss(),
                        SizedBox(height:10)
                      ]
                    )
                  )
            ),
          ],

        )
    ));
  }


}