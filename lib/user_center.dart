import 'package:flutter/material.dart';

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
                  trailing: Icon(Icons.arrow_forward_ios_rounded),

                ),
                ListTile(

                  leading: Icon(Icons.password_outlined),
                  title: Text("修改密码"),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),

                ),
                ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text("通用设置"),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text("关于"),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                ListTile(
                  title: Text("退出登录",style: TextStyle(color: Colors.red)),
                )
              ]
            )

        )

    );
  }


}