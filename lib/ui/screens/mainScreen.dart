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
  final ScrollController _scrollController = ScrollController();
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
        bottomNavigationBar: Consumer<VpnProvider>(
            builder: (context, value, child) =>
                value.isPro ? SizedBox.shrink() : child!,
            child: SizedBox(
                height: 50,
                child: AdsProvider.adWidget(
                  context,
                  adsize: AdmobBannerSize(
                      height: 50,
                      width: MediaQuery.of(context).size.width.toInt(),
                      name: "full"),
                ))),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/19.png'))),
          child: SnappingSheet(
            controller: UIProvider.instance(context).sheetController,
            onSheetMoved: (position) {
              double _val = (100 / 600) * (position.pixels / 600);
              if (_val > 1) return;
              if (_val < 0.5) _val = 0;
              if (_val > 1) _val = 1;
              setState(() {
                selectServerOpacity = _val;
              });
            },
            initialSnappingPosition: SnappingPosition.factor(
              positionFactor: 0.0,
              snappingCurve: Curves.easeOutExpo,
              snappingDuration: Duration(seconds: 1),
              grabbingContentOffset: GrabbingContentOffset.top,
            ),
            snappingPositions: [
              SnappingPosition.factor(
                positionFactor: 0.0,
                snappingCurve: Curves.easeOutExpo,
                snappingDuration: Duration(seconds: 1),
                grabbingContentOffset: GrabbingContentOffset.top,
              ),
              SnappingPosition.factor(
                positionFactor: .8,
                snappingCurve: Curves.bounceOut,
                snappingDuration: Duration(seconds: 1),
                grabbingContentOffset: GrabbingContentOffset.bottom,
              ),
            ],
            grabbingHeight: 100,
            sheetBelow: SnappingSheetContent(
              child: Container(
                child: SelectVpnScreen(scrollController: _scrollController),
                decoration: BoxDecoration(
                  color: HexColor('221953'),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        offset: Offset(0, -1),
                        blurRadius: 10)
                  ],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
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
    return CustomCard(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      radius: 20,
      backgroundColor: Colors.white.withOpacity(1),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Selected Server',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Consumer<VpnProvider>(
                  builder: (context, value, child) => SizedBox(
                    height: 60,
                    child: TextButton(
                      style: ButtonStyle(
                          // TODO:
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side:
                                      BorderSide(color: Colors.transparent)))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          value.vpnConfig?.flag == null
                              ? SizedBox.shrink()
                              : (value.vpnConfig!.flag!
                                      .toLowerCase()
                                      .startsWith("http")
                                  ? CustomImage(
                                      url: value.vpnConfig!.flag,
                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.cover,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    )
                                  : Image.asset(
                                      "assets/icons/flags/${value.vpnConfig!.flag}.png",
                                      height: 50,
                                      width: 50,
                                    )),
                          RowDivider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                value.vpnConfig?.name ?? "Select server...",
                                style: TextStyle(color: Colors.white),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: (value.vpnConfig?.name ??
                                              "Select server...") ==
                                          'CZ_NEW'
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
                          Consumer<VpnProvider>(
                            builder: (context, value, child) => Text(
                              value.vpnConfig?.protocol?.toUpperCase() ?? "",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        BerandaPage.changeLocationClick(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
