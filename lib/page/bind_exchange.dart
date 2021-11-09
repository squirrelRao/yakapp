
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/login.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:yakapp/util/common_util.dart';

class BindExchangePage extends StatefulWidget{


  BindExchangePage({Key? key, uid}): super(key: key);

  String uid = "";

  @override
  State createState()  => BindExchangeState(uid);
}

class BindExchangeState extends State<BindExchangePage>{

  final _formKey = new GlobalKey<FormState>();
  var key ="";
  var secret="";
  var uid = "";

  BindExchangeState(String uid);

  Widget showKeyInput() {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child:Padding(

      padding: const EdgeInsets.fromLTRB(24.0, 17.0, 24, 16),
      child:  Column(
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
          child:new TextFormField(
        maxLines: 2,
        keyboardType: TextInputType.text,
        autofocus: false,
        style: TextStyle(fontSize: 16),
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
    child:  Column(
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
    Padding(padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 0.0),
      child: new TextFormField(
        maxLines: 2,
        keyboardType: TextInputType.text,
        obscureText: false,
        autofocus: false,
        style: TextStyle(fontSize: 16),
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

  void bindExchange(key,secret) async {

    (NetClient()).post(Configs.bindApi,{"user_id":uid,"key":key,"secret":secret}
    , (data){

          if(data["rc"] == 0){

            Fluttertoast.showToast(msg: "交易所绑定成功，请登录");
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (content) {
                  return LoginPage();
                })
            );

          }else{
            Fluttertoast.showToast(msg: "绑定失败，请检查key和secret是否正确！");

          }

        });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

          appBar:AppBar(
            title: const Text('绑定交易所账号',style: TextStyle(color: Colors.black)),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white70,
              leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.black),
                onPressed: () async {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (content) {
                          return LoginPage();
                        })
                    );
                },
              )
          ),

          body: ListView(

            children: <Widget>[

              Form(

                key : _formKey,
                child: Container(

                    padding: const EdgeInsets.fromLTRB(28, 30, 28, 0),
                  child:  Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        showKeyInput(),
                        SizedBox(height: 24),
                        showSecretInput(),
                      ]
                    )
                )


            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(32, 30, 32, 0),
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