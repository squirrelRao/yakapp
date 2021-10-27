
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 2,
        keyboardType: TextInputType.text,
        autofocus: true,
        style: TextStyle(fontSize: 16),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '',
            labelText: "交易所账号对应的key",
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
        keyboardType: TextInputType.text,
        obscureText: false,
        autofocus: false,
        style: TextStyle(fontSize: 16),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '',
            labelText: "交易所账号对应的secret",
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
            title: const Text('绑定交易所账号'),
              backgroundColor: Colors.teal,
              leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.white),
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