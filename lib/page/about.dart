import 'dart:async';

import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  State createState() => AboutState();
}

class AboutState extends State<AboutPage> {


  @override
  void initState(){
    super.initState();

  }



  @override
  Widget build(BuildContext context) {


    return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/blank_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          child:Scaffold(
            backgroundColor: Colors.transparent, //把scaffold的背景色改成透明
            appBar:AppBar(
                title:  Text("关于",style:TextStyle(color: Color(0xff323232),fontSize: 17)),
                backgroundColor: Colors.white70,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon:Image(
                    width:24,
                    height:24,
                    image: AssetImage("images/back.png"),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                )
            ),
            body:Stack(
                alignment:Alignment.center ,
                fit: StackFit.expand, //未定位widget占满Stack整个空间
                children:[

                  Container(
                  margin: EdgeInsets.only(top:180),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[

                        Column(
                        children:[
                          Image(image:AssetImage("images/logo.png"),width:70,height:70),
                          SizedBox(height:15),
                          Text("v1.0",style:TextStyle(fontSize:15,color:Color(0xff6F7781))),
                        ])
                      ]
                  )


            ),
                  Positioned(
                      bottom:22,
                    child:Container(
                        child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Column(
                              children:[
                                Text("by squirrelRao",style:TextStyle(fontSize:14,color:Color(0xff6F7781))),
                                SizedBox(height:5),
                                Text("mail: hqraop@163.com",style:TextStyle(fontSize:12.5,color:Color(0xff6F7781))),
                                SizedBox(height:5),
                                Text("Copyright©2021. All Rights Reserved",style:TextStyle(fontSize:12.5,color:Color(0xff8F97A0))),
                              ])
                        ]
                    )

                ))
            ])
          ));


  }
}



