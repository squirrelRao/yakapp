import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/page/modify_password_page.dart';
import 'package:yakapp/page/bind_exchange.dart';
import 'package:yakapp/page/common_setting.dart';
import 'package:yakapp/page/login.dart';
import 'package:yakapp/page/modify_bind.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';


import 'about.dart';

class UserCenterPage extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => UserCenterState();

}

class UserCenterState extends State<UserCenterPage> {

  String bindStatus = "未绑定";
  String userName = "";
  String userMail = "";
  late BuildContext dialogContext;


  showSyncDialog(BuildContext context,user_id) {

    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          dialogContext = context;
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))
            ),
            contentPadding: EdgeInsets.only(top:23,bottom:23,left:10,right:10),
            title: Text("请选择钱包同步方式",textAlign:TextAlign.center,style:TextStyle(color:Color(0xff221232),fontSize:14,fontWeight: FontWeight.w500)),
            children: [

              SimpleDialogOption(

                child:
                Container(
                    height: 44,
                    decoration: new BoxDecoration(
                      color: Color(0xffF3F5F7),
                      borderRadius: BorderRadius.all(Radius.circular(22)),

                    ),
                    child:Padding(
                        padding:EdgeInsets.only(left:10,right:10),
                        child:
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              Text("增量同步",textAlign:TextAlign.center,style: TextStyle(color: Color(0xff48ABFD),fontSize:14,fontWeight: FontWeight.w400)),

                            ]))),
                onPressed: (){

                  showSimpleNotification(
                      Text("钱包数据同步中..."),
                      duration: Duration(seconds: 1,milliseconds: 200),
                      leading: Icon(Icons.check,color:Colors.white),
                      background: Color(0xff48ABFD));
                  NetClient().post(Configs.syncHistoryApi, {"type":1,"user_id":user_id},
                          (data) {

                        if(data["rc"] == 0){
                          Navigator.pop(dialogContext);
                          showSimpleNotification(
                              Text("钱包数据同步完成"),
                              duration: Duration(seconds: 1,milliseconds: 800),
                              leading: Icon(Icons.check,color:Colors.white),
                              background: Color(0xff48ABFD));
                        }
                      });


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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:[
                              Text("全量同步",textAlign:TextAlign.center,style: TextStyle(color: Color(0xff48ABFD),fontSize:14,fontWeight: FontWeight.w400)),
                            ]))),
                onPressed: (){


                  showSimpleNotification(
                      Text("钱包同步中..."),
                      duration: Duration(seconds: 1,milliseconds: 200),
                      leading: Icon(Icons.check,color:Colors.white),
                      background: Color(0xff48ABFD));
                  NetClient().post(Configs.syncHistoryApi, {"type":2,"user_id":user_id},
                          (data) {

                        if(data["rc"] == 0){
                          Navigator.pop(dialogContext);
                          showSimpleNotification(
                              Text("钱包同步完成"),
                              duration: Duration(seconds: 1,milliseconds: 800),
                              leading: Icon(Icons.check,color:Colors.white),
                              background: Color(0xff48ABFD));
                        }
                      });


                },
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0.0, 10, 0, 0),
                child: Text("有买入时增量，有卖出时全量，全量会重置计算时刻",style: TextStyle(color: Colors.grey,fontSize: 11))
                ,
              )
            ],
          );
        });
  }

  showAboutDialog(BuildContext context) {

    showDialog(
        context: context,
        builder: (BuildContext context) {

              return SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                contentPadding: EdgeInsets.only(top:20,bottom:20,left:10,right:10),

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
                        GestureDetector(
                            child:Container(
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
                          onTap: (){

                          },
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
                       leading:Icon(Icons.sync,size:20,color:Color(0xff48ABFD)),
                       title: Text("钱包同步",style:TextStyle(fontSize:14,color:Color(0xff292D33),fontWeight: FontWeight.w400)),
                       onTap: (){

                         showSyncDialog(context,"");
                       },
                       trailing:IconButton(
                           icon:Image(
                             width:20,
                             height:20,
                             image: AssetImage("images/right_arrow.png"),
                           )
                           ,
                           onPressed: (){




                           })
                   ),
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
                       leading:Image(
                         width:20,
                         height:20,
                         image: AssetImage("images/return.png"),
                       ),
                       title: Text("通用设置",style:TextStyle(fontSize:14,color:Color(0xff292D33),fontWeight: FontWeight.w400)),
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
                    image: AssetImage("images/lock.png"),
                  ),
                  title: Text("密码修改",style:TextStyle(fontSize:14,color:Color(0xff292D33),fontWeight: FontWeight.w400)),
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
                  leading: Image(
                    width:20,
                    height:20,
                    image: AssetImage("images/about.png"),
                  ),
                  title: Text("关于",style:TextStyle(fontSize:14,color:Color(0xff292D33),fontWeight: FontWeight.w400)),
                  onTap: (){
                    //showAboutDialog(context);
                    Navigator.push(context, MaterialPageRoute(builder: (content){return AboutPage();}));

                  },
                  trailing: IconButton(
                      icon:Image(
                        width:20,
                        height:20,
                        image: AssetImage("images/right_arrow.png"),
                      ),
                    onPressed: (){
                      //showAboutDialog(context);
                      Navigator.push(context, MaterialPageRoute(builder: (content){return AboutPage();}));

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