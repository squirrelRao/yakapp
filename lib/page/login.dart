
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/main.dart';
import 'package:yakapp/util/common_util.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'regist.dart';

class LoginPage extends StatefulWidget{


  @override
  State createState()  => LoginState();
}

class LoginState extends State<LoginPage>{

  final _formKey = new GlobalKey<FormState>();
  var phone ="";
  var password = "";
  var registed = false;

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

            if(!registed){
              return "该手机号未注册，请先注册账户";
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
  @override
  Widget build(BuildContext context) {

    return  Scaffold(

          appBar:AppBar(
            title: const Text('登录账户'),
            backgroundColor: Colors.teal

          ),

          body: ListView(

            children: <Widget>[

              Container(
                padding: const EdgeInsets.only(top: 30),
                height: 160,
                child: Image(image: AssetImage('images/logo.png')),
              ),

              Form(

                key : _formKey,
                child: Container(

                  padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        _showPhoneInput(),
                        _showPasswordInput()
                      ]
                    )
                  )

                )


            ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(35, 10, 35, 0),
                child: TextButton(
                    child:Text("还没有账号?",style: TextStyle(fontSize: 14,color:Colors.teal)),
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (content){return RegistPage();})
                      );
                    },
                ),
              ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
                child: TextButton(
                  child: Text('登 录'),
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
                      (NetClient()).post(Configs.loginApi, {"phone":phone,"passwd":password}, (data) async {

                          if(data["rc"] == 0){

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("uid",data["data"]["user_id"]);
                            prefs.setString("name", data["data"]["name"]);

                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (content){return HomePage();})
                            );
                          }else{
                            Fluttertoast.showToast(msg:"用户名或密码错误");
                          }

                      });

                    }
                ),
              )

          ],

        )

    );
  }


}