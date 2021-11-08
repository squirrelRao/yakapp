import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/modify_password_page.dart';
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
            body: ListView(
              scrollDirection: Axis.vertical,
              children: [

               Row(
                      children: [
                        // Expanded(
                        //     child: Container(
                        //       height: 100,
                        //       alignment: Alignment.center,
                        //       child: Image.asset('images/default_avatar.jpeg'),
                        //     )
                        // ),
                        Expanded(
                            child: Container(
                              height: 90,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
                                child:Text(
                                userName,
                                style:TextStyle(fontSize:20,color:Color(0xff292D33)),
                              ),
                              ))
                        )
                      ],
                ),
                 Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child:Card(

                child:Column(

                 children:[
                 ListTile(

                  leading: Image(
                    width:20,
                    height:20,
                    image: AssetImage("images/wallet.png"),
                  ),
                  title: Text("交易所钱包",style:TextStyle(fontSize:14,color:Color(0xff292D33))),
                  subtitle: Text(bindStatus,style:TextStyle(fontSize:11,color:Colors.grey)),
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (content){return ModifyBindPage();}));
                  },
                  trailing: IconButton(
                    icon:Image(
                      width:20,
                      height:20,
                      image: AssetImage("images/right_arrow.png"),
                    ),
                    onPressed: (){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (content){return BindExchangePage();}));
                    }
                    )
                ),
                ListTile(

                  leading: Image(
                    width:20,
                    height:20,
                    image: AssetImage("images/lock.png"),
                  ),
                  title: Text("修改密码",style:TextStyle(fontSize:14,color:Color(0xff292D33))),
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (content){return ModifyPasswordPage();}));
                  },
                  trailing: IconButton(
                      icon:Image(
                        width:20,
                        height:20,
                        image: AssetImage("images/right_arrow.png"),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (content){return ModifyPasswordPage();}));
                      })
                ),
                ListTile(
                  leading:Image(
                    width:20,
                    height:20,
                    image: AssetImage("images/return.png"),
                  ),
                  title: Text("收益设置",style:TextStyle(fontSize:14,color:Color(0xff292D33))),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (content){return CommonSettingPage();}));
                  },
                  trailing:IconButton(
                      icon:Image(
                        width:20,
                        height:20,
                        image: AssetImage("images/right_arrow.png"),
                      )
                  ,
                      onPressed: (){

                        Navigator.push(context, MaterialPageRoute(builder: (content){return CommonSettingPage();}));

                      })
                ),
                ListTile(
                  leading: Image(
                    width:20,
                    height:20,
                    image: AssetImage("images/about.png"),
                  ),
                  title: Text("关于",style:TextStyle(fontSize:14,color:Color(0xff292D33))),
                  onTap: (){
                    showAboutDialog(context);
                  },
                  trailing: IconButton(
                      icon:Image(
                        width:20,
                        height:20,
                        image: AssetImage("images/right_arrow.png"),
                      ),
                    onPressed: (){
                      showAboutDialog(context);

                    })
                )]
    ))),
                Container(
                  height: 60,
                  padding: const EdgeInsets.fromLTRB(65, 20, 65, 0),
                  child: TextButton(
                      child: Text('退出登录'),
                      onPressed: () async {
                        SharedPreferences prefs =  await SharedPreferences.getInstance();
                        prefs.clear();
                        Navigator.pop(context);
                        Navigator.push(context,MaterialPageRoute(builder: (content){return LoginPage();}));
                      },
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                          backgroundColor: MaterialStateProperty.all(Color(0x4fD3D3D3)),
                          foregroundColor: MaterialStateProperty.all(Colors.black26),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      40)))
                      ))),
                ]

            )
    );
  }


}