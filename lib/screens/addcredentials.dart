import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wifi/wifi.dart';
import 'package:wifilink/dbmanager.dart/dbmanager.dart';
import 'package:wifilink/screens/homepage.dart';
import 'package:wifilink/screens/systempadding.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:wifilink/responsiveui/sizeconfig.dart';
import 'package:wifilink/screens/widget/networksensitivebar.dart';

class AddCredentials extends StatefulWidget {
  @override
  _AddCredentialsState createState() => _AddCredentialsState();
}

class _AddCredentialsState extends State<AddCredentials> {
  int level = 0;
  List<WifiResult> ssidList = [];
  String ssid = '', password = '';

  @override
  void initState() {
    loadData();
    super.initState();

    setState(() {});
  }

  void loadData() async {
    Wifi.list('').then((list) {
      setState(() {
        ssidList = list;
      });
    });
  }

  Future<Null> connection() async {
    Wifi.connection(ssid, password).then((v) {
      print(v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff31363a),
      body: Stack(
        children: [
          ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 75),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
                          _showDialog(context);
                        },
                        child: new Container(
                          height: 38,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Manually Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                new SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.add, color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Text(
                    "You can manually add a network or select",
                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                  Text(
                    "from available networks belows",
                    style: TextStyle(
                      color: Colors.white60,
                    ),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  FadeInLeft(
                    duration: Duration(milliseconds: 1000),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: new Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        decoration: new BoxDecoration(
                          color: Color(0xff191a1e),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: new Column(
                          children: [
                            NetworkSensitiveBar(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddCredentials()));
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Available Networks",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 150,
                                // height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                decoration: new BoxDecoration(
                                  color: Color(0xff191a1e),
                                  // color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ListView.builder(
                                    padding: EdgeInsets.all(8.0),
                                    itemCount: ssidList.length + 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return itemSSID(index);
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget itemSSID(index) {
    if (index == 0) {
      return SpinKitThreeBounce(
        color: Colors.greenAccent,
        size: 20,
      );
    } else {
      return Column(children: <Widget>[
        ListTile(
          onTap: () {
            _showAvailableDialog(context, index);
            _avaliablewifinameController.text = ssidList[index - 1].ssid;
            print("${ssidList[index - 1].ssid}");
          },
          leading: Icon(
            Icons.wifi,
            color: Colors.white,
          ),
          trailing: Icon(
            Icons.lock,
            color: Colors.redAccent,
          ),
          title: Text(
            ssidList[index - 1].ssid,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          dense: true,
        ),
        Divider(),
      ]);
    }
  }

  final _formKey = new GlobalKey<FormState>();
  final DbWifiManager dbmanager = new DbWifiManager();

  final _wifinameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _avaliablewifinameController = TextEditingController();
  Wifi wifi;
  bool buttonEnable = false;
  Future _showDialog(BuildContext context) {
    bool passwordVisible = false;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SystemPadding(
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Dialog(
                backgroundColor: Color(0xff191a1e),
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        3.60 * SizeConfig.hightMultiplier)),
                child: Container(
                  height: 33.63 * SizeConfig.hightMultiplier,
                  width: 40 * SizeConfig.hightMultiplier,
                  decoration: BoxDecoration(
                    color: Color(0xff191a1e),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(
                        3.60 * SizeConfig.hightMultiplier),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Register New Wifi",
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        onChanged: () => setState(() =>
                            buttonEnable = _formKey.currentState.validate()),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: new Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(12)),
                                child: new TextFormField(
                                    controller: _wifinameController,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                    decoration: new InputDecoration(
                                      errorStyle: TextStyle(fontSize: .01),
                                      hintText: "Network Name",
                                      hintStyle: TextStyle(color: Colors.white),
                                      contentPadding: EdgeInsets.all(15),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "";
                                      }
                                      return null;
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: new Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(12)),
                                child: new TextFormField(
                                  obscureText: passwordVisible,
                                  controller: _passwordController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  decoration: new InputDecoration(
                                     errorStyle: TextStyle(fontSize: .01),
                                    contentPadding: EdgeInsets.all(15),
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.white),

                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                        icon: Icon(
                                          passwordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.white,
                                        )),
                                  ),
                                   validator: (value) {
                                      if (value.isEmpty) {
                                        return "";
                                      }
                                      return null;
                                    }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: buttonEnable
                                  ? () {
                                      _submitwifi(context);
                                      Navigator.pop(context);
                                      showtoastmsgid();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyHomePage()));
                                      setState(() {});
                                    }
                                  : showtoastfieldsempty,
                              child: new Container(
                                height: 50,
                                width: 130,
                                decoration: BoxDecoration(
                                  // color: Color(0xffed4f10),
                                  color: Colors.greenAccent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Save",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )

                      // Container(
                      //     child: FlatButton(
                      //         onPressed: _exportSvg, child: Text("svg"))),
                      // new Container(
                      //   child: BarcodeWidget(
                      //     data: me.toString(),
                      //     barcode: Barcode.qrCode(),
                      //     height: 200,
                      //     width: 200,
                      //   ),
                      // )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future _showAvailableDialog(BuildContext context, index) {
    bool passwordVisible = false;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SystemPadding(
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Dialog(
                backgroundColor: Color(0xff191a1e),
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        3.60 * SizeConfig.hightMultiplier)),
                child: Container(
                  height: 33.63 * SizeConfig.hightMultiplier,
                  width: 40 * SizeConfig.hightMultiplier,
                  decoration: BoxDecoration(
                    color: Color(0xff191a1e),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(
                        3.60 * SizeConfig.hightMultiplier),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      new SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Register New Wifi",
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Form(
                        key: _formKey,

                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: new Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(12)),
                                child: new TextFormField(
                                  controller: _avaliablewifinameController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  decoration: new InputDecoration(
                                    hintText: "Network Name",
                                    hintStyle: TextStyle(color: Colors.white),
                                    contentPadding: EdgeInsets.all(15),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: new Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(12)),
                                child: new TextFormField(
                                  obscureText: passwordVisible,
                                  controller: _passwordController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.white),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            passwordVisible = !passwordVisible;
                                          });
                                        },
                                        icon: Icon(
                                          passwordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: buttonEnable? () {
                                _avaliablesubmitwifi(context);
                                Navigator.pop(context);
                                showtoastmsgid();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()));
                                setState(() {});
                              }: showtoastfieldsempty,
                              child: new Container(
                                height: 50,
                                width: 130,
                                decoration: BoxDecoration(
                                  // color: Color(0xffed4f10),
                                  color: Colors.greenAccent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Save",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showtoastmsgid() {
    Fluttertoast.showToast(
      msg: "Wifi Created Manually !!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16,
    );
  }

  void showtoastfieldsempty() {
    Fluttertoast.showToast(
      msg: "Fields Can't be Empty!!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16,
    );
  }

  void _submitwifi(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (wifi == null) {
        Wificreds st = new Wificreds(
            wifiname: _wifinameController.text,
            password: _passwordController.text);
        dbmanager.insertwifi(st).then((id) => {
              _wifinameController.clear(),
              _passwordController.clear(),
              print('Wifi Added to Db $id'),
            });
      }
    }
  }

  void _avaliablesubmitwifi(BuildContext context) {
    if (_formKey.currentState.validate()) {
      if (wifi == null) {
        Wificreds st = new Wificreds(
            wifiname: _avaliablewifinameController.text,
            password: _passwordController.text);
        dbmanager.insertwifi(st).then((id) => {
              _wifinameController.clear(),
              _passwordController.clear(),
              print('Wifi Added to Db $id'),
            });
      }
    }
  }
}
