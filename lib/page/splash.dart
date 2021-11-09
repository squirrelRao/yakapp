import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:yakapp/page/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yakapp/main.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() => SplashState();
}

class SplashState extends State<SplashPage> {

  String? debugLable = 'Unknown';
  final JPush jpush = new JPush();

  Future<bool> getUserStatus() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    var userId = prefs.getString("uid");
    if(userId == null || userId.trim() == ""){
      return false;
    }
    return true;
  }

  void toMainPage(timestamp) async {


          bool isGetUser = await getUserStatus();

          setState(() {

          Widget page;

          if(!isGetUser) {
          page = LoginPage();

          }else{
          page = HomePage();

          }

          Future.delayed(Duration(seconds: 2),(){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (content){return page;}));
          });
          });

  }

  @override
  void initState(){
    super.initState();


    /// 配置jpush(不要省略）
    ///debug就填debug:true，我这是生产环境所以production:true
    jpush.setup(appKey: 'b4ada55c968fb147d2b38701' ,channel: 'developer-default',production: true,debug: false);
    /// 监听jpush
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    jpush.addEventHandler(
      onReceiveNotification: (Map<String, dynamic> message) async {
        print(message);
      },
      onOpenNotification: (Map<String, dynamic> message) async {
        /// 点击通知栏消息，在此时通常可以做一些页面跳转等

      },
    );
    WidgetsBinding.instance!.addPostFrameCallback(toMainPage);

  }



  @override
  Widget build(BuildContext context) {

    return Container(child: Image.asset("images/splash.png",fit:BoxFit.fill));

  }
}



