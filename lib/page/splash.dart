import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yakapp/page/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:yakapp/main.dart';class SplashPage extends StatefulWidget {
  @override
  State createState() => SplashState();
}

class SplashState extends State<SplashPage> {
  var splash_image = "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1093264713,2279663012&fm=26&gp=0.jpg";
  var _countdownTime = 2;
  late Timer _timer;



  Future<bool> getUserStatus() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("userid");
    if(userId == null || userId.trim() == ""){
      return false;
    }

    return true;

  }

  void startCountdownTimer() {

    const oneSec = const Duration(seconds: 1);

    _timer = Timer.periodic(oneSec, (timer) async{


           if(_countdownTime < 1){

             timer.cancel();
             bool isGetUser = await getUserStatus();

             setState(() {

               Widget page;

               if(!isGetUser) {
                 page = LoginPage();

               }else{
                 page = HomePage();

               }
               Navigator.pop(context);

               Navigator.push(context, MaterialPageRoute(builder: (content){return page;}));
               });

           }else{
             _countdownTime--;
           }
      });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    startCountdownTimer();

    return ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Image.network(this.splash_image, fit: BoxFit.fill)
            ]
        )
    );
  }
}



