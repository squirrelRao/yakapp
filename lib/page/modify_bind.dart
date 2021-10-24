
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/login.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:yakapp/util/common_util.dart';

class ModifyBindPage extends StatefulWidget{


  @override
  State createState()  => ModifyBindState();
}

class ModifyBindState extends State<ModifyBindPage>{

  final _formKey = new GlobalKey<FormState>();
  var key ="";
  var secret="";

  Widget showKeyInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 2,
        keyboardType: TextInputType.text,
        autofocus: true,
        style: TextStyle(fontSize: 16),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请填写账号对应的key',
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),
        onSaved: (value) => key = value!.trim(),
        validator: (value){
          if(value!.trim()==""){
            return "key不能为空";
          }
        },
      ),
    );
  }

  Widget showSecretInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 10.0),
      child: new TextFormField(
        maxLines: 2,
        autofocus: false,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 16),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请填写账号对应的secret',
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),
        onSaved: (value) => secret = value!.trim(),
        validator: (value){
          if(value!.trim()==""){
            return "secret不能为空";
          }
        },
      ),
    );
  }

  void queryBindInfo() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getBindInfo, {"uid":userId}, (data){

      if(data["rc"] == 0 && data["data"] != ""){

        setState(() {
          key = data["api_key"];
          secret = data["api_secret"];
        });
      }else{
        setState(() {
          key = "";
          secret = "";
        });
      }

    });

  }

  void bindExchange(key,secret) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.bindApi,{"user_id":userId,"key":key,"secret":secret}
    , (data){

          if(data["rc"] == 0){

            Fluttertoast.showToast(msg: "交易所绑定成功");

          }

        });
  }

  @override
  void initState(){
    super.initState();
    queryBindInfo();

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

          appBar:AppBar(
            title: const Text('更新交易所账号'),
              backgroundColor: Colors.teal,
              leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.white),
                onPressed: () async {
                    Navigator.pop(context);
                },
              )
          ),

          body: ListView(

            children: <Widget>[

              Form(

                key : _formKey,
                child: Container(

                  padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        showKeyInput(),
                        showSecretInput()
                      ]
                    )
                  )

                )


            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                child: TextButton(
                  child: Text('提 交'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                    foregroundColor: MaterialStateProperty.all(Colors.white)
                ),
                  onPressed: () {

                    if(!_formKey.currentState!.validate()){

                       return;
                    }

                    _formKey.currentState!.save();
                    bindExchange(key,secret);
                  },
                ),
              )

          ],

        )
    );
  }


}