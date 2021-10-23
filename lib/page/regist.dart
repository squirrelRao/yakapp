
import 'package:flutter/material.dart';
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
  var tip = "";

  Widget _showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        style: TextStyle(fontSize: 20),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入手机号',
            icon: new Icon(
              Icons.phone,
              color: Colors.teal,
            )),
        onFieldSubmitted: (value) {

          phone = value.trim();
        },
        onTap: (){_formKey.currentState!.reset();},
          validator: (value){
              if(value!.trim()==""){
              return "手机号不能为空";
              }
              if(!RegExp(r'^\d{11}$').hasMatch(value)){
              return "请输入11位合法手机号";
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
        autofocus: false,
        style: TextStyle(fontSize: 20),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入密码',
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),
        onFieldSubmitted: (value){

                password = value.trim();
          },
        onTap: (){_formKey.currentState!.reset();},

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
        autofocus: false,
        style: TextStyle(fontSize: 20),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请再次输入密码',
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),

        onFieldSubmitted: (value){

          passwordConfirmed = value.trim();

        },
          onTap: (){_formKey.currentState!.reset();},

          validator: (value){
             if(value!.trim() == "" || value == null){
               return "密码不能为空";
             }

            if(value != password){
              return "两次输入的密码不一致";
            }
            return null;
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

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
                  child: Text('提交，进入下一步'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                    foregroundColor: MaterialStateProperty.all(Colors.white)
                ),
                  onPressed: () {

                    if(!_formKey.currentState!.validate()){

                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (content){return BindExchangePage();})
                      );
                    }
                    // NetClient.instance.post(Configs.registApi, {})


                  },
                ),
              )

          ],

        )
      )

    );
  }


}