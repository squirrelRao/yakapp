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
  String userMail = "";

  showAboutDialog(BuildContext context) {

    showDialog(
        context: context,
        builder: (BuildContext context) {

              return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                contentPadding: EdgeInsets.only(top:23,bottom:23,left:10,right:10),

                title: Text("Yak",textAlign:TextAlign.center,style:TextStyle(color:Color(0xff221232),fontWeight: FontWeight.w500)),
                children: [

                  SimpleDialogOption(
                      child: Text("V1.0",style:TextStyle(color:Color(0xff221232)))
                  ),
                  SimpleDialogOption(
                  child: Text("hqraop@163.com",style:TextStyle(color:Color(0xff221232)))
                  ),
                  SimpleDialogOption(
                    child: Text("by squirrelRao @2021",style:TextStyle(color:Color(0xff221232)))
                  )
                ],
              );
    });
  }

  void updateUserInfoDisplay() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.getString("name")!;
    var mail = prefs.getString("mail")!;
    var bind = prefs.getInt("isBind")!;

    setState(() {

      userName = name;
      userMail = mail;
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
              Container(
                margin: EdgeInsets.only(top:30),
               child:Row(
                      children: [
                            Container(
                              width: 60.0,
                              height: 60.0,
                              margin: EdgeInsets.only(left:28,top:10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(
                                    "images/logo.png",
                                  ),
                                ),
                              )
                            ),
                        Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                     Text(userMail, style:TextStyle(fontSize:17,color:Color(0xff292D33))),
                                    SizedBox(height:2),
                                    Text(userName,style:TextStyle(fontSize:14,color:Color(0xff6D7580)))

                                ]
                              ),
                              ))
                        )
                      ],
                )),
                  Card(

                    margin: EdgeInsets.only(left:28,right:28,top:30),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child:Column(

                 children:[
                 ListTile(
                     visualDensity: VisualDensity(horizontal: -4),
                      contentPadding: EdgeInsets.only(left:18,right:0),
                     leading: Image(
                    width:20,
                    height:20,
                    image: AssetImage("images/wallet.png"),
                  ),
                  title: Text("交易所钱包",style:TextStyle(fontSize:14,color:Color(0xff292D33),fontWeight: FontWeight.w400)),
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
                    visualDensity: VisualDensity(horizontal: -4),
                    contentPadding: EdgeInsets.only(left:18,right:0),
                  leading: Image(
                    width:20,
                    height:20,
                    image: AssetImage("images/lock.png"),
                  ),
                  title: Text("修改密码",style:TextStyle(fontSize:14,color:Color(0xff292D33),fontWeight: FontWeight.w400)),
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
                    visualDensity: VisualDensity(horizontal: -4),
                    contentPadding: EdgeInsets.only(left:18,right:0),
                  leading:Image(
                    width:20,
                    height:20,
                    image: AssetImage("images/return.png"),
                  ),
                  title: Text("收益设置",style:TextStyle(fontSize:14,color:Color(0xff292D33),fontWeight: FontWeight.w400)),
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
                    visualDensity: VisualDensity(horizontal: -4),
                    contentPadding: EdgeInsets.only(left:18,right:0),
                  leading: Image(
                    width:20,
                    height:20,
                    image: AssetImage("images/about.png"),
                  ),
                  title: Text("关于",style:TextStyle(fontSize:14,color:Color(0xff292D33),fontWeight: FontWeight.w400)),
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
    )),
                Container(
                  height: 70,
                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 0),
                  child: TextButton(
                      child: Text('退出登录'),
                      onPressed: () async {
                        SharedPreferences prefs =  await SharedPreferences.getInstance();
                        prefs.clear();
                        Navigator.pop(context);
                        Navigator.push(context,MaterialPageRoute(builder: (content){return LoginPage();}));
                      },
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 14)),
                          backgroundColor: MaterialStateProperty.all(Color(0xffF3F5F7)),
                          foregroundColor: MaterialStateProperty.all(Color(0xff292D33)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                      22)))
                      ))),
                ]

            )
    );
  }


}