
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
        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
        child: Column(
          children:[
            SizedBox(height: 10),
            Row(

              children: [
                Icon(Icons.phone_rounded,
                color:Color(0xd33094FE)),
                Text("手机号",style:TextStyle(fontSize: 18))
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: false,
          style: TextStyle(fontSize: 15),
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
            fillColor: Color(0x4fD3D3D3),
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
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15, 0.0),
      child: Column(
          children:[
          SizedBox(height: 10),
      Row(

        children: [
          Icon(Icons.lock,
              color:Color(0xd33094FE)),
          Text("密码",style:TextStyle(fontSize: 18))
        ],
      ),
      SizedBox(height: 10),
      TextFormField(
        maxLines: 1,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
        style: TextStyle(fontSize: 15),
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
          fillColor: Color(0x4fD3D3D3),
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

          // appBar:AppBar(
          // ),

          body: ListView(

            children: <Widget>[

              Container(
                padding: const EdgeInsets.fromLTRB(30, 80, 25, 0),
                child:Text("你好",style:TextStyle(fontSize: 30,fontWeight: FontWeight.w700)),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(30, 10, 25, 0),
                child:Text("欢迎来到Yak!",style:TextStyle(fontSize: 30,fontWeight: FontWeight.w700)),
              ),
              Form(

                key : _formKey,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                      children: <Widget>[
                        _showPhoneInput(),
                        _showPasswordInput(),
                        SizedBox(height: 20)
                      ]
                    )


                )


            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                child: TextButton(
                  child: Text('登 录'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                    backgroundColor: MaterialStateProperty.all(Color(0xd33094FE)),
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
                      (NetClient()).post(Configs.loginApi, {"phone":phone,"passwd":password}, (data) async {

                          if(data["rc"] == 0){

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString("uid",data["data"]["user_id"]);
                            prefs.setString("name", data["data"]["name"]);
                            prefs.setInt("isBind", data["data"]["bind"]);
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
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.fromLTRB(35, 10, 35, 0),
                child: TextButton(
                  child:Text("注册账号",style: TextStyle(fontSize: 14,color:Colors.teal)),
                  onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (content){return RegistPage();})
                    );
                  },
                ),
              ),],

        )

    );
  }


}