import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wifilink/enum/connectivityStatus.dart';

class NetworkSensitive extends StatefulWidget {
  @override
  _NetworkSensitiveState createState() => _NetworkSensitiveState();
}

class _NetworkSensitiveState extends State<NetworkSensitive> {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

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

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    if (connectionStatus == ConnectivityStatus.Wifi) {
      return FadeIn(
        duration: Duration(milliseconds: 1500),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi,
                        color: Colors.greenAccent,
                        size: 35,
                      ),
                      new SizedBox(
                        width: 20,
                      ),
                      Text(
                        " $_connectionStatus",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )
                    ],
                  )),
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      );
    }
    if (connectionStatus == ConnectivityStatus.Cellular) {
      return FadeIn(
        duration: Duration(milliseconds: 1500),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.signal_cellular_4_bar,
                    color: Colors.orangeAccent,
                    size: 100,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Wifi connection is required to use this app. Please.",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              "go to phone setting and connect to WIFI .",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return FadeIn(
      duration: Duration(milliseconds: 1500),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Align(
                alignment: Alignment.topCenter,
                child: Icon(
                  Icons.signal_wifi_off,
                  color: Colors.redAccent,
                  size: 100,
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Wifi connection is required to use this app. Please.",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Text(
            "go to phone setting and connect to WIFI .",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String wifiName, wifiBSSID, wifiIP;
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
          _connectionStatus = '$wifiName';
        });
        break;
      default:
    }
  }
}
