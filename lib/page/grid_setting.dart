
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
  var is_open = true;
  var est_ror = "";
  var est_value = "";

  GridSettingState({required this.gid});

  var title = "创建网格";

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
          if(double.tryParse(value) != null){
            low_price = double.parse(value!.trim());
          }
        },
        validator: (value){
          if(value!.trim()==""){
            return "低点价格不能为空";
          }

          if(double.tryParse(value) == null){
            return "格式错误";
          }

          if(double.tryParse(value)! <= 0){
            return "低点价格须大于0";
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
                  Text("高点价格 「 预计收益: "+this.est_ror+"% 」",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
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
                onSaved: (value) => high_price = double.parse(value!.trim()),
                onChanged: (value){
                },
                validator: (value){
                  if(value!.trim()==""){
                    return "高点价格不能为空";
                  }

                  if(double.tryParse(value) == null){
                    return "格式错误";
                  }

                  if(double.tryParse(value)! <= low_price){
                    return "高点价格须高于低点价格";
                  }

                  this.est_ror = ((double.tryParse(value)! - low_price)/low_price * 100).toString();

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
            Text("投入数量 「 预计增量: "+this.est_value+" 」",style:TextStyle(fontSize: 14,color:Color(0xff999999)))
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

  Widget showOpenSwitch(){

    return gid.length == 0  ?
    Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Column(
            children:[
              SizedBox(height: 0),
            ])
    ) :
     Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 0.0),
        child:Column(children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Text("开启/关闭:",textAlign: TextAlign.left,style:TextStyle(color:Color(0xff999999),fontSize: 14)),
              Switch(
                  value: is_open,
                  activeColor: Color(0xff48ABFD),
                  onChanged: (value) {
                    setState(() {
                      is_open = value;
                    });
                  })
            ],
          ),
        ])
    );

  }


  void queryGridInfo() async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.getUserGridDetail, {"gid":gid}, (data){

      if(data["rc"] == 0 && data["data"] != ""){
        data = data["data"];

        setState(() {
          this.asset = data["symbol"];
          if(gid.length == 0){
            this.title = "创建网格";
          }else{
            this.title = this.asset + "网格设置";
          }
          assetController.text = asset;
          if(data["status"] == 1){
            is_open = true;
          }else{
            is_open = false;
          }
          lowPriceController.text = Decimal.parse(data["low_price"].toString()).toString();
          highPriceController.text = Decimal.parse(data["high_price"].toString()).toString();
          qtyController.text = Decimal.parse(data["qty"].toString()).toString();
          this.est_ror = data["est_ror"].toString();
          this.est_value = data["est_value"].toString();

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
    var status = 1;
    if(is_open == false){
      status = 0;
    }

    if(gid.length > 0) {
      (NetClient()).post(Configs.modifyUserGrid,
          {
            "user_id": userId,
            "symbol": asset,
            "low_price": low_price,
            "high_price": high_price,
            "qty": qty,
            "status": status
          },
              (data) {
            if (data["rc"] == 0) {
              showSimpleNotification(
                  Text("更新成功"),
                  duration: Duration(seconds: 1, milliseconds: 800),
                  leading: Icon(Icons.check, color: Colors.white),
                  background: Color(0xff48ABFD));
            } else {
              showSimpleNotification(
                  Text("更新失败，请重新登录后再设置"),
                  duration: Duration(seconds: 1, milliseconds: 800),
                  leading: Icon(Icons.error_outline, color: Colors.white),
                  background: Color(0xffE95555));
            }
          });
    }else{

      (NetClient()).post(Configs.createUserGrid,
          {
            "user_id": userId,
            "symbol": asset,
            "low_price": low_price,
            "high_price": high_price,
            "qty": qty,
            "status": status
          },
              (data) {
            if (data["rc"] == 0) {
              showSimpleNotification(
                  Text("创建成功"),
                  duration: Duration(seconds: 1, milliseconds: 800),
                  leading: Icon(Icons.check, color: Colors.white),
                  background: Color(0xff48ABFD));
            }else if(data["rc"] == -1) {
              showSimpleNotification(
                  Text("创建失败，与"+asset+"其它网格发生冲突"),
                  subtitle: Text("价格请不要设置在:"+data["conflict_range"][0].toString()+"-"+data["conflict_range"][1].toString()+"范围内"),
                  duration: Duration(seconds: 4, milliseconds: 200),
                  leading: Icon(Icons.error_outline, color: Colors.white),
                  background: Color(0xffE95555));
            } else {
              showSimpleNotification(
                  Text("创建失败，请重新登录后再设置"),
                  duration: Duration(seconds: 1, milliseconds: 800),
                  leading: Icon(Icons.error_outline, color: Colors.white),
                  background: Color(0xffE95555));
            }
          });

    }
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
                    Navigator.of(context).pop("refresh");
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
                        showOpenSwitch(),
                        SizedBox(height: 2)
                      ]
                    )
                  )
            ),
              Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(32, 22, 32, 0),
                child: TextButton(
                  child: Text('预计收益',style:TextStyle(color:Color(0xff48ABFD),fontWeight: FontWeight.w500)),
                  style: ButtonStyle(
                      textStyle:MaterialStateProperty.all(TextStyle(color:Color(0xff48ABFD),fontWeight: FontWeight.w400)),
                      backgroundColor: MaterialStateProperty.all(Color(0xffF3F5F7)),
                      foregroundColor: MaterialStateProperty.all(Color(0xff48ABFD)),
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
                    this.est_ror = ((high_price - low_price)/low_price * 100).toStringAsFixed(2);
                    this.est_value = (this.qty  * (high_price - low_price)/low_price).toStringAsFixed(6);

                  },
                ),
              ),
              Container(
                height: 60,
                padding: const EdgeInsets.fromLTRB(32, 18, 32, 0),
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