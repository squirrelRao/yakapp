
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';

class AnalysisSettingPage extends StatefulWidget{

  AnalysisSettingPage();

  @override
  State createState()  => AnalysisSettingState();
}

class AnalysisSettingState extends State<AnalysisSettingPage>{

  AnalysisSettingState();

  final _formKey = new GlobalKey<FormState>();

  TextEditingController depthController = new TextEditingController(text: "");
  TextEditingController volumeBaseController = new TextEditingController(text: "");

  var depth_count = 0;
  var volume_base = 0;

  Widget showDepthCount() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Column(
          children:[
      Row(
      children:[
          Text("设置深度数 (推荐5,10,20,50,100)",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14))
        ]),
      SizedBox(height: 5),
      new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: depthController,
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
        onSaved: (value) => depth_count = int.parse(value!.trim()),
        onTap: (){
          depthController.text="";
        },
        validator: (value){
          if(value!.trim()==""){
            return "不能为空";
          }

          if(int.tryParse(value) == null){
            return "格式错误";
          }
          if(int.parse(value) < 1){
            return "范围必须大于0";
          }
        },
      ),
    ]));
  }

  Widget showVolumeBaseInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
        child: Column(
            children:[
              Row(
                  children:[
                    Text("成交量评估基线(USDT）",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14))
                  ]),
              SizedBox(height: 5),
              new TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: volumeBaseController,
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
                onSaved: (value) => volume_base = int.parse(value!.trim()),
                onTap: (){
                  volumeBaseController.text="";
                },
                validator: (value){
                  if(value!.trim()==""){
                    return "不能为空";
                  }

                  if(int.tryParse(value) == null){
                    return "格式错误";
                  }
                  if(int.parse(value) <= 0){
                    return "必须大于0";
                  }
                },
              ),
            ]));
  }

  void queryFitValueConfig() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getUserInfo, {"user_id":userId}, (data){

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

  void submitConfig(ror_duration,ror_touch,l_ror_touch,notify_period) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");


    (NetClient()).post(Configs.updateUserConfigApi,
        {"user_id":userId},
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

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> queryFitValueConfig());
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
                        showDepthCount(),
                        showVolumeBaseInput(),
                        SizedBox(height:15)
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

                    if(!_formKey.currentState!.validate()){

                       return;
                    }

                    _formKey.currentState!.save();
                    // submitConfig(ror_duration,ror_touch,l_ror_touch,notify_period);
                  },
                ),
              )

          ],

        )
    ));
  }


}