import 'package:flutter/material.dart';

//splash page

class SplashPage extends StatefulWidget {
  @override
  State createState() => SplashState();
}

class SplashState extends State<SplashPage> {
  var splash_image = "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1093264713,2279663012&fm=26&gp=0.jpg";
  var count=5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
        body: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: Stack(fit: StackFit.expand,
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(this.splash_image,fit:BoxFit.fill)
    ])
    ))
    );
  }
}



