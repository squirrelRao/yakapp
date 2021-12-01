import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yakapp/page/fit_value.dart';
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

    return OverlaySupport.global(child:MaterialApp(
      title: 'Yak',
       debugShowCheckedModeBanner: false,
      home:SplashPage()
    ));


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
  List tabPages = [ AssetsPage(),FitValuePage(),TransactionPage(),NoticePage(),UserCenterPage()];

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
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xff48ABFD),
          selectedLabelStyle: TextStyle(fontSize: 11),
          unselectedLabelStyle: TextStyle(fontSize: 11,color:Color(0xff707881)),
          onTap: (index){
            onTabSelected(index);
          },
          items:[
            BottomNavigationBarItem(
              icon:Image(
                width:22,
                height:22,
                image: AssetImage("images/asset.png"),
              ),
              activeIcon: Image(
                width:22,
                height:22,
                image: AssetImage("images/asset_active.png"),
              ),
              label:"资产"
            ),
            BottomNavigationBarItem(
                icon:Icon(Icons.analytics_outlined,size:22,color:Color(0xff636A72)),
                activeIcon: Icon(Icons.analytics_outlined,size:22,color:Color(0xff48ABFD)),
                label:"分析"
            ),

            BottomNavigationBarItem(
                icon:Image(
                  width:22,
                  height:22,
                  image: AssetImage("images/notice.png"),
                ),
                activeIcon: Image(
                  width:22,
                  height:22,
                  image: AssetImage("images/notice_active.png"),
                ),
                label:"新币"
            ),
            BottomNavigationBarItem(
                icon:Image(
                  width:22,
                  height:22,
                  image: AssetImage("images/transaction.png"),
                ),
                activeIcon: Image(
                  width:22,
                  height:22,
                  image: AssetImage("images/transaction_active.png"),
                ),
                label:"交易"
            ),
            BottomNavigationBarItem(
                icon:Image(
                  width:22,
                  height:22,
                  image: AssetImage("images/user_center.png"),
                ),
                activeIcon: Image(
                  width:22,
                  height:22,
                  image: AssetImage("images/user_center_active.png"),
                ),
                label:"我的"
            ),
          ]
        ) ,


    );


  }
}
