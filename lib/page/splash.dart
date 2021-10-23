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

    int islogin = prefs.get("user_id") == null ? 0 : 1;
    // int islogin = 0;
    if(islogin == 0) {
      islogin = new Random().nextInt(2);
    }
    if(islogin == 0){
      return false;
    }
    prefs.setString("user_id", "1");
    return true;

  }

  void startCountdownTimer() async {

    const oneSec = const Duration(seconds: 1);

    _timer = Timer.periodic(oneSec, (timer){


           var isGetUser = getUserStatus();
           if(_countdownTime < 1){

             timer.cancel();

             setState(() {

               Navigator.pop(context);

               if(isGetUser == false){
                 Navigator.push(context,
                     MaterialPageRoute(builder: (content){return LoginPage();})
                 );
               }else{
                 Navigator.push(context,
                     MaterialPageRoute(builder: (content){return HomePage();})
                 );

             }});

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

    return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: ConstrainedBox(
            constraints: BoxConstraints.expand(),
            child: Stack(fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              Image.network(this.splash_image,fit:BoxFit.fill)
             ]
            )
          )
        )
    );
  }
}



