
import 'package:flutter/material.dart';
import 'package:yakapp/main.dart';
import 'regist.dart';

class LoginPage extends StatefulWidget{


  @override
  State createState()  => LoginState();
}

class LoginState extends State<LoginPage>{

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
            hintText: '请输入手机号',
            icon: new Icon(
              Icons.phone,
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
            hintText: '请输入密码',
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
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (content){return HomePage();})
                      );
                    }
                ),
              )

          ],

        )
      )

    );
  }


}