
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/login.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:yakapp/util/common_util.dart';

class ModifyBindPage extends StatefulWidget{


  @override
  State createState()  => ModifyBindState();
}

class ModifyBindState extends State<ModifyBindPage>{

  final _formKey = new GlobalKey<FormState>();
  var key ="";
  var secret="";
  TextEditingController keyController = new TextEditingController(text: '');
  TextEditingController secretController = new TextEditingController(text: '');

  Widget showKeyInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 4,
        keyboardType: TextInputType.text,
        autofocus: true,
        controller: keyController,
        style: TextStyle(fontSize: 16),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '',
            labelText: "交易所账号对应的key",
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),
        onSaved: (value) => key = value!.trim(),
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
        maxLines: 4,
        autofocus: false,
        controller: secretController,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 16),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '',
            labelText: "交易所账号对应的secret",
            icon: new Icon(
              Icons.lock,
              color: Colors.teal,
            )),
        onSaved: (value) => secret = value!.trim(),
        validator: (value){
          if(value!.trim()==""){
            return "secret不能为空";
          }
        },
      ),
    );
  }

  void queryBindInfo() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getBindInfo, {"uid":userId}, (data){

      if(data["rc"] == 0 && data["data"] != ""){

        setState(() {
          key = data["data"]["api_key"];
          secret = data["data"]["api_secret"];
          keyController.text = key;
          secretController.text = secret;
          prefs.setInt("isBind", 1);

        });
      }else{
        setState(() {
          key = "";
          secret = "";
          keyController.text = key;
          secretController.text = secret;
          prefs.setInt("isBind", 0);
        });
      }

    });

  }

  void bindExchange(key,secret) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.bindApi,{"user_id":userId,"key":key,"secret":secret}
    , (data){

          if(data["rc"] == 0){

            Fluttertoast.showToast(msg: "交易所账号更新成功");

          }else{
            Fluttertoast.showToast(msg: "绑定失败，请检查key和secret是否正确！");

          }

        });
  }

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> queryBindInfo());
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

          appBar:AppBar(
            title: const Text('更新交易所账号'),
              backgroundColor: Colors.teal,
              leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.white),
                onPressed: () async {
                    Navigator.pop(context);
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
                  child: Text('提 交'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                    foregroundColor: MaterialStateProperty.all(Colors.white)
                ),
                  onPressed: () {

                    if(!_formKey.currentState!.validate()){

                       return;
                    }

                    _formKey.currentState!.save();
                    bindExchange(key,secret);
                  },
                ),
              )

          ],

        )
    );
  }


}