import 'package:flutter/material.dart';
import 'package:yakapp/login.dart';
import 'splash.dart';
import 'regist.dart';
import 'bind_exchange.dart';
import 'assets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yak',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Yak'),
      home:HomePage()
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;
  List tabPages = [ AssetsPage(), RegistPage(), BindExchangePage()];

  void onTabSelected(index){
     setState(() {
       currentIndex = index;
     });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
        this.tabPages[currentIndex],

        bottomNavigationBar:BottomNavigationBar(

          currentIndex: this.currentIndex,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          onTap: (index){
            onTabSelected(index);
          },
          items:[
            BottomNavigationBarItem(
              icon:Icon(Icons.home),
              label:"资产"
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.category),
              label:"交易"
            ),
            BottomNavigationBarItem(
                icon:Icon(Icons.settings),
                label:"我的"
            ),
          ]
        ) ,


    );
  }
}
