
import 'package:flutter/material.dart';

class RorSettingPage extends StatefulWidget{


  @override
  State createState()  => RorSettingState();
}

class RorSettingState extends State<RorSettingPage>{

  final _formKey = new GlobalKey<FormState>();
  var _userID;
  var _password;

  Widget _showTargetInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        style: TextStyle(fontSize: 20),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入目标收益率',
            ),
        onSaved: (value) => _userID = value!.trim(),
      ),
    );
  }

  Widget _showLowestInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        obscureText: true,
        autofocus: false,
        style: TextStyle(fontSize: 20),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入止损收益率',
            ),
        onSaved: (value) => _password = value!.trim(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

          appBar:AppBar(
            title: const Text('收益率目标设定'),
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
                        Text("BTC",style: TextStyle(fontSize: 20),),
                        _showTargetInput(),
                        _showLowestInput()
                      ]
                    )
                  )

                )


            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
                child: TextButton(
                  child: Text('提 交'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
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