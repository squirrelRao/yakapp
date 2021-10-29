
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
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        autofocus: false,
        style: TextStyle(fontSize: 20),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '',
            labelText: "旧密码",
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),
        onSaved: (value){

          oldPassword = value!.trim();
          },
        validator: (value){

          if(value!.trim() == "" || value == null){
            return "密码不能为空";
          }
        },
      ),
    );
  }

  Widget _showNewPasswordInput() {
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
            hintText: '',
            labelText: "新密码",
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),
        onSaved: (value){

          newPassword = value!.trim();
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
            hintText: '',
            labelText: "新密码确认",
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

            if(passwordConfirmed != newPassword){
              return "两次输入的新密码不一致";
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
            title: const Text('修改密码'),
            backgroundColor: Colors.teal,
            leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.white),
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
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        _showOldPasswordInput(),
                        _showNewPasswordInput(),
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
                  child: Text('修改密码'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                    foregroundColor: MaterialStateProperty.all(Colors.white)
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