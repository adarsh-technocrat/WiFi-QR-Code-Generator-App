import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:barcode/barcode.dart';
import 'package:barcode_image/barcode_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:wifilink/dbmanager.dart/dbmanager.dart';
import 'package:wifilink/responsiveui/sizeconfig.dart';
import 'package:wifilink/screens/addcredentials.dart';
import 'package:wifilink/screens/hotspot.dart';
import 'package:wifilink/screens/systempadding.dart';
import 'package:wifilink/screens/widget/networksencitive.dart';
import 'package:wifilink/screens/widget/networksensitivebar.dart';
import 'package:image/image.dart' as im;
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'dart:ui';
import 'package:wifilink/screens/share/share_vm.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool passwordVisible = false;
  final DbWifiManager dbmanager = new DbWifiManager();

  final _wifinameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  final _form = new GlobalKey<FormState>();
  String wifiName, wifiBSSID, wifiIP;

  Wificreds wifis;
  List<Wificreds> wifiList;
  int updateIndex;
  static String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  static TextEditingController _passwordcredscontroller =
      TextEditingController();

  bool buttonEnable = false;
  bool notconnectedtowifi = false;

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }
    if (Platform.isAndroid) {
      print('Checking Android permissions');
      var status = await Permission.location.status;
      if (status.isUndetermined || status.isDenied || status.isRestricted) {
        if (await Permission.location.request().isGranted) {
          print('Location permission granted');
        } else {
          print('Location permission not granted');
        }
      } else {
        print('Permission already granted (previous execution?)');
      }
    }

    return _updateConnectionStatus(result);
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void showtoastdeleted(String name) {
    //  Wifi wifi = wifiList[index]; // getting the list of wifi items.
    Fluttertoast.showToast(
      msg: "$name Deleted !!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 1.96*SizeConfig.textMultiplier
    );
  }

  void showtoasupdate() {
    Fluttertoast.showToast(
      msg: "Updated !!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 1.96*SizeConfig.textMultiplier,
    );
  }

  _updatewifi() {
    wifis.wifiname = _wifinameController.text;
    wifis.password = _passwordController.text;
    dbmanager.updateWifi(wifis).then((id) => {
          setState(() {
            wifiList[updateIndex].wifiname = _wifinameController.text;
            wifiList[updateIndex].password = _passwordController.text;
          }),
          _wifinameController.clear(),
          _passwordController.clear(),
          wifis = null,
        });
  }

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
                        height: 2.45*SizeConfig.textMultiplier,
                      ),
                      Text(
                        "Update Register Wifi",
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 2.69*SizeConfig.textMultiplier,
                        ),
                      ),
                      Form(
                        key: _form,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: new Container(
                                height: 6.12*SizeConfig.hightMultiplier,
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(1.47*SizeConfig.hightMultiplier)),
                                child: new TextFormField(
                                  controller: _wifinameController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 2.45*SizeConfig.textMultiplier,
                                  ),
                                  decoration: new InputDecoration(
                                    hintText: "Network Name",
                                    hintStyle: TextStyle(color: Colors.white),
                                    contentPadding: EdgeInsets.all(1.83*SizeConfig.hightMultiplier),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.all(1.83*SizeConfig.hightMultiplier),
                              child: new Container(
                                height: 6.12*SizeConfig.hightMultiplier,
                                decoration: BoxDecoration(
                                    color: Colors.white10,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(1.47*SizeConfig.hightMultiplier)),
                                child: new TextFormField(
                                  obscureText: passwordVisible,
                                  controller: _passwordController,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 2.45*SizeConfig.hightMultiplier,
                                  ),
                                  decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.all(1.83*SizeConfig.hightMultiplier),
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
                        padding:  EdgeInsets.only(right: 2.45*SizeConfig.hightMultiplier),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _updatewifi();
                                showtoasupdate();
                                Navigator.pop(context);
                              },
                              child: new Container(
                                height: 2.45*SizeConfig.hightMultiplier,
                                width: 15.93*SizeConfig.hightMultiplier,
                                decoration: BoxDecoration(
                                  // color: Color(0xffed4f10),
                                  color: Colors.greenAccent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(2.45*SizeConfig.hightMultiplier),
                                ),
                                child: Padding(
                                  padding:  EdgeInsets.all(0.98*SizeConfig.hightMultiplier),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Update",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 1.83*SizeConfig.hightMultiplier,
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

  final mecreds = MeCard.wifi(
    ssid: "$_connectionStatus",
    password: "${_passwordcredscontroller.text}",
  );
  void showtoastmsgid() {
    Fluttertoast.showToast(
      msg:
          "Ooops !! Sorry  You are Not Connected to WiFi.Connect or Register Manually..",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 1.93*SizeConfig.textMultiplier,
    );
  }

  void showtoastemptytextfield() {
    Fluttertoast.showToast(
      msg: "Ooops !! Password field can't be Empty !!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 1.93*SizeConfig.textMultiplier,
    );
  }

  void _exportPdfcreds() {
    final bc = Barcode.qrCode();
    final pdf = pw.Document(
      author: 'Linky-Wifi',
      keywords: 'barcode, dart, Adarsh',
      subject: "Adarsh",
      title: 'Barcode gen',
    );
    const scale = 5.0;

    pdf.addPage(pw.Page(
      build: (context) => pw.Center(
        child: pw.Column(children: [
          pw.Header(text: bc.name, level: 2),
          pw.Text("WiFi",
              style: new pw.TextStyle(
                color: PdfColor.fromInt(0xff000000),
                fontWeight: pw.FontWeight.bold,
                fontSize: 30,
              )),
          pw.Spacer(),
          pw.BarcodeWidget(
            barcode: bc,
            color: PdfColor.fromInt(0xff03fcb1),
            data: mecreds.toString(),
            width: 600 * PdfPageFormat.mm / scale,
            height: 600 * PdfPageFormat.mm / scale,
            textStyle: pw.TextStyle(
              fontSize: 20 * PdfPageFormat.mm / scale,
            ),
          ),
          pw.Spacer(flex: 1),
          pw.Text("Network Name",
              style: new pw.TextStyle(
                color: PdfColor.fromInt(0xff000000),
                fontSize: 28,
              )),
          pw.SizedBox(height: 10),
          pw.Text("$_connectionStatus",
              style: new pw.TextStyle(
                color: PdfColor.fromInt(0xff000000),
                fontSize: 22,
              )),
          pw.Spacer(),
          pw.Text("Scan above QR code with your camera to",
              style: new pw.TextStyle(
                color: PdfColor.fromInt(0xff03fcb1),
                fontSize: 20,
              )),
          pw.Text(" connect to our wifi.",
              style: new pw.TextStyle(
                color: PdfColor.fromInt(0xff03fcb1),
                fontSize: 20,
              )),
          pw.Spacer(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.RichText(
              text: pw.TextSpan(
                text: 'Pdf file built using: ',
                children: [
                  pw.TextSpan(
                    text: 'https://pub.dev/packages/pdf',
                    annotation: pw.AnnotationUrl(
                      'https://pub.dev/packages/pdf',
                    ),
                    style: const pw.TextStyle(
                      color: PdfColors.blue,
                      decoration: pw.TextDecoration.underline,
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    ));

    share(
      bytes: pdf.save(),
      filename: '${bc.name}.pdf',
      mimetype: 'application/pdf',
    );
  }

  // export png of qr code
  void exportdpngcreds() {
    final barcode = Barcode.qrCode();
    final image = im.Image(120, 120);
    im.fill(
      image,
      im.getColor(255, 255, 255),
    );
    drawBarcode(
        image, barcode, MaterialCommunityIcons.credit_card_minus.toString(),
        font: im.arial_24,
        color: 0xff000000,
        height: 90,
        width: 90,
        x: 15,
        y: 15);
    final data = im.encodePng(image);

    share(
      bytes: Uint8List.fromList(data),
      filename: '${barcode.name}.png',
      mimetype: 'image/png',
    );
  }

  Future _showdetailqrcodecreds(BuildContext context) {
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
                  width: 50 * SizeConfig.hightMultiplier,
                  height: 55.63 * SizeConfig.hightMultiplier,
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
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                icon: Icon(Icons.cancel, color: Colors.white38),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ),
                      Text(
                        "Share QR Code",
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(16),
                                  border: new Border.all(
                                      color: Colors.white38, width: 2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: QrImage(
                                      data: mecreds.toString(),

                                      backgroundColor: Color(0xff191a1e),
                                      foregroundColor: Colors.greenAccent,
                                      // embeddedImage: ,
                                      // embeddedImageStyle: ,
                                      size: 150,
                                      version: QrVersions.auto,
                                      gapless: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Network Name",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      new SizedBox(
                        height: 12,
                      ),
                      Text(
                        "$_connectionStatus",
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      new SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: new Row(
                          children: [
                            IconButton(
                                icon: Icon(
                                  FlutterIcons.save_faw,
                                  size: 40,
                                  // color: Color(0xffed4f10),
                                  color: Colors.white24,
                                ),
                                onPressed: () {
                                  exportdpngcreds();
                                }),
                            new SizedBox(
                              width: 60,
                            ),
                            GestureDetector(
                              onTap: () {
                                _exportPdfcreds();
                              },
                              child: new Container(
                                height: 50,
                                width: 90,
                                decoration: BoxDecoration(
                                  // color: Color(0xffed4f10),
                                  color: Colors.greenAccent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.white38, width: 2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "PDF",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.picture_as_pdf,
                                          color: Colors.white)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
              padding:  EdgeInsets.all(1.22*SizeConfig.hightMultiplier),
              child: IconButton(
                  icon: Icon(
                    Icons.wifi_tethering,
                    color: Colors.white,
                    size: 3.67*SizeConfig.hightMultiplier,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Hotspot()));
                  }))
        ],
        backgroundColor: Color(0xff31363a),
      ),
      backgroundColor: Color(0xff31363a),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                NetworkSensitive(),
                SizedBox(
                  height: 3.67*SizeConfig.hightMultiplier,
                ),
                FadeInRight(
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding:  EdgeInsets.all(1.83*SizeConfig.hightMultiplier,),
                    child: new Container(
                      height: 28.18*SizeConfig.hightMultiplier,
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        color: Color(0xff191a1e),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(1.96*SizeConfig.hightMultiplier,),
                      ),
                      child: new Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.all(2.20*SizeConfig.hightMultiplier,),
                            child: Text(
                              "$_connectionStatus Credentials",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(1.47*SizeConfig.hightMultiplier,),
                            child: new Container(
                              height:6.12*SizeConfig.hightMultiplier,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(1.47*SizeConfig.hightMultiplier,),
                              ),
                              child: Form(
                                key: _formKey,
                                onChanged: () => setState(() => buttonEnable =
                                    _formKey.currentState.validate()),
                                child: new TextFormField(
                                    controller: _passwordcredscontroller,
                                    obscureText: passwordVisible,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 2.45*SizeConfig.textMultiplier,
                                    ),
                                    showCursor: false,
                                    decoration: new InputDecoration(
                                      errorStyle: TextStyle(fontSize: .01),
                                      contentPadding: EdgeInsets.all(1.83*SizeConfig.hightMultiplier,),
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(
                                              () {
                                                passwordVisible =
                                                    !passwordVisible;
                                              },
                                            );
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
                                    }),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(2.45*SizeConfig.hightMultiplier,),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: !notconnectedtowifi
                                      ? buttonEnable
                                          ? () {
                                              _showdetailqrcodecreds(context);
                                            }
                                          : showtoastemptytextfield
                                      : showtoastmsgid,
                                  child: Icon(
                                    FlutterIcons.qrcode_faw,
                                    size: 7.35*SizeConfig.hightMultiplier,
                                    // color: Color(0xffed4f10),
                                    color: Colors.greenAccent,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Share.share(
                                        "check out Linky-fi  https://play.google.com/store/apps/details?id=com.technocrate.wifilink \n Easy way to create and share your Wi-Fi Password Without knowing to any one :)");
                                  },
                                  child: new Container(
                                    height: 6.12*SizeConfig.hightMultiplier,
                                    width: 15.93*SizeConfig.hightMultiplier,
                                    decoration: BoxDecoration(
                                      // color: Color(0xffed4f10),
                                      color: Colors.greenAccent,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(2.45*SizeConfig.hightMultiplier,),
                                    ),
                                    child: Padding(
                                      padding:  EdgeInsets.all(0.980*SizeConfig.hightMultiplier,),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Share Link",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 1.83*SizeConfig.textMultiplier
                                            ),
                                          ),
                                          SizedBox(
                                            width: 1.22*SizeConfig.hightMultiplier,
                                          ),
                                          Icon(Icons.wifi, color: Colors.white)
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
                  ),
                ),
                FadeInLeft(
                  duration: Duration(milliseconds: 1000),
                  child: Padding(
                    padding:  EdgeInsets.all(1.83*SizeConfig.hightMultiplier,),
                    child: new Container(
                      height: 30.63*SizeConfig.hightMultiplier,
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        color: Color(0xff191a1e),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(1.96*SizeConfig.hightMultiplier,),
                      ),
                      child: new Column(
                        children: [
                          NetworkSensitiveBar(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCredentials(),
                                ),
                              );
                            },
                            child: new Container(
                              height: 4.65*SizeConfig.hightMultiplier,
                              width: 14.70*SizeConfig.hightMultiplier,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(2.44*SizeConfig.hightMultiplier,),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Add new",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 1.47*SizeConfig.textMultiplier,
                                      ),
                                    ),
                                    new SizedBox(
                                      width: 0.61*SizeConfig.hightMultiplier,
                                    ),
                                    Icon(Icons.add, color: Colors.white)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              decoration: new BoxDecoration(
                                color: Color(0xff191a1e),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: FutureBuilder(
                                future: dbmanager.getwifiList(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data.isNotEmpty) {
                                    wifiList = snapshot.data;
                                    return new ListView.builder(
                                      itemCount: wifiList == null
                                          ? 0
                                          : wifiList.length,
                                      itemBuilder: (context, int index) {
                                        Wificreds wifi = wifiList[
                                            index]; // getting the list of wifi items.
                                        final me = MeCard.wifi(
                                          ssid: "${wifi.wifiname}",
                                          password: "${wifi.password}",
                                        );
                                        return Column(
                                          children: [
                                            Dismissible(
                                              background: Container(
                                                color: Colors.redAccent,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: new Align(
                                                      child: new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(Icons.delete_sweep,
                                                          color: Colors.white,
                                                          size: 30)
                                                    ],
                                                  )),
                                                ),
                                              ),
                                              key: new Key(wifi.id.toString()),
                                              onDismissed: (direction) {
                                                dbmanager.deleteWifi(wifi.id);
                                                setState(
                                                  () {
                                                    wifiList.removeAt(index);
                                                  },
                                                );
                                                showtoastdeleted(wifi.wifiname);
                                              },
                                              child: ListTile(
                                                onTap: () {
                                                  _showDialog(context);
                                                  _wifinameController.text =
                                                      wifi.wifiname;
                                                  _passwordController.text =
                                                      wifi.password;
                                                  wifis = wifi;
                                                  updateIndex = index;
                                                },
                                                title: Text(
                                                  "${wifi.wifiname}",
                                                  style: new TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                leading: new Icon(
                                                  Icons.wifi,
                                                  color: Colors.white,
                                                  size: 25,
                                                ),
                                                trailing: GestureDetector(
                                                  onTap: () {
                                                    _showdetailqrcode(
                                                        context, index);
                                                  },
                                                  child: QrImage(
                                                    data: me.toString(),
                                                    backgroundColor:
                                                        Color(0xff191a1e),
                                                    foregroundColor:
                                                        Colors.greenAccent,
                                                    size: 50,
                                                    version: QrVersions.auto,
                                                    gapless: true,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            new Divider(
                                              color: Colors.white24,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                        child: SvgPicture.asset(
                                      "assets/2638951.svg",
                                      height: 95,
                                      width: 95,
                                    ));
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future _showdetailqrcode(BuildContext context, index) {
    Wificreds wifi = wifiList[index]; // getting the list of wifi items.
    final me = MeCard.wifi(
      ssid: "${wifi.wifiname}",
      password: "${wifi.password}",
    );
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
                  width: 50 * SizeConfig.hightMultiplier,
                  height: 55.63 * SizeConfig.hightMultiplier,
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
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                icon: Icon(Icons.cancel, color: Colors.white38),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        ),
                      ),
                      Text(
                        "Share QR Code",
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(16),
                                  border: new Border.all(
                                      color: Colors.white38, width: 2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: QrImage(
                                      data: me.toString(),

                                      backgroundColor: Color(0xff191a1e),
                                      foregroundColor: Colors.greenAccent,
                                      // embeddedImage: ,
                                      // embeddedImageStyle: ,
                                      size: 150,
                                      version: QrVersions.auto,
                                      gapless: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      new SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Network Name",
                        style: new TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      new SizedBox(
                        height: 12,
                      ),
                      Text(
                        "${wifi.wifiname}",
                        style: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      new SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: new Row(
                          children: [
                            IconButton(
                              // color: Color(0xffed4f10),
                              icon: Icon(
                                Icons.view_carousel,
                                size: 40,
                                color: Colors.white24,
                              ),
                              onPressed: () {},
                            ),
                            new SizedBox(
                              width: 15,
                            ),
                            IconButton(
                                icon: Icon(
                                  FlutterIcons.save_faw,
                                  size: 40,
                                  // color: Color(0xffed4f10),
                                  color: Colors.white24,
                                ),
                                onPressed: () {
                                  exportdpng(index);
                                }),
                            new SizedBox(
                              width: 60,
                            ),
                            GestureDetector(
                              onTap: () {
                                _exportPdf(index);
                              },
                              child: new Container(
                                height: 50,
                                width: 90,
                                decoration: BoxDecoration(
                                  // color: Color(0xffed4f10),
                                  color: Colors.greenAccent,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.white38, width: 2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "PDF",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(Icons.picture_as_pdf,
                                          color: Colors.white)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
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

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print('Result: $result');
    switch (result) {
      case ConnectivityResult.wifi:
        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiName = await _connectivity.getWifiName();
            } else {
              wifiName = await _connectivity.getWifiName();
            }
          } else {
            wifiName = await _connectivity.getWifiName();
          }
        } on PlatformException catch (e) {
          print('Error: $e.toString()');
          wifiName = "Failed to get Wifi Name";
        }
        print('Wi-Fi Name: $wifiName');

        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              wifiBSSID = await _connectivity.getWifiBSSID();
            } else {
              wifiBSSID = await _connectivity.getWifiBSSID();
            }
          } else {
            wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          wifiBSSID = "Failed to get Wifi BSSID";
        }
        print('BSSID: $wifiBSSID');

        try {
          wifiIP = await _connectivity.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          wifiIP = "Failed to get Wifi IP";
        }

        setState(() {
          notconnectedtowifi = false;
          _connectionStatus = '$wifiName';
        });
        break;
      default:
        setState(() {
          _passwordcredscontroller.clear();
          notconnectedtowifi = true;
          _connectionStatus = '';
        });
    }
  }

  void _exportPdf(index) {
    Wificreds wifi = wifiList[index]; // getting the list of wifi items.
    final me = MeCard.wifi(
      ssid: "${wifi.wifiname}",
      password: "${wifi.password}",
    );
    final bc = Barcode.qrCode();
    final pdf = pw.Document(
      author: 'Linky-Wifi',
      keywords: 'barcode, dart, Adarsh',
      subject: "Adarsh",
      title: 'Barcode gen',
    );
    const scale = 5.0;

    pdf.addPage(pw.Page(
      build: (context) => pw.Center(
        child: pw.Column(children: [
          pw.Header(text: bc.name, level: 2),
          pw.Text("WiFi",
              style: new pw.TextStyle(
                color: PdfColor.fromInt(0xff000000),
                fontWeight: pw.FontWeight.bold,
                fontSize: 30,
              )),
          pw.Spacer(),
          pw.BarcodeWidget(
            barcode: bc,
            color: PdfColor.fromInt(0xff03fcb1),
            data: me.toString(),
            width: 600 * PdfPageFormat.mm / scale,
            height: 600 * PdfPageFormat.mm / scale,
            textStyle: pw.TextStyle(
              fontSize: 20 * PdfPageFormat.mm / scale,
            ),
          ),
          pw.Spacer(flex: 1),
          pw.Text("Network Name",
              style: new pw.TextStyle(
                color: PdfColor.fromInt(0xff000000),
                fontSize: 28,
              )),
          pw.SizedBox(height: 10),
          pw.Text("${wifi.wifiname}",
              style: new pw.TextStyle(
                color: PdfColor.fromInt(0xff000000),
                fontSize: 22,
              )),
          pw.Spacer(),
          pw.Text("Scan above QR code with your camera to",
              style: new pw.TextStyle(
                color: PdfColor.fromInt(0xff03fcb1),
                fontSize: 20,
              )),
          pw.Text(" connect to our wifi.",
              style: new pw.TextStyle(
                color: PdfColor.fromInt(0xff03fcb1),
                fontSize: 20,
              )),
          pw.Spacer(),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.RichText(
              text: pw.TextSpan(
                text: 'Pdf file built using: ',
                children: [
                  pw.TextSpan(
                    text: 'https://pub.dev/packages/pdf',
                    annotation: pw.AnnotationUrl(
                      'https://pub.dev/packages/pdf',
                    ),
                    style: const pw.TextStyle(
                      color: PdfColors.blue,
                      decoration: pw.TextDecoration.underline,
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    ));

    share(
      bytes: pdf.save(),
      filename: '${bc.name}.pdf',
      mimetype: 'application/pdf',
    );
  }

  // export png of qr code
  void exportdpng(index) {
    Wificreds wifi = wifiList[index]; // getting the list of wifi items.
    final me = MeCard.wifi(
      ssid: "${wifi.wifiname}",
      password: "${wifi.password}",
    );
    final barcode = Barcode.qrCode();
    final image = im.Image(120, 120);
    im.fill(
      image,
      im.getColor(255, 255, 255),
    );
    drawBarcode(image, barcode, me.toString(),
        font: im.arial_24,
        color: 0xff000000,
        height: 90,
        width: 90,
        x: 15,
        y: 15);
    final data = im.encodePng(image);

    share(
      bytes: Uint8List.fromList(data),
      filename: '${barcode.name}.png',
      mimetype: 'image/png',
    );
  }
}
