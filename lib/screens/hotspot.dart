import 'package:barcode/barcode.dart';
import 'package:barcode_image/barcode_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wifilink/responsiveui/sizeconfig.dart';
import 'package:wifilink/screens/systempadding.dart';
import 'package:image/image.dart' as im;
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'dart:ui';
import 'package:wifilink/screens/share/share_vm.dart';

class Hotspot extends StatefulWidget {
  @override
  _HotspotState createState() => _HotspotState();
}

class _HotspotState extends State<Hotspot> {
  static final _wifinameController = TextEditingController();
  static final _passwordController = TextEditingController();
  // final _formKey = new GlobalKey<FormState>();

  bool passwordVisible;
  @override
  void initState() {
    passwordVisible = true;
    super.initState();
  }

  void showtoast() {
    Fluttertoast.showToast(
      msg: "QR Created !!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16,
    );
  }

  final me = MeCard.wifi(
    ssid: "${_wifinameController.text}",
    password: "${_passwordController.text}",
  );

  Future _showdetailqrcode(
    BuildContext context,
  ) {
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
                        "${_wifinameController.text}",
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
                                  exportdpng();
                                }),
                            new SizedBox(
                              width: 60,
                            ),
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

  void _exportPdf() {
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
          pw.Text("${_wifinameController.text}",
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
  void exportdpng() {
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

  final _formKey = new GlobalKey<FormState>();
  bool buttonEnable = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 0,
          backgroundColor: Color(
            0xff31363a,
          ),
          // iconTheme: IconThemeData(color:Colors.white),
          automaticallyImplyLeading: false,
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              _wifinameController.clear();
              _passwordController.clear();
            },
          ),
        ),
        backgroundColor: Color(0xff31363a),
        body: new Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_tethering,
                      size: 40,
                      color: Colors.greenAccent,
                    ),
                    new SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Hotspot",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: new Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      color: Color(0xff191a1e),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: new Column(
                        children: [
                          Form(
                            key: _formKey,
                            onChanged: () => setState(() => buttonEnable =
                                _formKey.currentState.validate()),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: new Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white10,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: new TextFormField(
                                      controller: _wifinameController,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                      decoration: new InputDecoration(
                                        hintText: "Network Name",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        contentPadding: EdgeInsets.all(15),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: new Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white10,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: new TextFormField(
                                      obscureText: passwordVisible,
                                      controller: _passwordController,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                      decoration: new InputDecoration(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        contentPadding: EdgeInsets.all(15),
                                        border: InputBorder.none,
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                passwordVisible =
                                                    !passwordVisible;
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
                          GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: buttonEnable
                                        ? () {
                                            _showdetailqrcode(context);
                                            showtoast();
                                          }
                                        : showtoastfieldsempty,
                                    child: Icon(
                                      FlutterIcons.qrcode_faw,
                                      size: 60,
                                      // color: Color(0xffed4f10),
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: buttonEnable
                                        ? () {
                                            _exportPdf();
                                          }
                                        : showtoastfieldsempty,
                                    child: new Container(
                                      height: 50,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        // color: Color(0xffed4f10),
                                        color: Colors.greenAccent,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(20),
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
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
