
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/bind_exchange.dart';
import 'package:yakapp/page/login.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:yakapp/util/configs.dart';

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
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
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
          Text("旧密码",style:TextStyle(fontSize: 14))
        ],
      ),
      new TextFormField(
        maxLines: 1,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
        style: TextStyle(fontSize: 20),
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
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
      child:
      Column(
          children:[
          SizedBox(height: 10),
      Row(

        children: [
          Image(
            width:20,
            height:20,
            image: AssetImage("images/lock.png"),
          ),
          Text("新密码",style:TextStyle(fontSize: 14))
        ],
      ),
      new TextFormField(
        maxLines: 1,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
        style: TextStyle(fontSize: 20),
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
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
      child: Column(
          children:[
          SizedBox(height: 10),
        Row(

          children: [
            Image(
              width:20,
              height:20,
              image: AssetImage("images/valide.png"),
            ),
            Text("密码确认",style:TextStyle(fontSize: 14))
          ],
        ),
      new TextFormField(
        maxLines: 1,
        obscureText: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: false,
        style: TextStyle(fontSize: 20),
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

                  padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                  child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        _showOldPasswordInput(),
                        _showNewPasswordInput(),
                        _showPasswordConfirmInput(),
                        SizedBox(height: 20)
                      ]
                    )
                  )
            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
                child: TextButton(
                  child: Text('确认修改'),
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

                                Fluttertoast.showToast(msg:"密码更新成功");

                              }else{

                                Fluttertoast.showToast(msg: "旧密码不正确，更新失败");

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