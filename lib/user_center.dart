import 'package:flutter/material.dart';
import 'package:yakapp/bind_exchange.dart';
import 'package:yakapp/login.dart';
import 'package:yakapp/modify_bind.dart';
import 'package:yakapp/modify_passwd.dart';

class UserCenterPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => UserCenterState();

}

class UserCenterState extends State<UserCenterPage>{


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

        home: Scaffold(

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
                                "134****3248",
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
                  subtitle: Text("已绑定"),
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
                        MaterialPageRoute(builder: (content){return ModifyPasswdPage();}));
                  },
                  trailing: IconButton(
                    icon:Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (content){return ModifyPasswdPage();}));
                      })
                ),
                ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text("通用设置"),
                  trailing:IconButton(icon:Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: (){})
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("关于"),
                  trailing: IconButton(icon:Icon(Icons.arrow_forward_ios_rounded),
                    onPressed: (){

                        showDialog(context: context, builder: (BuildContext context){

                          return  SimpleDialog(
                            title: Text("关于Yak"),
                            children: [

                              SimpleDialogOption(
                                child:Text("版本: v1.0")
                              ),
                              SimpleDialogOption(
                                  child:Text("联系: hqraop@163.com")
                              ),
                              SimpleDialogOption(
                                  child:Text("作者: squirrelRao")
                              )
                            ],
                          );

                        });

                    })
                ),
                ListTile(
                  title: Text("退出登录",style: TextStyle(color: Colors.red)),
                    onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context,MaterialPageRoute(builder: (content){return LoginPage();}));
                      },
                ),
              ]
            )

        )

    );
  }


}