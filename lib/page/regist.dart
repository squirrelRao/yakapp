
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/bind_exchange.dart';
import 'package:yakapp/page/login.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:yakapp/util/configs.dart';

class RegistPage extends StatefulWidget{


  @override
  State createState()  => RegistState();
}

class RegistState extends State<RegistPage>{

  final _formKey = new GlobalKey<FormState>();
  var phone ="";
  var password = "";
  var passwordConfirmed = "";
  var registed = false;


  //after regist dialog
  showAfterRegistDialog(BuildContext context,String userId) {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return SimpleDialog(
            title: Text("账号注册成功！"),
            children: [

              SimpleDialogOption(
                  child: Text("绑定交易所账号 >",style: TextStyle(color: Colors.teal,fontSize:18)),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (content){return BindExchangePage(uid:userId);})
                    );
                  },
              ),
              SimpleDialogOption(
                child: Text("稍后绑定...",style: TextStyle(fontSize: 18,color: Colors.teal)),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (content){return LoginPage();})
                  );
                },
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 10),
                child: Text("提示: 不绑定交易所账号将无法使用相关服务",style: TextStyle(color: Colors.grey,fontSize: 13))
                ,
              )
            ],
          );
        });
  }

  Widget _showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
        style: TextStyle(fontSize: 20),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入手机号',
            icon: new Icon(
              Icons.phone,
              color: Colors.teal,
            )),
        onSaved: (value) {
          phone = value!.trim();
        },
        onChanged: (value) async {

          if(value.length == 11){

            (NetClient()).post(Configs.checkRegistApi, {"phone":value}, (data){
              if(data["rc"] != 0){
                setState(() {
                  registed = true;
                });
              }else{
                setState(() {
                  registed = false;
                });
              }
            });
          }

        },
          validator: (value) {
              if(value!.trim()==""){
              return "手机号不能为空";
              }
              if(!RegExp(r'^\d{11}$').hasMatch(value)){
              return "请输入11位合法手机号";
              }

              if(registed){
                return "该手机号已注册";
              }

              return null;
        },
        ));
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
        style: TextStyle(fontSize: 20),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入密码',
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),
        onSaved: (value){

                password = value!.trim();
          },
        validator: (value){

          if(value!.trim() == "" || value == null){
            return "密码不能为空";
          }
        },
      ),
    );
  }

  Widget _showPasswordConfirmInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 10.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: false,
        style: TextStyle(fontSize: 20),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请再次输入密码',
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),

        onSaved: (value){

          passwordConfirmed = value!.trim();

        },
          validator: (value){
             if(value!.trim() == "" || value == null){
               return "密码不能为空";
             }

            if(passwordConfirmed != password){
              return "两次输入的密码不一致";
            }
            return null;
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

          appBar:AppBar(
            title: const Text('注册账户'),
            backgroundColor: Colors.teal,
            leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.white),
              onPressed: (){

                Navigator.pop(context,
                    MaterialPageRoute(builder: (content){return LoginPage();})
                );
              },
            ),
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
                        _showPhoneInput(),
                        _showPasswordInput(),
                        _showPasswordConfirmInput()
                      ]
                    )
                  )

                )


            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
                child: TextButton(
                  child: Text('注 册'),
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
                    NetClient().post(Configs.registApi, {"phone":phone,"passwd":password},
                        (data) {

                              if(data["rc"] == 0){

                                showAfterRegistDialog(context,data["data"]["user_id"]);

                              }else{

                                Fluttertoast.showToast(msg: data["msg"]);

                              }
                        });



                  },
                ),
              )

          ],

        )

    );
  }


}