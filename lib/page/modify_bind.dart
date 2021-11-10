
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/login.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:yakapp/util/common_util.dart';
import 'package:overlay_support/overlay_support.dart';

class ModifyBindPage extends StatefulWidget{


  @override
  State createState()  => ModifyBindState();
}

class ModifyBindState extends State<ModifyBindPage>{

  final _formKey = new GlobalKey<FormState>();
  var key ="";
  var secret="";
  TextEditingController keyController = new TextEditingController(text: '');
  TextEditingController secretController = new TextEditingController(text: '');

  Widget showKeyInput() {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child:Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 17.0, 24, 16),
      child: Column(
          children:[
      Row(

        children: [
          Image(
            width:20,
            height:20,
            image: AssetImage("images/valide.png"),
          ),
          Text("交易所账号对应的key",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
        ],
      ),
        Padding(padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
            child:
      new TextFormField(
        maxLines: 3,
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: keyController,
        style: TextStyle(fontSize: 15),
        cursorColor: Color(0xff48ABFD),
        cursorHeight: 16,
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '',
            labelText: "",
            ),
        onSaved: (value) => key = value!.trim(),
        validator: (value){
          if(value!.trim()==""){
            return "key不能为空";
          }
        },
      )),
    ])));
  }

  Widget showSecretInput() {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child:Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 17.0, 24, 16),
      child: Column(
          children:[
      Row(
        children: [
          Image(
            width:20,
            height:20,
            image: AssetImage("images/valide.png"),
          ),
          Text("交易所账号对应的secret",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
        ],
      ),
      Padding(padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0),
      child:
      new TextFormField(
        maxLines: 3,
        autofocus: false,
        controller: secretController,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 15),
        cursorColor: Color(0xff48ABFD),
        cursorHeight: 16,
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '',
            labelText: "",
            ),
        onSaved: (value) => secret = value!.trim(),
        validator: (value){
          if(value!.trim()==""){
            return "secret不能为空";
          }
        },
      )),
    ])));
  }

  void queryBindInfo() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getBindInfo, {"uid":userId}, (data){

      if(data["rc"] == 0 && data["data"] != ""){

        setState(() {
          key = data["data"]["api_key"];
          secret = data["data"]["api_secret"];
          keyController.text = key;
          secretController.text = secret;
          prefs.setInt("isBind", 1);

        });
      }else{
        setState(() {
          key = "";
          secret = "";
          keyController.text = key;
          secretController.text = secret;
          prefs.setInt("isBind", 0);
        });
      }

    });

  }

  void bindExchange(context,key,secret) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.bindApi,{"user_id":userId,"key":key,"secret":secret}
    , (data){

          if(data["rc"] == 0){

            showSimpleNotification(
                Text("交易所账号更新成功"),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.check,color:Colors.white),
                background: Color(0xff48ABFD));
          }else{
            showSimpleNotification(
                Text("更新失败，请检查key和secret是否正确"),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.error_outline,color:Colors.white),
                background: Color(0xffE95555));
          }

        });
  }

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> queryBindInfo());
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

          appBar:AppBar(
            title: const Text('更新交易所账号',style:TextStyle(color: Color(0xff323232),fontSize: 17)),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white70,
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

                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 0),
                  child:  Column(
                      children: <Widget>[
                        showKeyInput(),
                        SizedBox(height: 24),
                        showSecretInput(),
                      ]
                    )
                )


            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(32, 26, 32, 0),
                child: TextButton(
                  child: Text('提 交',style:TextStyle(color:Colors.white,fontWeight: FontWeight.w500)),
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
                    bindExchange(context,key,secret);
                  },
                ),
              )

          ],

        )
    ));
  }


}