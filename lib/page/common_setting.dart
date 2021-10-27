
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

  var ror_touch = "auto";
  var ror_duration = 7.0;

  final _formKey = new GlobalKey<FormState>();

  TextEditingController durationController = new TextEditingController(text: "");


  Widget showDurationInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
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
            border: InputBorder.none,
            hintText: '',
            labelText: "收益累计周期 (推荐: 7或30天)",
            icon: new Icon(
              Icons.arrow_forward,
              color: Colors.teal,
            )),
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
    );
  }


  Widget showActionInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child:Column(children: [
        Row(
          children:[
            SizedBox(width: 0),
            Text("当目标收益达成或触发止损时:")
          ],
        ),
      Column(
        children: <Widget>[
          Row(children:[
          Radio(
            // 按钮的值
            value: "auto",
            // 改变事件
            onChanged: (value){
              setState(() {
                ror_touch = value.toString();
              });
            },
            // 按钮组的值
            groupValue:ror_touch,
          ),
          Text("自动卖出设定比例并发送提醒",style: TextStyle(fontSize: 13))
    ]),
          Row(children:[
          Radio(
            value:"notify",
            onChanged: (value){
              setState(() {
                ror_touch = value.toString();
              });
            },
            groupValue:ror_touch,
          ),
          Text("只发送提醒",style: TextStyle(fontSize: 13))
  ]),
           Row(
               children:[
               Radio(
              value:"non",
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
      )
    ]),
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


        });
      }else{
        setState(() {


        });
      }

    });

  }

  void submitConfig(ror_duration,ror_touch) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.updateUserConfigApi,
        {"user_id":userId,"ror_duration":ror_duration,"ror_touch":ror_touch},
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
            title: const Text('收益设置'),
              backgroundColor: Colors.teal,
              leading: IconButton(
                icon:Icon(Icons.arrow_back_ios,color:Colors.white),
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

                  padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        showDurationInput(),
                        showActionInput(),
                        SizedBox(height: 10)
                      ]
                    )
                  )

                )


            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                child: TextButton(
                  child: Text('提 交'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                    foregroundColor: MaterialStateProperty.all(Colors.white)
                ),
                  onPressed: () {

                    if(!_formKey.currentState!.validate()){

                       return;
                    }

                    _formKey.currentState!.save();
                    submitConfig(ror_duration,ror_touch);
                  },
                ),
              )

          ],

        )
    );
  }


}