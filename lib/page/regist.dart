
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  var registed = false;
  var mail = "";


  //after regist dialog
  showAfterRegistDialog(BuildContext context,String userId) {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {

          return SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))
              ),
            contentPadding: EdgeInsets.only(top:23,bottom:23,left:10,right:10),
            title: Text("账号注册成功！",textAlign:TextAlign.center,style:TextStyle(color:Color(0xff221232),fontWeight: FontWeight.w500)),
            children: [

              SimpleDialogOption(

                   child:
                       Container(
                         height: 44,
                           decoration: new BoxDecoration(
                             color: Color(0xff48ABFD),
                             borderRadius: BorderRadius.all(Radius.circular(22)),

                           ),
                       child:Padding(
                    padding:EdgeInsets.only(left:10,right:10),
                   child:
                   
                   Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children:[
                      Text("绑定交易所账号",style: TextStyle(color: Colors.white,fontSize:14,fontWeight: FontWeight.w400)),
                         Image(image: AssetImage("images/right_white_arrow.png"),
                         width:16,height:16)
                      ]))),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (content){return BindExchangePage(uid:userId);})
                    );
                  },
              ),
              SimpleDialogOption(
                child: Container(
                    height: 44,
                    decoration: new BoxDecoration(
                  color: Color(0xffF3F5F7),
                  borderRadius: BorderRadius.all(Radius.circular(22)),

                  ),
                    child:Padding(
                        padding:EdgeInsets.only(left:10,right:10),
                        child:

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              Text("稍后绑定...",style: TextStyle(color: Color(0xff48ABFD),fontSize:14,fontWeight: FontWeight.w400)),
                            ]))),
                        onPressed: (){
                          Navigator.pop(context);
                  Navigator.pop(context,
                      MaterialPageRoute(builder: (content){return LoginPage();})
                  );
                },
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 0),
                child: Text("提示: 不绑定交易所账号将无法使用相关服务",style: TextStyle(color: Colors.grey,fontSize: 13))
                ,
              )
            ],
          );
        });
  }

  Widget _showPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
      child:Column(
          children:[
          SizedBox(height: 10),
            Row(

              children: [
                Image(
                  width:20,
                  height:20,
                  image: AssetImage("images/phone.png"),
                ),
                Text("手机号",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
              ],
            ),
      TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
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

              if(registed){
                return "该手机号已注册";
              }

              return null;
        },
        )]));
  }

  Widget _showMailInput() {
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
            image: AssetImage("images/valide.png"),
          ),
          Text("邮箱「 接收提醒 」",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
        ],
      ),
        TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
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
          onSaved: (value) {
            mail = value!.trim();
          },
          onChanged: (value) async {

          },
          validator: (value) {
            if(value!.trim()==""){
              return "邮箱不能为空";
            }
            if(!RegExp(r'^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$').hasMatch(value)){
              return "请输入合法邮箱地址";
            }

            return null;
          },
        )]));
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
      child:Column(
          children:[
          SizedBox(height: 10),
      Row(

        children: [
          Image(
            width:20,
            height:20,
            image: AssetImage("images/lock.png"),
          ),
          Text("密码",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
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
              image: AssetImage("images/lock.png"),
            ),
            Text("密码确认",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
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

            if(passwordConfirmed != password){
              return "两次输入的密码不一致";
            }
            return null;
        }
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

          appBar:AppBar(
            backgroundColor: Colors.white70,
            elevation: 0,
            leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.black),
              onPressed: (){

                Navigator.pop(context,
                    MaterialPageRoute(builder: (content){return LoginPage();})
                );
              },
            ),
          ),

          body: Form(

                key : _formKey,
                child: ListView(

                    children:[

                      Container(
                        padding: const EdgeInsets.fromLTRB(40, 50, 25, 0),
                        child:Text("注册账号",style:TextStyle(fontSize: 30,fontWeight: FontWeight.w700)),
                      ),
                      Container(

                  padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                  child:  Column(
                      children: <Widget>[

                        _showPhoneInput(),
                        _showMailInput(),
                        _showPasswordInput(),
                        _showPasswordConfirmInput(),
                        SizedBox(height: 10)
                      ]

                  )

                ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
                child: TextButton(
                  child: Text('注 册'),
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
                  onPressed: () {

                    if(!_formKey.currentState!.validate()){
                      showAfterRegistDialog(context,"1");

                      return;
                    }
                    _formKey.currentState!.save();


                    NetClient().post(Configs.registApi, {"phone":phone,"passwd":password,"mail":mail},
                        (data) {

                              if(data["rc"] == 0){

                                showAfterRegistDialog(context,data["data"]["user_id"]);

                              }else{

                                Fluttertoast.showToast(msg: data["msg"]);

                              }
                        });



                  },
                ),
              )
              ]))

    );
  }


}