import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbWifiManager {
  Database _database;

  Future openDb() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), "wifi.db"),
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE wifi(id INTEGER PRIMARY KEY autoincrement, wifiname TEXT, password TEXT)",
          );
        },
      );
    }
  }

  Future<int> insertwifi(Wificreds wifi) async {
    await openDb();
    return await _database.insert('wifi', wifi.toMap());
  }

  Future<List<Wificreds>> getwifiList() async {
    await openDb();
    final List<Map<String, dynamic>> maps = await _database.query('wifi');
    return List.generate(maps.length, (i) {
      return Wificreds(
          id: maps[i]['id'],
          wifiname: maps[i]['wifiname'],
          password: maps[i]['password']);
    });
  }

  Future<int> updateWifi(Wificreds wifi) async {
    await openDb();
    return await _database.update('wifi', wifi.toMap(),
        where: "id = ?", whereArgs: [wifi.id]);
  }

  Future<void> deleteWifi(int id) async {
    await openDb();
    await _database.delete('wifi', where: "id = ?", whereArgs: [id]);
  }
}

class Wificreds {
  int id;
  String wifiname;
  String password;
  Wificreds({@required this.wifiname, @required this.password, this.id});
  Map<String, dynamic> toMap() {
    return {'wifiname': wifiname, 'password': password};
  }
}
