
import 'package:flutter/material.dart';
import 'package:yakapp/login.dart';

class ModifyBindPage extends StatefulWidget{


  @override
  State createState()  => ModifyBindState();
}

class ModifyBindState extends State<ModifyBindPage>{

  final _formKey = new GlobalKey<FormState>();
  var _userID;
  var _password;

  Widget _showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        style: TextStyle(fontSize: 20),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入API-KEY',
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),
        onSaved: (value) => _userID = value!.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(fontSize: 20),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入API-SECRET',
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),
        onSaved: (value) => _password = value!.trim(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

          appBar:AppBar(
            title: const Text('更新交易所绑定信息'),
              backgroundColor: Colors.teal,
              leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.white),
                onPressed: (){
                 Navigator.pop(context);
                },
              )
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
                height: 70,
                padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
                child: TextButton(
                  child: Text('提交更新'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                    foregroundColor: MaterialStateProperty.all(Colors.white)
                ),
                  onPressed: () {
                    //_onLogin();
                  },
                ),
              )

          ],

        )
      )

    );
  }


}