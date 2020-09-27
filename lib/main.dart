import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifilink/enum/connectivityStatus.dart';
import 'package:wifilink/responsiveui/sizeconfig.dart';
import 'package:wifilink/screens/onboardingscreen/screens/onboarding_screen.dart';
import 'package:wifilink/screens/widget/splashscreen.dart';
import 'package:wifilink/service/connectivity_service.dart';


int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen =  prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen $initScreen');
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return StreamProvider<ConnectivityStatus>(
        builder: (context) => ConnectivityServices().connectionStatusController,
        child: LayoutBuilder(builder: (context, constraints) {
          return OrientationBuilder(builder: (context, orientation) {
            SizeConfig.init(constraints, orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.grey,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              initialRoute: initScreen == 0 || initScreen == null ? "first" : "/",
          routes: {
            "/": (context) => Splashscreen(),
            "first": (context) => OnboardingScreen(),
          },
            );
          });
        }));
  }
}
