
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';

class AnalysisTargetSettingPage extends StatefulWidget{

  AnalysisTargetSettingPage();

  @override
  State createState()  => AnalysisTargetSettingState();
}

class AnalysisTargetSettingState extends State<AnalysisTargetSettingPage>{

  AnalysisTargetSettingState();

  final _formKey = new GlobalKey<FormState>();

  TextEditingController assetController = new TextEditingController(text: "");

  var asset = 0;

  Widget showAssetInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Column(
          children:[
      Row(
      children:[
          Text("目标名称（例如: BTC)",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14))
        ]),
      SizedBox(height: 5),
      new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: assetController,
        style: TextStyle(fontSize: 15),
        cursorColor: Color(0xff48ABFD),
        cursorHeight: 16,
        decoration: new InputDecoration(
          hintText: "",
          labelText: "",
          border:OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none
          ),
          ///设置内容内边距
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          filled: true,
          fillColor: Color(0xffF3F5F7),
        ),
        onSaved: (value) => asset = int.parse(value!.trim()),
        onTap: (){
          assetController.text="";
        },
        validator: (value){
          if(value!.trim()==""){
            return "不能为空";
          }
        },
      ),
    ]));
  }

  void submitAdd(asset) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");


    (NetClient()).post(Configs.addMarketTarget,
        {"user_id":userId,"asset":asset},
            (data){

          if(data["rc"] == 0){

            showSimpleNotification(
                Text("操作成功"),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.check,color:Colors.white),
                background: Color(0xff48ABFD));

          }else{
            showSimpleNotification(
                Text("操作失败，请重新登录后再设置"),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.error_outline,color:Colors.white),
                background: Color(0xffE95555));
          }

        });
  }

  void submitRemove(asset) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");


    (NetClient()).post(Configs.removeMarketTarget,
        {"user_id":userId,"asset":asset},
            (data){

          if(data["rc"] == 0){

            showSimpleNotification(
                Text("操作成功"),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.check,color:Colors.white),
                background: Color(0xff48ABFD));

          }else{
            showSimpleNotification(
                Text("操作失败，请重新登录后再设置"),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.error_outline,color:Colors.white),
                background: Color(0xffE95555));
          }

        });
  }

  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

          appBar:AppBar(
            title: const Text('分析设置',style:TextStyle(color: Color(0xff323232),fontSize: 17)),
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

                key : _formKey,
                child: Container(
                  color: Color(0xffffffff),
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                  child: Column(
                      children: <Widget>[
                        showAssetInput(),
                        SizedBox(height:15)
                      ]
                    )
                  )
            ),
              Container(
                  height: 70,
                  padding: const EdgeInsets.fromLTRB(32, 26, 32, 0),
                  child: Row(
                      children:[
                        Expanded(
                            child:TextButton(
                              child: Text('提交删除'),
                              style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),
                                  backgroundColor: MaterialStateProperty.all(Color(0xff48ABFD)),
                                  foregroundColor: MaterialStateProperty.all(Colors.white)
                              ),
                              onPressed: () {
                                FocusScope.of(context).requestFocus(FocusNode());

                                if(!_formKey.currentState!.validate()){

                                  return;
                                }

                                _formKey.currentState!.save();
                                submitRemove(asset);
                              },
                            )),
                        SizedBox(width: 20),
                        Expanded(
                          child:TextButton(
                            child: Text('提交新增'),
                            style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),
                                backgroundColor: MaterialStateProperty.all(Color(0xff48ABFD)),
                                foregroundColor: MaterialStateProperty.all(Colors.white)
                            ),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());

                              if(!_formKey.currentState!.validate()){

                                return;
                              }

                              _formKey.currentState!.save();
                              submitAdd(asset);
                            },
                          ),
                        )]
                  )
              )

          ],

        )
    ));
  }


}

