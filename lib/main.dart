import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yakapp/page/notice.dart';
import 'package:yakapp/page/splash.dart';
import 'package:yakapp/page/transaction.dart';
import 'page/assets.dart';
import 'page/user_center.dart';
import 'util/common_util.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    LogUtil.init(bool.fromEnvironment("dart.vm.product"));
    requestPermission();

    return MaterialApp(
      title: 'Yak',

      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home:SplashPage()
    );
  }

  Future requestPermission() async {

    // startCountdownTimer();


    // 申请存储结果
    if (await Permission.storage.request().isGranted) {

    //  startCountdownTimer();

    }
    else {

      Fluttertoast.showToast(msg: "需要存储权限才能使用");
      SystemNavigator.pop();
    }

  }
}

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  int currentIndex = 0;
  List tabPages = [ AssetsPage(), NoticePage(),TransactionPage(),UserCenterPage()];

  void onTabSelected(index){

     setState(() {
       currentIndex = index;
     });
  }

  @override
  Widget build(BuildContext context) {

    dynamic args = ModalRoute.of(context)!.settings.arguments;
    if( args != null && args["page_index"] != null){
      this.currentIndex = args["page_index"];
      LogUtil.i(args);
      args = null;
    }else{
      LogUtil.i("no args to home page");
    }

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
                icon:Icon(Icons.addchart_rounded),
                label:"新币"
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
