
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';

class AssetMarketSettingPage extends StatefulWidget{

  AssetMarketSettingPage({required this.asset});

  var asset ="";

  @override
  State createState()  => AssetMarketSettingState(asset: asset);
}

class AssetMarketSettingState extends State<AssetMarketSettingPage>{

  AssetMarketSettingState({required this.asset});

  var is_open = true;
  var is_predict = false;
  var asset = "";
  var title = "分析设置";

  Widget showAnalysisSwitch(){

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
        child:Column(children:[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text("实时数据分析(总)",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14)),
            Switch(
                value: is_open,
                activeColor: Color(0xff48ABFD),
                onChanged: (value) {
                  setState(() {
                    is_open = value;
                  });
                })
          ],
        ),
        ])
    );

  }

  Widget showPredictSwitch(){

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
        child:Column(children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text("未来1小时价格预测",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14)),
              Switch(
                  value: is_predict,
                  activeColor: Color(0xff48ABFD),
                  onChanged: (value) {
                    setState(() {
                      is_predict = value;
                    });
                  })
            ],
          ),
        ])
    );

  }

  void queryConfig() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getMarketTarget, {"user_id":userId,"asset":asset}, (data){
      title = asset+"分析设置";
      if(data["rc"] == 0 && data["data"] != ""){
        data = data["data"];

        setState(() {


          if(data["status"]==1){
              is_open = true;
          }else{
            is_open = false;
          }

          if(data["is_predict"] ==1){
            this.is_predict = true;
          }else{
            this.is_predict = false;
          }

        });
      }else{
        setState(() {


        });
      }

    });

  }

  void submitConfig(is_open,is_predict) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");

    var status = 1;
    if(is_open == false){
      status = 0;
    }

    var _predict = 1;
    if(is_predict == false){
      _predict = 0;
    }

    (NetClient()).post(Configs.updateMarketTarget,
        {"user_id":userId,"asset":asset,"status":status,"is_predict":_predict},
            (data){

          if(data["rc"] == 0){

            showSimpleNotification(
                Text("更新成功"),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.check,color:Colors.white),
                background: Color(0xff48ABFD));

          }else{
            showSimpleNotification(
                Text("更新失败，请重新登录后再设置"),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.error_outline,color:Colors.white),
                background: Color(0xffE95555));
          }

        });
  }

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> queryConfig());
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

          appBar:AppBar(
            title: Text(this.title,style:TextStyle(color: Color(0xff323232),fontSize: 17)),
              backgroundColor: Colors.white70,
              elevation: 0,
              centerTitle: true,
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
                        showAnalysisSwitch(),
                        showPredictSwitch(),
                        SizedBox(height:10)
                      ]
                    )
                  )
            ),
              Container(
                color: Colors.white,
                height: 40,
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                child: TextButton(
                  child: Text('提 交'),
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                      backgroundColor: MaterialStateProperty.all(Color(0xff48ABFD)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  40)))
                  ),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());

                    submitConfig(is_open,is_predict);
                  },
                ),
              )

          ],

        )
    ));
  }


}