
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';


class AssetSettingPage extends StatefulWidget{

  var asset = "";
  var free = 0.0;
  var price = 0.0;
  var ror = 0.0;
  var free_usdt = 0.0;
  AssetSettingPage({ required this.asset, required this.free, required this.price, required this.ror, required this.free_usdt});

  @override
  State createState()  => AssetSettingState(asset: asset, price : price, free : free, ror : ror, free_usdt :free_usdt);
}

class AssetSettingState extends State<AssetSettingPage>{
  var asset="";
  var price =0.0;
  var free = 0.0;
  var ror = 0.0;
  var free_usdt = 0.0;


  AssetSettingState({required this.asset,required this.price, required this.free, required this.ror,required this.free_usdt});

  var target_ror;
  var t_sell;
  var loweset_ror;
  var l_buy;
  var title = "盈损设置";
  var buy_usdt = 0.0;
  var sell_usdt = 0.0;

  final _formKey = new GlobalKey<FormState>();

  TextEditingController trController = new TextEditingController(text: "");
  TextEditingController tsController = new TextEditingController(text: "");
  TextEditingController lrController = new TextEditingController(text: "");
  TextEditingController lsController = new TextEditingController(text: "");

  Widget showCount() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
      child: Column(
          children:[
      Row(

      children: [
      Text("拥有量: "+Decimal.parse(this.free.toString()).toString(),style:TextStyle(fontSize: 14,color:Color(0xff999999)))
      ],

    )]));

  }

  Widget showRor() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
        child: Column(
            children:[
              Row(

                children: [
                  Text("收益率: "+Decimal.parse(this.ror.toString()).toString()+"%",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
                ],

              )]));

  }

  Widget showFreeUsdt() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0,0),
        child: Column(
            children:[
              Row(

                children: [
                  Text("* 可花费总额: "+Decimal.parse(this.free_usdt.toString()).toString()+" usdt",style:TextStyle(fontSize: 13,color:Color(0xff999999)))
                ],

              )]));

  }

  Widget showPrice() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 12.0),
        child: Column(
            children:[
              Row(

                children: [
                  Text("价格: "+this.price.toString(),style:TextStyle(fontSize: 14,color:Color(0xff999999)))
                ],

              )]));

  }


  Widget showTargetRorInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
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
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[-0-9.]"))
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

          if(double.tryParse(value) == null){
            return "格式错误";
          }

          if(double.parse(value) < 0){
            return "不能小于0";
          }
          target_ror = double.parse(value!.trim());

        },
      ),
    ]));
  }


  Widget showLowestRorInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Column(
      children:[
      Row(

      children: [
      Text("加仓收益率(%)",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
      ],
      ),
      SizedBox(height: 5),
    new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[-0-9.]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: lrController,
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
        onSaved: (value) => loweset_ror = double.parse(value!.trim()),
        validator: (value){
          if(value!.trim()==""){
            return "加仓收益率不能为空";
          }

          if(double.tryParse(value) == null){
            return "格式错误";
          }
          loweset_ror = double.parse(value!.trim());
        },
      ),
    ]));
  }

  Widget showTsellInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0, 0.0),
      child: Column(
          children:[
      Row(

        children: [
          Text("目标达成卖出量 「 约获得 "+Decimal.parse(this.sell_usdt.toStringAsFixed(8)).toString() +" usdt 」",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
        ],
      ),
      SizedBox(height: 5),
      new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: tsController,
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
        onSaved: (value) => t_sell = double.parse(value!.trim()),
        onChanged: (value){

    setState(() {
      if (double.tryParse(value) != null) {
        var _price = 0.0;
        _price = (1 + ( target_ror - this.ror)/100) * this.price;

        this.sell_usdt = double.parse(value)  * _price;
      } else {
        this.sell_usdt = 0.0;
      }
    });

        },
        validator: (value){
          if(value!.trim()==""){
            return "卖出量不能为空";
          }

          if(double.tryParse(value) == null){
            return "格式错误";
          }

       if(double.parse(value) < 0){
            return "须大于0";
          }

          if(double.parse(value) > this.free){
            return "卖出量超过拥有量";
          }
        },
      ),
    ]));
  }


  Widget showLsellInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Column(
          children:[
      Row(

        children: [
          Text("加仓买入量 「 约消耗 "+Decimal.parse(this.buy_usdt.toStringAsFixed(8)).toString()+" usdt 」",style:TextStyle(fontSize: 14,color:Color(0xff999999))),
        ],
      ),
      SizedBox(height: 1.5),
            Row(

              children: [
                Text("( 额度:"+Decimal.parse(this.free_usdt.toString()).toString()+" usdt )",style:TextStyle(fontSize: 13,color:Color(0xff999999)))
              ],
            ),
            SizedBox(height: 5),
            new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: lsController,
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
        onSaved: (value) => l_buy = double.parse(value!.trim()),
        onChanged: (value){

          setState(() {

          if(double.tryParse(value) != null){
            var _price = 0.0;
            _price = (1 + ( loweset_ror - this.ror)/100) * this.price;

          this.buy_usdt = double.parse(value) * _price;
          }else{
            this.buy_usdt = 0.0;
          }

          });

        },
        validator: (value){
          if(value!.trim()==""){
            return "触发加仓收益买入量不能为空";
          }
          if(double.tryParse(value) == null){
            return "格式错误";
          }
          if(double.parse(value) < 0){
            return "须大于0";
          }

          if(double.parse(value) > this.free_usdt){
            return "加仓需要花费的USDT超过可用额度";
          }

        },
      ),
    ]));
  }


  void queryConfigInfo() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getAssetConfigApi, {"user_id":userId,"asset":asset}, (data){

      if(data["rc"] == 0 && data["data"] != ""){
        data = data["data"];

        setState(() {
          this.asset = asset;
          this.title = this.asset + "盈损设置";
          trController.text = Decimal.parse(data["target_ror"].toString()).toString();
          tsController.text = Decimal.parse(data["t_sell"].toString()).toString();
          lrController.text = Decimal.parse(data["lowest_ror"].toString()).toString();
          lsController.text = Decimal.parse(data["l_buy"].toString()).toString();

          var target_price = (1 + ( data["target_ror"] - this.ror)/100) * this.price;
          this.sell_usdt = data["t_sell"] / 100 * this.free * target_price;


          var lowest_price = (1 + ( data["lowest_ror"] - this.ror)/100) * this.price;
          this.buy_usdt = data["l_buy"] * lowest_price;

        });
      }else{
        setState(() {

          trController.text = "";
          tsController.text = "";
          lrController.text = "";
          lsController.text = "";

        });
      }

    });

  }

  void submitConfig(target_ror,t_sell,lowest_ror,l_buy) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.updateAssetConfigApi,
        {"user_id":userId,"asset":asset,"target_ror":target_ror,"t_sell":t_sell,"lowest_ror":lowest_ror,"l_buy":l_buy},
            (data){

          if(data["rc"] == 0){

            showSimpleNotification(
                Text("更新成功"),
                duration: Duration(seconds: 1,milliseconds: 800),
                leading: Icon(Icons.check,color:Colors.white),
                background: Color(0xff48ABFD));

          }else {
            showSimpleNotification(
                Text("更新失败，请重新登录后再设置"),
                duration: Duration(seconds: 1, milliseconds: 800),
                leading: Icon(Icons.error_outline, color: Colors.white),
                background: Color(0xffE95555));
          }

        });
  }

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> queryConfigInfo());
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

          body: GestureDetector(

              behavior: HitTestBehavior.translucent,
            onTap:() {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child:ListView(

            children: <Widget>[

              Form(

                key : _formKey,
                child: Container(

                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 0),
                  child:  Column(
                      children: <Widget>[
                        // showCoin(),
                        showCount(),
                        showRor(),
                        showPrice(),
                        showTargetRorInput(),
                        showTsellInput(),
                        showLowestRorInput(),
                        // showFreeUsdt(),
                        showLsellInput(),
                        SizedBox(height: 10)
                      ]
                    )
                  )
            ),
              Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(32, 26, 32, 0),
                child: TextButton(
                  child: Text('提 交',style:TextStyle(color:Colors.white,fontWeight: FontWeight.w500)),
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
                    submitConfig(target_ror,t_sell,loweset_ror,l_buy);
                  },
                ),
              )

          ],

        )
    ));
  }


}