
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/bind_exchange.dart';
import 'package:yakapp/page/login.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:yakapp/util/configs.dart';
import 'package:overlay_support/overlay_support.dart';

class ModifyPasswordPage extends StatefulWidget{


  @override
  State createState()  => ModifyPasswordState();
}

class ModifyPasswordState extends State<ModifyPasswordPage>{

  final _formKey = new GlobalKey<FormState>();
  var oldPassword ="";
  var newPassword = "";
  var passwordConfirmed = "";

  Widget _showOldPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Column(
          children:[
      Row(

        children: [
          Image(
            width:20,
            height:20,
            image: AssetImage("images/lock.png"),
          ),
          Text("旧密码",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
        ],
      ),
            SizedBox(height: 5),
            new TextFormField(
        maxLines: 1,
        obscureText: true,
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

          oldPassword = value!.trim();
          },
        validator: (value){

          if(value!.trim() == "" || value == null){
            return "密码不能为空";
          }
        },
      ),
    ]));
  }

  Widget _showNewPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child:
      Column(
          children:[
      Row(

        children: [
          Image(
            width:20,
            height:20,
            image: AssetImage("images/lock.png"),
          ),
          Text("新密码",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
        ],
      ),
      SizedBox(height:5),
      new TextFormField(
        maxLines: 1,
        obscureText: true,
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

          newPassword = value!.trim();
        },
        validator: (value){

          if(value!.trim() == "" || value == null){
            return "密码不能为空";
          }
        },
      ),
    ]));
  }


  Widget _showPasswordConfirmInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Column(
          children:[
        Row(

          children: [
            Image(
              width:20,
              height:20,
              image: AssetImage("images/valide.png"),
            ),
            Text("密码确认",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
          ],
        ),
            SizedBox(height:5),
            new TextFormField(
        maxLines: 1,
        obscureText: true,
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

          passwordConfirmed = value!.trim();

        },
          validator: (value){
             if(value!.trim() == "" || value == null){
               return "密码不能为空";
             }

            if(passwordConfirmed != newPassword){
              return "两次输入的新密码不一致";
            }
            return null;
        }
      ),
    ]) );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

          appBar:AppBar(
            title: const Text('修改密码',style: TextStyle(color: Colors.black)),
            centerTitle: true,
            backgroundColor: Colors.white70,
            elevation: 0,
            leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.black),
              onPressed: (){

                Navigator.pop(context);
              },
            ),
          ),

          body: ListView(

            children: <Widget>[
              Form(

                key : _formKey,
                child: Container(

                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 0),
                  child: Column(
                      children: <Widget>[
                        _showOldPasswordInput(),
                        _showNewPasswordInput(),
                        _showPasswordConfirmInput(),
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
                  onPressed: () async {

                    if(!_formKey.currentState!.validate()){

                      return;
                    }
                    _formKey.currentState!.save();

                    SharedPreferences prefs =  await SharedPreferences.getInstance();
                    String? userId = prefs.getString("uid");
                    NetClient().post(Configs.modifyPasswordApi, {"user_id":userId,"passwd":oldPassword,"new_password":newPassword,"password_confirm":passwordConfirmed},
                        (data) {

                              if(data["rc"] == 0){

                                showSimpleNotification(
                                Text("密码更新成功"),
                                duration: Duration(seconds: 1,milliseconds: 800),
                                leading: Icon(Icons.check,color:Colors.white),
                                background: Color(0xff48ABFD));


                              }else{

                                showSimpleNotification(
                                Text("旧密码不正确，更新失败"),
                                duration: Duration(seconds: 1,milliseconds: 800),
                                leading: Icon(Icons.error_outline,color:Colors.white),
                                background: Color(0xffE95555));
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