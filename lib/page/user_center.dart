import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/ModifyPasswordPage.dart';
import 'package:yakapp/page/bind_exchange.dart';
import 'package:yakapp/page/common_setting.dart';
import 'package:yakapp/page/login.dart';
import 'package:yakapp/page/modify_bind.dart';

class UserCenterPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => UserCenterState();

}

class UserCenterState extends State<UserCenterPage> {

  String bindStatus = "未绑定";
  String userName = "";

  showAboutDialog(BuildContext context) {

    showDialog(
        context: context,
        builder: (BuildContext context) {

              return SimpleDialog(
                title: Text("Yak"),
                children: [

                  SimpleDialogOption(
                      child: Text("v1.0")
                  ),
                  SimpleDialogOption(
                      child: Text("hqraop@163.com")
                  ),
                  SimpleDialogOption(
                      child: Text("by squirrelRao @2021")
                  )
                ],
              );
    });
  }

  void updateUserInfoDisplay() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString("name")!;
    var bind = prefs.getInt("isBind")!;

    setState(() {

      userName = name;
      if(bind == 1){
        bindStatus = "已绑定";
      }else{
        bindStatus = "未绑定";
      }
    });

  }

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> updateUserInfoDisplay());

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

            appBar: AppBar(
              title: const Text('个人中心'),
              backgroundColor: Colors.teal,
            ),
            body: ListView(
              scrollDirection: Axis.vertical,
              children: [

                Card(
                    elevation: 1,
                    margin: const EdgeInsets.all(4.0),
                    color: Colors.white60,
                    child:Row(
                      children: [
                        Expanded(
                            child: Container(
                              height: 100,
                              alignment: Alignment.center,
                              child: Text(
                                userName,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            )
                        )
                      ],
                    )
                ),
                ListTile(

                  leading: Icon(Icons.wallet_giftcard),
                  title: Text("交易所钱包"),
                  subtitle: Text(bindStatus),
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (content){return ModifyBindPage();}));
                  },
                  trailing: IconButton(
                    icon:Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (content){return BindExchangePage();}));
                    }
                    )
                ),
                ListTile(

                  leading: Icon(Icons.password_outlined),
                  title: Text("修改密码"),
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (content){return ModifyPasswordPage();}));
                  },
                  trailing: IconButton(
                    icon:Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (content){return ModifyPasswordPage();}));
                      })
                ),
                ListTile(
                  leading: Icon(Icons.monetization_on_outlined),
                  title: Text("收益设置"),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (content){return CommonSettingPage();}));
                  },
                  trailing:IconButton(icon:Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: (){

                        Navigator.push(context, MaterialPageRoute(builder: (content){return CommonSettingPage();}));

                      })
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("关于"),
                  onTap: (){
                    showAboutDialog(context);
                  },
                  trailing: IconButton(icon:Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: (){
                      showAboutDialog(context);

                    })
                ),
                ListTile(
                  title: Text("退出登录",style: TextStyle(color: Colors.red)),
                    onTap: () async {
                        SharedPreferences prefs =  await SharedPreferences.getInstance();
                        prefs.clear();
                        Navigator.pop(context);
                        Navigator.push(context,MaterialPageRoute(builder: (content){return LoginPage();}));
                      },
                ),
              ]
            )

    );
  }


}