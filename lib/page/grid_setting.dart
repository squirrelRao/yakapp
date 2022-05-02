
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';
import 'package:overlay_support/overlay_support.dart';


class GridSettingPage extends StatefulWidget{

  var gid = "";
  GridSettingPage({required this.gid});

  @override
  State createState()  => GridSettingState(gid:gid);
}

class GridSettingState extends State<GridSettingPage>{
  var gid = "";
  var asset="";
  var low_price = 0.0;
  var high_price = 0.0;
  var qty = 0.0;

  GridSettingState({required this.gid});

  var title = "网格设置";

  final _formKey = new GlobalKey<FormState>();

  TextEditingController assetController = new TextEditingController(text: "");
  TextEditingController lowPriceController = new TextEditingController(text: "");
  TextEditingController highPriceController = new TextEditingController(text: "");
  TextEditingController qtyController = new TextEditingController(text: "");


  Widget showAssetInput() {
    return gid.length > 0  ?
    Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Column(
            children:[
              SizedBox(height: 0),
            ])
    ) :
    Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Column(
            children:[
              Row(
                  children:[
                    Text("网格资产（例如: BTC)",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14))
                  ]),
              SizedBox(height: 5),
              new TextFormField(
                maxLines: 1,
                keyboardType: TextInputType.text,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: assetController,
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
                onSaved: (value) => asset = value!.trim(),
                onTap: (){
                  assetController.text="";
                },
                validator: (value){
                  if(value!.trim()==""){
                    return "目标资产不能为空";
                  }
                },
              ),
            ]));
  }


  Widget showLowPrice() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: Column(
          children:[
      Row(

        children: [
          Text("低点价格",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
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
        controller: lowPriceController,
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
        onSaved: (value) => low_price = double.parse(value!.trim()),
        onChanged: (value){
        },
        validator: (value){
          if(value!.trim()==""){
            return "低点价格不能为空";
          }

          if(double.tryParse(value) == null){
            return "格式错误";
          }
        },
      ),
    ]));
  }


  Widget showHighPrice() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: Column(
            children:[
              Row(

                children: [
                  Text("高点价格",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
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
                controller: highPriceController,
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
                onSaved: (value) => low_price = double.parse(value!.trim()),
                onChanged: (value){
                },
                validator: (value){
                  if(value!.trim()==""){
                    return "高点价格不能为空";
                  }

                  if(double.tryParse(value) == null){
                    return "格式错误";
                  }
                },
              ),
            ]));
  }


  Widget showQtyInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0, 0.0),
      child: Column(
          children:[
      Row(

          children: [
            Text("条件达成买入卖出量",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
          ]),
       SizedBox(height: 5),
      new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: qtyController,
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
        onSaved: (value) => qty = double.parse(value!.trim()),
        onChanged: (value){

        },
        validator: (value){
          if(value!.trim()==""){
            return "买入卖出量不能为空";
          }

          if(double.tryParse(value) == null){
            return "格式错误";
          }

       if(double.parse(value) < 0){
            return "须大于0";
          }
        },
      ),
    ]));
  }

  void queryGridInfo() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getUserGridDetail, {"gid":gid}, (data){

      if(data["rc"] == 0 && data["data"] != ""){
        data = data["data"];

        setState(() {
          this.asset = data["symbol"];
          this.title = this.asset + "网格设置";
          assetController.text = asset;
          lowPriceController.text = Decimal.parse(data["low_price"].toString()).toString();
          highPriceController.text = Decimal.parse(data["high_price"].toString()).toString();
          qtyController.text = Decimal.parse(data["qty"].toString()).toString();

        });
      }else{
        setState(() {

          lowPriceController.text = "";
          highPriceController.text = "";
          qtyController.text = "";

        });
      }

    });

  }

  void submitGrid(asset,low_price,high_price,qty) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.modifyUserGrid,
        {"user_id":userId,"asset":asset,"low_price":low_price,"high_price":high_price,"qty":qty},
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

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> queryGridInfo());
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
                        showAssetInput(),
                        showLowPrice(),
                        showHighPrice(),
                        showQtyInput(),
                        SizedBox(height: 2)
                      ]
                    )
                  )
            ),

              Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(32, 22, 32, 0),
                child: TextButton(
                  child: Text('提交设置',style:TextStyle(color:Colors.white,fontWeight: FontWeight.w500)),
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
                    submitGrid(asset,low_price,high_price,qty);
                  },
                ),
              )

          ],

        )
    ));
  }


}