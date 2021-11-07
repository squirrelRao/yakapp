
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';

class CommonSettingPage extends StatefulWidget{

  CommonSettingPage();

  @override
  State createState()  => CommonSettingState();
}

class CommonSettingState extends State<CommonSettingPage>{

  CommonSettingState();

  var ror_touch = "notify";
  var l_ror_touch = "notify";
  var ror_duration = 7.0;
  bool new_coin_notify = true;

  final _formKey = new GlobalKey<FormState>();

  TextEditingController durationController = new TextEditingController(text: "");


  Widget showDurationInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
      child: Column(
          children:[
          SizedBox(height: 10),
      Row(

        children: [
          Text("收益累计周期 (推荐: 7或30天)")
        ],
      ),
      SizedBox(height: 10),
      new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: durationController,
        style: TextStyle(fontSize: 16),
        decoration: new InputDecoration(
          hintText: "",
          labelText: "",
          border:OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none
          ),
          ///设置内容内边距
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          filled: true,
          fillColor: Color(0x4fD3D3D3),
        ),
        onSaved: (value) => ror_duration = double.parse(value!.trim()),
        onTap: (){
          durationController.text="";
        },
        validator: (value){
          if(value!.trim()==""){
            return "不能为空";
          }

          if(double.parse(value) < 1 || double.parse(value) > 365){
            return "范围为1到365";
          }
        },
      ),
    ]));
  }


  Widget showActionInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
      child:Column(children: [
        Row(
          children:[
            SizedBox(width: 0),
            Text("目标收益达成时:")
          ],
        ),
      Card(
        color:Color(0xfff5f5f5),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),),
      child: Column(
        children: <Widget>[
          Row(children:[
          Radio(
            // 按钮的值
            value: "auto_limit",
            activeColor: Color(0xd33094FE),
            // 改变事件
            onChanged: (value){
              setState(() {
                ror_touch = value.toString();
              });
            },
            // 按钮组的值
            groupValue:ror_touch,
          ),
          Text("限价自动卖出",style: TextStyle(fontSize: 13))
    ]),
          Row(children:[
            Radio(
              // 按钮的值
              value: "auto_market",
              activeColor: Color(0xd33094FE),
              // 改变事件
              onChanged: (value){
                setState(() {
                  ror_touch = value.toString();
                });
              },
              // 按钮组的值
              groupValue:ror_touch,
            ),
            Text("市价自动卖出",style: TextStyle(fontSize: 13))
          ]),
          Row(children:[
          Radio(
            value:"notify",
            activeColor: Color(0xd33094FE),
            onChanged: (value){
              setState(() {
                ror_touch = value.toString();
              });
            },
            groupValue:ror_touch,
          ),
          Text("发送提醒",style: TextStyle(fontSize: 13))
  ]),
           Row(
               children:[
               Radio(
              value:"non",
                 activeColor: Color(0xd33094FE),
                 onChanged: (value){
                setState(() {
                  ror_touch = value.toString();
                });
              },
            groupValue: ror_touch,
          ),
          Text("不执行任何操作",style: TextStyle(fontSize: 13))
           ])
        ],
      ) )
    ]),
    );
  }

  Widget showLActionInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
      child:Column(children: [
        Row(
          children:[
            SizedBox(width: 0),
            Text("最低收益达成时:")
          ],
        ),
    Card(
    color:Color(0xfff5f5f5),
    elevation: 0,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20.0))),
    child:Column(
          children: <Widget>[
            Row(children:[
              Radio(
                // 按钮的值
                value: "auto_limit",
                activeColor: Color(0xd33094FE),
                // 改变事件
                onChanged: (value){
                  setState(() {
                    l_ror_touch = value.toString();
                  });
                },
                // 按钮组的值
                groupValue:l_ror_touch,
              ),
              Text("限价自动卖出",style: TextStyle(fontSize: 13))
            ]),
            Row(children:[
              Radio(
                value:"auto_market",
                activeColor: Color(0xd33094FE),
                onChanged: (value){
                  setState(() {
                    l_ror_touch = value.toString();
                  });
                },
                groupValue:l_ror_touch,
              ),
              Text("市价自动卖出",style: TextStyle(fontSize: 13))
            ]),
            Row(children:[
              Radio(
                value:"notify",
                activeColor: Color(0xd33094FE),
                onChanged: (value){
                  setState(() {
                    l_ror_touch = value.toString();
                  });
                },
                groupValue:l_ror_touch,
              ),
              Text("发送提醒",style: TextStyle(fontSize: 13))
            ]),
            Row(
                children:[
                  Radio(
                    value:"non",
                    activeColor: Color(0xd33094FE),
                    onChanged: (value){
                      setState(() {
                        l_ror_touch = value.toString();
                      });
                    },
                    groupValue: l_ror_touch,
                  ),
                  Text("不执行任何操作",style: TextStyle(fontSize: 13))
                ])
          ],
        ))
      ]),
    );
  }

  Widget showNewCoinNotifySwitch(){

    return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
        child:Column(children:[
        Row(
          children:[
            Text("新币上市提醒:"),
            SizedBox(width: 130),
            Switch(
                value: new_coin_notify,
                activeColor: Color(0xd33094FE),
                onChanged: (value) {
                  setState(() {
                    new_coin_notify = value;
                  });
                })
          ],
        ),
        ])
    );

  }

  void queryUserInfo() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getUserInfo, {"user_id":userId}, (data){

      if(data["rc"] == 0 && data["data"] != ""){
        data = data["data"];

        setState(() {

          durationController.text = data["ror_duration"].toString();
          ror_touch = data["ror_touch"];
          l_ror_touch = data["l_ror_touch"];
          if(data["new_coin_notify"]==1){
              new_coin_notify = true;
          }else{
              new_coin_notify = false;
          }

        });
      }else{
        setState(() {


        });
      }

    });

  }

  void submitConfig(ror_duration,ror_touch,l_ror_touch) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");

    var isNotifyNewCoin = 1;
    if(new_coin_notify == false){
      isNotifyNewCoin = 0;
    }

    (NetClient()).post(Configs.updateUserConfigApi,
        {"user_id":userId,"ror_duration":ror_duration,"ror_touch":ror_touch,"l_ror_touch":l_ror_touch,"new_coin_notify":isNotifyNewCoin},
            (data){

          if(data["rc"] == 0){

            Fluttertoast.showToast(msg: "更新成功");

          }else{
            Fluttertoast.showToast(msg: "更新失败，请重新登录后再设置");

          }

        });
  }

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> queryUserInfo());
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

          appBar:AppBar(
            title: const Text('收益设置',style:TextStyle(color:Colors.black)),
              backgroundColor: Colors.white70,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.black),
                onPressed: () async {
                    Navigator.pop(context);
                },
              )
          ),

          body: ListView(

            children: <Widget>[

              Form(

                key : _formKey,
                child: Container(

                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Column(
                      children: <Widget>[
                        showDurationInput(),
                        showActionInput(),
                        showLActionInput(),
                        showNewCoinNotifySwitch(),
                        SizedBox(height: 10)
                      ]
                    )
                  )
            ),
              Container(
                height: 40,
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: TextButton(
                  child: Text('提 交'),
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                      backgroundColor: MaterialStateProperty.all(Color(0xd33094FE)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  40)))
                  ),
                  onPressed: () {

                    if(!_formKey.currentState!.validate()){

                       return;
                    }

                    _formKey.currentState!.save();
                    submitConfig(ror_duration,ror_touch,l_ror_touch);
                  },
                ),
              )

          ],

        )
    );
  }


}