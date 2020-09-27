import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:wifilink/enum/connectivityStatus.dart';

class ConnectivityServices {
  StreamController<ConnectivityStatus> connectionStatusController =  StreamController<ConnectivityStatus>();

  ConnectivityServices() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // convert this result to the enum
      var connectivityStatus = _getStatusFromResult(result);
      connectionStatusController.add(connectivityStatus);
    },);
  }

  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
        break;

      case ConnectivityResult.wifi:
        return ConnectivityStatus.Wifi;
        break;

      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
        break;

      default:
        return ConnectivityStatus.Offline;
    }
  }
}
