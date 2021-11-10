
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/main.dart';
import 'package:yakapp/page/bind_exchange.dart';
import 'package:yakapp/util/common_util.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'regist.dart';
import 'package:overlay_support/overlay_support.dart';


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
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Column(
          children:[
            Row(
              children: [
                Image(
                  width:20,
                  height:20,
                  image: AssetImage("images/phone.png"),
                ),
                Text("手机号",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
              ],
            ),
            SizedBox(height: 5),
            TextFormField(
              cursorColor: Color(0xff48ABFD),
          cursorHeight: 16,
          maxLines: 1,
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: false,
          style: TextStyle(fontSize: 15),
          decoration: new InputDecoration(
            hintText: "",
              labelText: "",
              border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none
                  ),
            ///设置内容内边距
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            filled: true,
            fillColor: Color(0xffF3F5F7),
          ),
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
            )]));
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 26.0, 0, 0.0),
      child: Column(
          children:[
          SizedBox(height: 10),
      Row(

        children: [
          Image(
            width:20,
            height:20,
            image: AssetImage("images/lock.png"),
          ),
          Text("密码",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
        ],
      ),
      SizedBox(height: 5),
      TextFormField(
        maxLines: 1,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
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
        onSaved: (value){

          password = value!.trim();
        },
        validator: (value){

          if(value!.trim() == "" || value == null){
            return "密码不能为空";
          }
        },
      ),
    ]));
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(

          body: Container(

        decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/login_bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
          child: ListView(

            children: <Widget>[

              Container(
                padding: const EdgeInsets.fromLTRB(28, 98, 28, 0),
                child:Text("你好",style:TextStyle(fontSize: 28,color:Color(0xff292D33),fontWeight: FontWeight.w700)),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(28, 2, 28, 0),
                child:Text("欢迎来到Yak!",style:TextStyle(fontSize: 28,color:Color(0xff292D33),fontWeight: FontWeight.w700)),
              ),
              Form(

                key : _formKey,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(28, 51, 28, 0),
                  child: Column(
                      children: <Widget>[
                        _showPhoneInput(),
                        _showPasswordInput(),
                        SizedBox(height: 30)
                      ]
                    )


                )


            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(32, 26, 32, 0),
                child: TextButton(
                  child: Text('登 录',style:TextStyle(color:Colors.white,fontWeight: FontWeight.w500)),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                    backgroundColor: MaterialStateProperty.all(Color(0xff48ABFD)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  22)))
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
                            prefs.setString("mail",data["data"]["mail"]);
                            prefs.setInt("isBind", data["data"]["bind"]);
                            Navigator.pop(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (content){return HomePage();})
                            );
                          }else{

                              showSimpleNotification(
                              Text("用户名或密码错误"),
                              duration: Duration(seconds: 1,milliseconds: 800),
                              leading: Icon(Icons.error_outline,color:Colors.white),
                              background: Color(0xffE95555));
                          }

                      });

                    }
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(35, 5, 35, 0),
                child: TextButton(
                  child:Text("注册账号",style: TextStyle(fontSize: 13,color:Color(0xff999999))),
                  onPressed: (){
                    Navigator.push(context,
                       MaterialPageRoute(builder: (content){return RegistPage();})
                       // MaterialPageRoute(builder: (content){return BindExchangePage();})
                    );
                  },
                ),
              ),],

        )

    ));
  }


}