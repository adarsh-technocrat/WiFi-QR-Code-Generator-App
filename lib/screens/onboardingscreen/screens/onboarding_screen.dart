import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wifilink/responsiveui/sizeconfig.dart';
import 'package:wifilink/screens/onboardingscreen/utilities/styles.dart';
import 'package:wifilink/screens/widget/splashscreen.dart';

import '../../homepage.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin:
          EdgeInsets.symmetric(horizontal: 0.9795 * SizeConfig.hightMultiplier),
      height: 0.9795 * SizeConfig.hightMultiplier,
      width: isActive
          ? 2.9385 * SizeConfig.hightMultiplier
          : 1.9590 * SizeConfig.hightMultiplier,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xff3d486c),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color(0xff16181E),
                Color(0xff16181E),
                Color(0xff16181E),
                Color(0xff16181E),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: 4.89 * SizeConfig.hightMultiplier),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      print("skip");
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyHomePage()), (route) => false);
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 2.44 * SizeConfig.textMultiplier,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 73.4645 * SizeConfig.hightMultiplier,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.all(4.89 * SizeConfig.hightMultiplier),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage(
                                  'assets/EsteemedInfiniteIggypops-max-1mb.gif',
                                ),
                                height:
                                    76.5306122 * SizeConfig.imageSizeMultiplier,
                                width:
                                    76.5306122 * SizeConfig.imageSizeMultiplier,
                              ),
                            ),
                            SizedBox(height: 3.67 * SizeConfig.hightMultiplier),
                            Text(
                              'Search Wi-fi Near\nBy You ..',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: 1.83 * SizeConfig.hightMultiplier),
                            Text(
                              'Connect and Create  instant QR code with Avaliable Network near by you ...',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(4.89 * SizeConfig.hightMultiplier),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  color: Colors.white,
                                  child: SvgPicture.asset(
                                    'assets/qr-code.svg',
                                    height: 50 * SizeConfig.imageSizeMultiplier,
                                    width: 50 * SizeConfig.imageSizeMultiplier,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 130.0),
                            Text(
                              'Generate QR With \nOne Click .. ',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: 1.83 * SizeConfig.hightMultiplier),
                            Text(
                              'Quick and easy way to handel and share you wifi passwords... ',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(4.89 * SizeConfig.hightMultiplier),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: SvgPicture.asset(
                                'assets/2638951.svg',
                                height: 50 * SizeConfig.imageSizeMultiplier,
                                width: 50 * SizeConfig.imageSizeMultiplier,
                              ),
                            ),
                            SizedBox(height: 130),
                            Text(
                              'Easy to share your\nHotspot ..',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: 1.83 * SizeConfig.hightMultiplier),
                            Text(
                              'Create your own hotspot QR Code and share with People.. !!',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.all(4.89 * SizeConfig.hightMultiplier),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: [
                                Center(
                                  child: Image(
                                    image: AssetImage(
                                      'assets/IMG_20200715_181331.jpg',
                                    ),
                                    height: 76.5306122 *
                                        SizeConfig.imageSizeMultiplier,
                                    width: 76.5306122 *
                                        SizeConfig.imageSizeMultiplier,
                                  ),
                                ),
                                Positioned(
                                  top: 31.25*SizeConfig.hightMultiplier,
                                  left: 20.83*SizeConfig.hightMultiplier,

                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3.67*SizeConfig.hightMultiplier),
                                      child: Image(
                                        image: AssetImage(
                                          'assets/IMG_20200715_181254.jpg',
                                        ),
                                        height:
                                            20 * SizeConfig.imageSizeMultiplier,
                                        width:
                                            20 * SizeConfig.imageSizeMultiplier,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.67 * SizeConfig.hightMultiplier),
                            Text(
                              'Save and Share QR code \nin JPG and PDF formate.. ',
                              style: kTitleStyle,
                            ),
                            SizedBox(height: 1.83 * SizeConfig.hightMultiplier),
                            Text(
                              'You can convert the QR code in jpg and pdf fromate ..',
                              style: kSubtitleStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        2.6937 * SizeConfig.textMultiplier,
                                  ),
                                ),
                                SizedBox(
                                    width: 1.22 * SizeConfig.hightMultiplier),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 3.67 * SizeConfig.hightMultiplier,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Splashscreen()),
                    (route) => false);
              },
              child: Container(
                height: 6.12*SizeConfig.hightMultiplier,
                width: double.infinity,
                color: Colors.white,
                child: Center(
                  child: Text(
                    'Get started',
                    style: TextStyle(
                      color: Color(0xff283048),
                      fontSize: 2.45*SizeConfig.hightMultiplier,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
