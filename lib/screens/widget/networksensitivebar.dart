import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifilink/enum/connectivityStatus.dart';

class NetworkSensitiveBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connectionStatus == ConnectivityStatus.Wifi) {
      return Padding(
          padding: const EdgeInsets.all(18),
          child: new Container(
            width: 20,
            height: 5,
            decoration: BoxDecoration(
                // color: Color(0xffed4f10),
                color: Colors.greenAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16)),
          ));
    }

    if (connectionStatus == ConnectivityStatus.Cellular) {
      return Padding(
          padding: const EdgeInsets.all(18),
          child: new Container(
            width: 20,
            height: 5,
            decoration: BoxDecoration(
                // color: Color(0xffed4f10),
                color: Colors.orangeAccent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(16)),
          ));
    }
    return Padding(
        padding: const EdgeInsets.all(18),
        child: new Container(
          width: 20,
          height: 5,
          decoration: BoxDecoration(
              // color: Color(0xffed4f10),
              color: Colors.redAccent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16)),
        ));
  }
}
