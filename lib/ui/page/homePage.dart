import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../../core/provider/adsProvider.dart';
import '../../core/provider/uiProvider.dart';
import '../../core/provider/vpnProvider.dart';
import '../../core/resources/environment.dart';
import '../../core/resources/nerdVpnIcons.dart';
import '../../core/utils/NizVPN.dart';
import '../../core/utils/preferences.dart';
import '../components/customDivider.dart';

class BerandaPage extends StatefulWidget {
  static void changeLocationClick(context) async {
    UIProvider.instance(context)
        .sheetController
        .snapToPosition(SnappingPosition.factor(positionFactor: .8));
  }

  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  var height;
  var width;
  @override
  void didChangeDependencies() {
    VpnProvider.refreshInfoVPN(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _customAppBarWidget(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: _body(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColumnDivider(space: 20),

        ColumnDivider(space: 20),
        SizedBox(
          height: 200,
          child: _connectButtonWidget(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<VpnProvider>(builder: (context, object, child) {
              return object.getVPnstage() == "disconnected" ||
                      object.getVPnstage() == "DISCONNECTED"
                  ? Text(
                      'Tap the button to connect'.tr(),
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )
                  : SizedBox();
            }),
          ],
        ),
        //ColumnDivider(space: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _topMessageWidget(),
          ],
        ),
        //_currentLocationWidget(),
        _connectionInfo(),
        ColumnDivider(space: 90),
      ],
    );
  }

  Widget _connectionInfo() {
    return Container(
      height: 100,
      child: Consumer<VpnProvider>(
        builder: (context, snapshot, child) {
          String byteIn = "0,0";
          String byteOut = "0,0 ";

          if (snapshot.vpnStatus != null) {
            byteIn = snapshot.vpnStatus!.byteIn!.trim().length == 0
                ? "0,0 kB/s"
                : snapshot.vpnStatus!.byteIn!.trim();
            byteOut = snapshot.vpnStatus!.byteOut!.trim().length == 0
                ? "0,0 kB/s"
                : snapshot.vpnStatus!.byteOut!.trim();
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      horizontalTitleGap: 0,
                      minLeadingWidth: 0,
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 40, top: 8),
                        child: Icon(
                          Icons.arrow_circle_down,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(right: 14),
                        child: Text(
                          "download".tr(),
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text(
                                (byteIn.split('k')[0]),
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'KB/s',
                                style: TextStyle(color: Colors.white60),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 8, left: 10),
                        child: Icon(
                          Icons.arrow_circle_up,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      horizontalTitleGap: 0,
                      minLeadingWidth: 0,
                      title: Padding(
                        padding: const EdgeInsets.only(right: 65),
                        child: Text(
                          "upload".tr(),
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                byteOut.split('k')[0],
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'KB/s',
                                style: TextStyle(color: Colors.white60),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _currentLocationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "current_location".tr(),
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          ColumnDivider(
            space: 5,
          ),
          // here
          //_changeLocationClick();
        ],
      ),
    );
  }

  Widget _connectButtonWidget() {
    return Consumer<VpnProvider>(
      builder: (context, value, child) {
        String info;
        var image = NerdVPNIcon.power;
        // Color focusColor = greyLittleWhite;

        String stage = (value.vpnStage ?? NVPN.vpnDisconnected).toLowerCase();
        if (stage == NVPN.vpnConnected.toLowerCase()) {
          image = AssetImage('assets/images/Group 18(2).png');
          info = 'STOP';
        } else if (stage != NVPN.vpnDisconnected.toLowerCase() || stage == "") {
          image = AssetImage('assets/images/Group 18(1).png');
          info = 'CONNECTING';
        } else {
          image = AssetImage('assets/images/Group 18.png');
          info = 'START';
        }
        return Center(
          child: Container(
            alignment: Alignment(0, 0.3),
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image,
              ),
              shape: BoxShape.circle,
            ),
            child: TextButton(
                // focusColor: focusColor,
                onPressed: () {
                  _connectVPNClick(value);
                },
                child: Text(
                  info.tr(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20),
                )),
          ),
        );
      },
    );
  }

  Widget _topMessageWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Consumer<VpnProvider>(
        builder: (context, value, child) {
          String tulisan = "Disconnected".tr();
          Color color = Colors.red;

          String stage = (value.vpnStage ?? NVPN.vpnDisconnected).toLowerCase();
          if (stage == NVPN.vpnConnected.toLowerCase()) {
            tulisan = "protected".tr();
            color = Colors.green;
          } else if (stage != NVPN.vpnDisconnected.toLowerCase()) {
            tulisan = value.vpnStage!.replaceAll("_", " ");
            color = Colors.orange;
          } else {
            tulisan = "Disconnected".tr();
            color = Colors.white;
          }
          return RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "status: ",
                  style:
                      GoogleFonts.poppins(fontSize: 15, color: Colors.white)),
              TextSpan(
                  text: tulisan.toUpperCase(),
                  style: GoogleFonts.poppins(fontSize: 15, color: color)),
            ]),
          );
        },
      ),
    );
  }

  Widget _customAppBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: "$appname ",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
          Consumer<VpnProvider>(
            builder: (context, value, child) {
              if (value.isPro) {
                return Positioned(
                  child: CupertinoButton(
                    padding: EdgeInsets.only(),
                    onPressed: () {},
                    child: Row(
                      children: [],
                    ),
                  ),
                  right: 0,
                );
              }
              return Container(); /* Positioned(
                child: CupertinoButton(
                  color: Colors.white,
                  padding: EdgeInsets.only(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscriptionDetailScreen()));
                  },
                  child: Row(
                    children: [],
                  ),
                ),
                right: 0,
              ); */
            },
          )
        ],
      ),
    );
  }

  void _connectVPNClick(VpnProvider vpnProvider) async {
    if (vpnProvider.vpnStage != NVPN.vpnDisconnected &&
        (vpnProvider.vpnStage?.length ?? 0) > 0) {
      if (vpnProvider.vpnStage == NVPN.vpnConnected) {
        var resp = await NAlertDialog(
          dialogStyle: DialogStyle(
              titleDivider: true, contentPadding: EdgeInsets.only()),
          title: Text("${"disconnect".tr()}?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text("disconnect_question".tr()),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("disconnect".tr()),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)))),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text("cancel".tr()),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)))),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ).show(context);

        AdsProvider.instance(context).showAd2(context);
        if (resp ?? false) {
          NVPN.stopVpn();
        }
      } else {
        NVPN.stopVpn();
      }
    } else {
      if (vpnProvider.vpnConfig != null) {
        if (vpnProvider.vpnConfig!.status == 1 && !vpnProvider.isPro) {
          return VpnProvider.renewSubs(context);
        }
        if (vpnProvider.vpnConfig!.config == null &&
            vpnProvider.vpnConfig!.slug != null) {
          await CustomProgressDialog.future(
            context,
            future: vpnProvider.setConfig(context, vpnProvider.vpnConfig!.slug,
                vpnProvider.vpnConfig!.protocol),
            dismissable: false,
            loadingWidget: Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
          return _connectVPNClick(vpnProvider);
        }
      } else {
        return NAlertDialog(
          title: Text("unknown_server".tr()),
          content: Text("select_a_server".tr()),
          actions: [
            TextButton(
              onPressed: () => UIProvider.instance(context)
                  .sheetController
                  .snapToPosition(SnappingPosition.factor(positionFactor: .8)),
              child: Text("choose_server".tr()),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)))),
            )
          ],
        ).show(context);
      }

      Future.delayed(Duration(seconds: 5)).then((value) async {
        if ((await Preferences.init()).shared.getBool("show_dialog") ?? false)
          return;
        if (Random().nextBool()) {
          NAlertDialog(
            title: Text("rating_title".tr()),
            content: Text("rating_description".tr()),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("rating_done".tr())),
              TextButton(
                child: Text("rating_goto".tr()),
                onPressed: () {
                  InAppReview.instance.openStoreListing();
                  Navigator.pop(context);
                },
              ),
            ],
          ).show(context).then((value) async {
            Preferences.init().then((value) {
              value.shared.setBool("show_dialog", true);
            });
          });
        }
      });

      AdsProvider.instance(context).showAd1(context);
      await NVPN.startVpn(vpnProvider.vpnConfig!);
    }
  }
}
