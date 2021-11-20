
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';

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
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: Column(
          children:[
      Row(
      children:[
          Text("收益累计周期 (推荐: 7或30天)",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14))
        ]),
      SizedBox(height: 5),
      new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: durationController,
        style: TextStyle(fontSize: 15),
        cursorColor: Color(0xff48ABFD),
        cursorHeight: 16,
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
          fillColor: Color(0xffF3F5F7),
        ),
        onSaved: (value) => ror_duration = double.parse(value!.trim()),
        onTap: (){
          durationController.text="";
        },
        validator: (value){
          if(value!.trim()==""){
            return "不能为空";
          }

          if(double.tryParse(value) == null){
            return "格式错误";
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
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child:Column(children: [
        Row(
          children:[
            SizedBox(width: 0),
            Text("目标收益达成时:",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14))
          ],
        ),
      Card(
        color:Color(0xffF3F5F7),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(22.0)),),
      child: Column(
        children: <Widget>[
          Row(children:[
          Radio(
            // 按钮的值
            value: "auto_limit",
            activeColor: Color(0xff48ABFD),
            // 改变事件
            onChanged: (value){
              setState(() {
                ror_touch = value.toString();
              });
            },
            // 按钮组的值
            groupValue:ror_touch,
          ),
          Text("限价卖出 (收益触达时价格)",style: TextStyle(fontSize: 14,color:Color(0xff292D33)))
    ]),
          Row(children:[
            Radio(
              // 按钮的值
              value: "auto_market",
              activeColor: Color(0xff48ABFD),
              // 改变事件
              onChanged: (value){
                setState(() {
                  ror_touch = value.toString();
                });
              },
              // 按钮组的值
              groupValue:ror_touch,
            ),
            Text("市价卖出  (最新市场价格）",style: TextStyle(fontSize: 14,color:Color(0xff292D33)))
          ]),
          Row(children:[
          Radio(
            value:"notify",
            activeColor: Color(0xff48ABFD),
            onChanged: (value){
              setState(() {
                ror_touch = value.toString();
              });
            },
            groupValue:ror_touch,
          ),
          Text("发送提醒",style: TextStyle(fontSize: 14,color:Color(0xff292D33)))
  ]),
           Row(
               children:[
               Radio(
              value:"non",
                 activeColor: Color(0xff48ABFD),
                 onChanged: (value){
                setState(() {
                  ror_touch = value.toString();
                });
              },
            groupValue: ror_touch,
          ),
          Text("无操作",style: TextStyle(fontSize: 14,color:Color(0xff292D33)))
           ])
        ],
      ) )
    ]),
    );
  }

  Widget showLActionInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child:Column(children: [
        Row(
          children:[
            SizedBox(width: 0),
            Text("加仓收益达成时:",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14))
          ],
        ),
    Card(
        color:Color(0xffF3F5F7),
    elevation: 0,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(22.0))),
    child:Column(
          children: <Widget>[
            Row(children:[
              Radio(
                // 按钮的值
                value: "auto_limit",
                activeColor: Color(0xff48ABFD),
                // 改变事件
                onChanged: (value){
                  setState(() {
                    l_ror_touch = value.toString();
                  });
                },
                // 按钮组的值
                groupValue:l_ror_touch,
              ),
              Text("限价买入 (收益触达时价格)",style: TextStyle(fontSize: 14,color:Color(0xff292D33)))
            ]),
            Row(children:[
              Radio(
                value:"auto_market",
                activeColor: Color(0xff48ABFD),
                onChanged: (value){
                  setState(() {
                    l_ror_touch = value.toString();
                  });
                },
                groupValue:l_ror_touch,
              ),
              Text("市价买入 (最新市场价格）",style: TextStyle(fontSize: 14,color:Color(0xff292D33)))
            ]),
            Row(children:[
              Radio(
                value:"notify",
                activeColor: Color(0xff48ABFD),
                onChanged: (value){
                  setState(() {
                    l_ror_touch = value.toString();
                  });
                },
                groupValue:l_ror_touch,
              ),
              Text("发送提醒",style: TextStyle(fontSize: 14,color:Color(0xff292D33)))
            ]),
            Row(
                children:[
                  Radio(
                    value:"non",
                    activeColor: Color(0xff48ABFD),
                    onChanged: (value){
                      setState(() {
                        l_ror_touch = value.toString();
                      });
                    },
                    groupValue: l_ror_touch,
                  ),
                  Text("无操作",style: TextStyle(fontSize: 14,color:Color(0xff292D33)))
                ])
          ],
        ))
      ]),
    );
  }

  Widget showNewCoinNotifySwitch(){

    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 0.0),
        child:Column(children:[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text("新币上市提醒:",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14)),
            Switch(
                value: new_coin_notify,
                activeColor: Color(0xff48ABFD),
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

          durationController.text = Decimal.parse(data["ror_duration"].toString()).toString();
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

            showSimpleNotification(
                Text("更新成功"),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.check,color:Colors.white),
                background: Color(0xff48ABFD));

          }else{
            showSimpleNotification(
                Text("更新失败，请重新登录后再设置"),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.error_outline,color:Colors.white),
                background: Color(0xffE95555));
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
            title: const Text('通用设置',style:TextStyle(color: Color(0xff323232),fontSize: 17)),
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

          body:  GestureDetector(

    behavior: HitTestBehavior.translucent,
    onTap:() {
    FocusScope.of(context).requestFocus(FocusNode());
    },
    child:ListView(

            children: <Widget>[

              Form(

                key : _formKey,
                child: Container(
                  color: Color(0xffffffff),
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                  child: Column(
                      children: <Widget>[
                        showDurationInput(),
                        showActionInput(),
                        showLActionInput(),
                        showNewCoinNotifySwitch(),
                        SizedBox(height:5)
                      ]
                    )
                  )
            ),
              Container(
                color: Colors.white,
                height: 40,
                padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                child: TextButton(
                  child: Text('提 交'),
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                      backgroundColor: MaterialStateProperty.all(Color(0xff48ABFD)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  40)))
                  ),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());

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
    ));
  }


}