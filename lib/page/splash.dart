import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yakapp/page/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yakapp/main.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() => SplashState();
}

class SplashState extends State<SplashPage> {

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

          Future.delayed(Duration(seconds: 3),(){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (content){return page;}));
          });
          });

  }

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback(toMainPage);

  }



  @override
  Widget build(BuildContext context) {

    return Container(
        child: Image.asset("images/splash.jpg",fit:BoxFit.cover)
    );
  }
}



