
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yakapp/util/configs.dart';
import 'package:yakapp/util/net_util.dart';

class AssetSettingPage extends StatefulWidget{

  var asset = "";
  AssetSettingPage({ required this.asset});

  @override
  State createState()  => AssetSettingState(asset: asset);
}

class AssetSettingState extends State<AssetSettingPage>{
  var asset="";


  AssetSettingState({required this.asset});

  var target_ror;
  var t_sell;
  var loweset_ror;
  var l_sell;
  var title = "盈损设置";

  final _formKey = new GlobalKey<FormState>();

  TextEditingController trController = new TextEditingController(text: "");
  TextEditingController tsController = new TextEditingController(text: "");
  TextEditingController lrController = new TextEditingController(text: "");
  TextEditingController lsController = new TextEditingController(text: "");

  Widget showCoin() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
      child: Text(asset,style: TextStyle(fontSize: 20,color:Colors.teal))
    );
  }


  Widget showTargetRorInput() {
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
        controller: trController,
        style: TextStyle(fontSize: 16),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '',
            labelText: "目标收益率(%)",
            icon: new Icon(
              Icons.arrow_forward,
              color: Colors.teal,
            )),
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
    );
  }


  Widget showLowestRorInput() {
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
        controller: lrController,
        style: TextStyle(fontSize: 16),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '',
            labelText: "止损收益率(%)",
            icon: new Icon(
              Icons.arrow_forward,
              color: Colors.teal,
            )),
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
    );
  }

  Widget showTsellInput() {
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
        controller: tsController,
        style: TextStyle(fontSize: 16),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '',
            labelText: "目标达成卖出比例(%)",
            icon: new Icon(
              Icons.arrow_forward,
              color: Colors.teal,
            )),
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
    );
  }


  Widget showLsellInput() {
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
        controller: lsController,
        style: TextStyle(fontSize: 16),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '',
            labelText: "止损触发卖出比例(%)",
            icon: new Icon(
              Icons.arrow_forward,
              color: Colors.teal,
            )),
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
    );
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
          trController.text = data["target_ror"].toString();
          tsController.text = data["t_sell"].toString();
          lrController.text = data["lowest_ror"].toString();
          lsController.text = data["l_sell"].toString();

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

  void submitConfig(target_ror,t_sell,lowest_ror,l_sell) async {

    SharedPreferences prefs =  await SharedPreferences.getInstance();
    String? userId = prefs.getString("uid");
    (NetClient()).post(Configs.updateAssetConfigApi,
        {"user_id":userId,"asset":asset,"target_ror":target_ror,"t_sell":t_sell,"lowest_ror":lowest_ror,"l_sell":l_sell},
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

    WidgetsBinding.instance!.addPostFrameCallback( (timestamp)=> queryConfigInfo());
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

          appBar:AppBar(
            title:  Text(title),
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
                        showCoin(),
                        showTargetRorInput(),
                        showTsellInput(),
                        showLowestRorInput(),
                        showLsellInput(),
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
                    submitConfig(target_ror,t_sell,loweset_ror,l_sell);
                  },
                ),
              )

          ],

        )
    );
  }


}