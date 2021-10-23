
import 'package:flutter/material.dart';
import 'package:yakapp/page/login.dart';

class BindExchangePage extends StatefulWidget{


  @override
  State createState()  => BindExchangeState();
}

class BindExchangeState extends State<BindExchangePage>{

  final _formKey = new GlobalKey<FormState>();
  var key ="";
  var secret="";

  Widget showKeyInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
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
        onFieldSubmitted: (value) => key = value.trim(),
        onTap: (){_formKey.currentState!.reset();},
        validator: (value){
          if(value!.trim()==""){
            return "key不能为空";
          }
        },
      ),
    );
  }

  Widget showSecretInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 10.0),
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
        onFieldSubmitted: (value) => secret = value.trim(),
        onTap: (){_formKey.currentState!.reset();},
        validator: (value){
          if(value!.trim()==""){
            return "secret不能为空";
          }
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      home: Scaffold(

          appBar:AppBar(
            title: const Text('注册账户-绑定'),
              backgroundColor: Colors.teal,
              leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.white),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (content){return LoginPage();})
                  );
                },
              )
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
                        showKeyInput(),
                        showSecretInput()
                      ]
                    )
                  )

                )


            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                child: TextButton(
                  child: Text('提交，完成注册'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                    foregroundColor: MaterialStateProperty.all(Colors.white)
                ),
                  onPressed: () {

                    if(!_formKey.currentState!.validate()){


                    }
                  },
                ),
              )

          ],

        )
      )

    );
  }


}