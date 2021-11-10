
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';

class  CreatePreOrderPage extends StatefulWidget{

  var asset = "";
  var open_time = "";
  CreatePreOrderPage({ required this.asset, required this.open_time});

  @override
  State createState()  => CreatePreOrderState(asset:asset,open_time:open_time);
}

class CreatePreOrderState extends State<CreatePreOrderPage>{

  CreatePreOrderState({required this.asset, required this.open_time}){

    this.asset = asset;
    this.title = asset+"预购订单设置";
    this.open_time = open_time;
  }
  var open_time;
  var asset="";
  var buy_count;
  var target_ror;
  var t_sell;
  var loweset_ror;
  var l_sell;
  var title = "";
  var order_type = "MARKET";
  var price_coin = "USDT";

  final _formKey = new GlobalKey<FormState>();

  TextEditingController trController = new TextEditingController(text: "");
  TextEditingController tsController = new TextEditingController(text: "");
  TextEditingController lrController = new TextEditingController(text: "");
  TextEditingController lsController = new TextEditingController(text: "");
  TextEditingController buyCountController = new TextEditingController(text: "");


  Widget showCoin() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: Text(asset,style: TextStyle(fontSize: 20,color:Colors.teal))
    );
  }

  Widget showSymbol() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
        child: Text(asset+"/USDT",style: TextStyle(fontSize: 20,color:Colors.teal))
    );
  }

  Widget showOpenTime() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new Text(open_time+"以最新市价买入",style:TextStyle(fontSize: 14.5,color:Color(0xff48ABFD))),
    );
  }

  Widget showBuyCountInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15.0, 0.0, 0.0),
      child: Column(
          children:[
      Row(

        children: [
          Text("购买个数",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
        ],
      ),
      SizedBox(height: 5),
      new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: buyCountController,
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
        onSaved: (value) => buy_count = double.parse(value!.trim()),
        validator: (value){
          if(value!.trim()==""){
            return "购买个数不能为空";
          }

          if(double.parse(value) <= 0){
            return "范围为必须大于0";
          }
        },
      ),
    ]));
  }

  Widget showTargetRorInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Column(
          children:[
      Row(

        children: [
          Text("目标收益率(%)",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
        ],
      ),
      SizedBox(height: 5),
      new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: trController,
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
        onSaved: (value) => target_ror = double.parse(value!.trim()),
        validator: (value){
          if(value!.trim()==""){
            return "目标收益率不能为空";
          }

          if(double.parse(value) < 0 || double.parse(value) > 100){
            return "范围为0到100";
          }
        },
      ),
    ]));
  }

  Widget showLowestRorInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0.0),
      child: Column(
          children:[
      Row(

        children: [
          Text("止损收益率(%)",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
        ],
      ),
      SizedBox(height: 5),
      new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: lrController,
        style: TextStyle(fontSize: 15),
        cursorColor: Color(0xff48ABFD),
        cursorHeight: 16,        decoration: new InputDecoration(
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
        onSaved: (value) => loweset_ror = double.parse(value!.trim()),
        validator: (value){
          if(value!.trim()==""){
            return "止损收益率不能为空";
          }

          if(double.parse(value) < 0 || double.parse(value) > 100){
            return "范围为0到100";
          }
        },
      ),
    ]));
  }

  Widget showTsellInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15.0, 0.0, 0.0),
      child: Column(
          children:[
      Row(

        children: [
          Text("目标达成卖出比例(%)",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
        ],
      ),
      SizedBox(height: 5),
      new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: tsController,
        style: TextStyle(fontSize: 15),
        cursorColor: Color(0xff48ABFD),
        cursorHeight: 16,        decoration: new InputDecoration(
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
        onSaved: (value) => t_sell = double.parse(value!.trim()),
        validator: (value){
          if(value!.trim()==""){
            return "目标达成卖出比不能为空";
          }

          if(double.parse(value) < 0 || double.parse(value) > 100){
            return "范围为0到100";
          }
        },
      ),
    ]));
  }


  Widget showLsellInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15.0, 0.0, 0.0),
      child:  Column(
          children:[
        Row(

          children: [
            Text("止损触发卖出比例(%)",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
          ],
        ),
        SizedBox(height: 5),
    new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: lsController,
      style: TextStyle(fontSize: 15),
      cursorColor: Color(0xff48ABFD),
      cursorHeight: 16,    decoration: new InputDecoration(
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
        onSaved: (value) => l_sell = double.parse(value!.trim()),
        validator: (value){
          if(value!.trim()==""){
            return "触发止损收益卖出比不能为空";
          }

          if(double.parse(value) < 0 || double.parse(value) > 100){
            return "范围为0到100";
          }
        },
      ),
    ]));
  }


  void queryPreOrderInfo() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getPreBuyOrderApi, {"user_id":userId,"asset":asset}, (data){

      if(data["rc"] == 0 && data["data"] != ""){
        data = data["data"];

        setState(() {
          trController.text = data["target_ror"].toString();
          tsController.text = data["t_sell"].toString();
          lrController.text = data["lowest_ror"].toString();
          lsController.text = data["l_sell"].toString();
          buyCountController.text = data["buy_count"].toString();

        });
      }else{
        setState(() {

          trController.text = "";
          tsController.text = "";
          lrController.text = "";
          lsController.text = "";
          buyCountController.text = "";

        });
      }

    });

  }

  void submitPreBuyOrder(asset,buy_count,open_time,target_ror,t_sell,lowest_ror,l_sell) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");

    open_time = open_time.toString().replaceAll("年", "-").replaceAll("月", "-").replaceAll("日", " ");
    open_time += ":00";

    (NetClient()).post(Configs.updatePreBuyOrderApi ,
        {"user_id":userId,"asset":asset,"buy_count":buy_count,"buy_time":open_time,"target_ror":target_ror,"t_sell":t_sell,"lowest_ror":lowest_ror,"l_sell":l_sell},
            (data){

          if(data["rc"] == 0){

            if(buy_count == 0){
              setState(() {
                buyCountController.text = "0";
              });
            }

            var msg = "撤销成功";
            if(buy_count > 0){
              msg = "预购成功";
            }

            showSimpleNotification(
                Text(msg),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.check,color:Colors.white),
                background: Color(0xff48ABFD));

          }else{

            var msg = "撤销失败，请重新登录后再设置";
            if(buy_count > 0){
              msg = "撤销成功，请重新登录后再设置";
            }
            showSimpleNotification(
                Text(msg),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.error_outline,color:Colors.white),
                background: Color(0xffE95555));

          }

        });
  }

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> queryPreOrderInfo());
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

          appBar:AppBar(
            title:  Text(title,style:TextStyle(color: Color(0xff323232),fontSize: 17)),
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

          body: ListView(

            children: <Widget>[

              Form(

                key : _formKey,
                child: Container(

                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 0),
                  child:Column(
                      children: <Widget>[
                        // showSymbol(),
                        showBuyCountInput(),
                        showTargetRorInput(),
                        showTsellInput(),
                        showLowestRorInput(),
                        showLsellInput(),
                        showOpenTime(),
                      ]
                  )

                )


            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(32, 26, 32, 0),
                child: Row(
                  children:[
                    Expanded(
                    child:TextButton(
                      child: Text('撤销预购'),
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16)),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          foregroundColor: MaterialStateProperty.all(Colors.blueGrey)
                      ),
                      onPressed: () {

                        submitPreBuyOrder(asset,0,open_time,0,0,0,0);
                      },
                    )),
                    SizedBox(width: 20),
                    Expanded(
                    child:TextButton(
                      child: Text('提交预购'),
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),
                          backgroundColor: MaterialStateProperty.all(Color(0xff48ABFD)),
                          foregroundColor: MaterialStateProperty.all(Colors.white)
                      ),
                      onPressed: () {

                        if(!_formKey.currentState!.validate()){

                          return;
                        }

                        _formKey.currentState!.save();
                        buy_count = 0;
                        submitPreBuyOrder(asset,buy_count,open_time,target_ror,t_sell,loweset_ror,l_sell);
                      },
                    ),
                    )]
                )
                )
            ],

        )
    );
  }


}