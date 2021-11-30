import 'dart:ui';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/core/provider/vpnProvider.dart';
import 'package:nizvpn/ui/components/customDivider.dart';
import 'package:nizvpn/ui/components/customImage.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import '../../core/provider/adsProvider.dart';
import '../../core/provider/uiProvider.dart';
import '../components/customCard.dart';
import '../page/homePage.dart';
import '../page/settingsPage.dart';
import 'selectVpnScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double selectServerOpacity = 0;
  bool dragstarted = false;
  final ScrollController _scrollController = ScrollController();
  final PageController pageController = PageController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      AdsProvider.initAds(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double grabheight = 90;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (UIProvider.instance(context).sheetController.currentPosition >
            300) {
          UIProvider.instance(context)
              .sheetController
              .snapToPosition(SnappingPosition.factor(positionFactor: .08));
          return false;
        }
        MainScreenProvider provider = MainScreenProvider.instance(context);
        if (provider.pageIndex > 0) {
          provider.pageIndex--;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Consumer<VpnProvider>(
            builder: (context, value, child) =>
                value.isPro ? SizedBox.shrink() : child!,
            child: SingleChildScrollView(
              child: SizedBox(
                  height: 50,
                  child: AdsProvider.adWidget(
                    context,
                    adsize: AdmobBannerSize(
                        height: 50,
                        width: MediaQuery.of(context).size.width.toInt(),
                        name: "full"),
                  )),
            )),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/19.png'))),
          child: SnappingSheet(
            // TODO

            controller: UIProvider.instance(context).sheetController,

            onSheetMoved: (position) {
              double _val = (100 / 600) * (position.pixels / 600);
              if (_val > 1) return;
              if (_val < 0.5) _val = 0;
              if (_val > 1) _val = 1;
              if (position.pixels >= 70) {
                setState(() {
                  dragstarted = true;
                  grabheight = 500;
                });
              } else if (position.pixels <= 70) {
                setState(() {
                  dragstarted = false;
                  grabheight = 90;
                });
              }
              setState(() {
                selectServerOpacity = _val;
              });
            },
            initialSnappingPosition: SnappingPosition.factor(
              positionFactor: 0.0,
              snappingDuration: Duration(seconds: 1),
              grabbingContentOffset: GrabbingContentOffset.top,
            ),
            snappingPositions: [
              SnappingPosition.factor(
                positionFactor: 0.0,
                snappingDuration: Duration(seconds: 1),
                grabbingContentOffset: GrabbingContentOffset.top,
              ),
              SnappingPosition.factor(
                positionFactor: .8,
                snappingDuration: Duration(seconds: 1),
                grabbingContentOffset: GrabbingContentOffset.bottom,
              ),
            ],
            grabbingHeight: grabheight,
            sheetBelow: SnappingSheetContent(
              child: Container(
                child: SelectVpnScreen(
                  scrollController: _scrollController,
                  buttononly: false,
                ),
                decoration: BoxDecoration(
                  color: HexColor('221953'),
                ),
              ),
            ),
            grabbing: _customBottomNavBar(),
            child: Stack(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: height * 0.03, left: width * 0.8),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (con) {
                        return PengaturanPage();
                      }));
                    },
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: Consumer<MainScreenProvider>(
                        builder: (context, value, child) => [
                          BerandaPage(),
                          PengaturanPage(),
                        ][value.pageIndex],
                      ),
                    ),
                    AdsProvider.adbottomSpace()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        color: HexColor('221953'),
      ),
      child: CustomCard(
        isCircle: true,
        backgroundColor: Colors.white.withOpacity(1),
        child: Stack(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 15, left: 0, right: 0),
                child: dragstarted
                    ? Padding(
                        padding: const EdgeInsets.only(
                            top: 15, right: 30, left: 140),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Server Lists',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700),
                            ),
                            RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.deepPurple[400],
                              ),
                            )
                          ],
                        ),
                      )
                    : Consumer<VpnProvider>(
                        builder: (context, value, child) => SizedBox(
                          height: 60,
                          child: TextButton(
                            style: ButtonStyle(
                                // TODO:
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                            color: Colors.transparent)))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                value.vpnConfig?.flag == null
                                    ? SizedBox.shrink()
                                    : (value.vpnConfig!.flag!
                                            .toLowerCase()
                                            .startsWith("http")
                                        ? Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle),
                                          child: CustomImage(
                                            height: 60,
                                            width: 60,
                                            url: value.vpnConfig!.flag,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        : Container(
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Image.asset(
                                              "assets/icons/flags/${value.vpnConfig!.flag}.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                          )),
                                RowDivider(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value.vpnConfig?.name ??
                                          "Select server...",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: (value.vpnConfig?.name ??
                                                    "Select server...") !=
                                                "Select server..."
                                            ? Row(
                                                children: [
                                                  Icon(
                                                    Icons.wifi,
                                                    size: 20,
                                                    color: Colors.green[400]!
                                                        .withOpacity(0.7),
                                                  ),
                                                  Text(
                                                    '120 ms',
                                                    style: TextStyle(
                                                        color: Colors.white38),
                                                  )
                                                ],
                                              )
                                            : null)
                                  ],
                                ),
                                Expanded(child: RowDivider()),
                                RotatedBox(
                                  quarterTurns: 3,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.deepPurple[400],
                                  ),
                                )
                              ],
                            ),
                            onPressed: () {
                              BerandaPage.changeLocationClick(context);
                            },
                          ),
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}

class MainScreenProvider extends ChangeNotifier {
  int _curIndex = 0;

  int get pageIndex => _curIndex;
  set pageIndex(int value) {
    _curIndex = value;
    notifyListeners();
  }

  static MainScreenProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);
}
