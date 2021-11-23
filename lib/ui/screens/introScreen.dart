import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
//import 'package:lottie/lottie.dart';
import '../../core/utils/preferences.dart';
import '../../main.dart';
import 'package:dots_indicator/dots_indicator.dart';

class IntroScreen extends StatefulWidget {
  
  final RootState? rootState;

  const IntroScreen({Key? key, @required this.rootState}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  double currentposiiton = 0;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          IntroductionScreen(
            onChange: (page) {
              setState(() {
                currentposiiton = page.toDouble();
              });
            },
            pages: [
              custompageview(
                  height,
                  width,
                  'assets/images/Frame 2.png',
                  'A RELIABLE VPN',
                  'A reliable VPN protects you from information leaks \n if you use public WI-FI networks and beyond.'),
              custompageview(
                  height,
                  width,
                  'assets/images/Frame 3.png',
                  'SSL - CERTIFICATE',
                  '    Check the SSL certificate of the site, this way you\nprotect yourself from transferring your information if\n                                 the site is hacked.'),
              custompageview(
                  height,
                  width,
                  'assets/images/Frame 3(1).png',
                  'Malicious links'.toUpperCase(),
                  'Don\'t click on suspicious links and check the URL if\n                       you do decide to follow.')
            ],
            onDone: () {
              Preferences.init().then((value) {
                // ignore: invalid_use_of_protected_member
                widget.rootState!.setState(() {
                  value.saveFirstOpen();
                });
              });
            },
            dotsFlex: 0,
            isProgress: false,
            next: Padding(
              padding: EdgeInsets.only(
                bottom: height * 0.03,
              ),
              child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/Rectangle 90.png',
                        ),
                        fit: BoxFit.cover),
                  ),
                  height: height * 0.05,
                  width: width,
                  child: Center(
                    child: Text("Next",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  )),
            ),
            nextFlex: 50,
            done: Padding(
              padding: EdgeInsets.only(
                bottom: height * 0.03,
                right: width * 0.03,
              ),
              child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/Rectangle 90.png',
                        ),
                        fit: BoxFit.cover),
                  ),
                  height: height * 0.05,
                  width: width,
                  child: Center(
                    child: Text("Next",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  custompageview(height, width, icon, title, subtitle) {
    return PageViewModel(
        decoration:
            PageDecoration(fullScreen: true, imagePadding: EdgeInsets.all(0)),
        image: Container(
          child: Stack(
            children: [
              SizedBox(
                height: height,
                width: width,
                child: Image.asset(
                  'assets/images/15.png',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: SizedBox(
                  height: height - 420,
                  child: Column(
                    children: [
                      Container(
                        child: Center(child: Image.asset(icon)),
                        height: height - 573,
                        width: width - 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/Group 54.png',
                                ),
                                fit: BoxFit.cover)),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      DotsIndicator(
                        key: GlobalKey(),
                        decorator: DotsDecorator(
                          color: Colors.blue.withOpacity(0.3),
                          size: Size(width * 0.1, 3),
                          shape: const Border(),
                          activeSize: Size(width * 0.1, 3),
                          activeShape: RoundedRectangleBorder(),
                        ),
                        dotsCount: 3,
                        position: currentposiiton,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        title: "",
        body: '');
  }
}
