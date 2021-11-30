import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nizvpn/ui/page/privacy.dart';
import 'package:nizvpn/ui/page/sharePage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/provider/vpnProvider.dart';
import '../../core/resources/environment.dart';
import '../components/customDivider.dart';
import '../screens/aboutScreen.dart';
import '../screens/subscriptionDetailScreen.dart';

class PengaturanPage extends StatelessWidget {
  var txtstyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
  var trailingicon = Icon(
    Icons.arrow_forward_ios,
    color: Colors.white,
    size: 20,
  );

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var dividerLine = Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Container(
        width: width,
        color: Colors.white24,
        height: 2,
      ),
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/15.png'), fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _customAppBarWidget(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("setting_aboutus".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white)),
                      Divider(
                        height: 10,
                        color: Colors.transparent,
                      ),
                      InkWell(
                          onTap: () {
                            _privacyPolicyClick(context);
                          },
                          child:
                              settingscontent('Privacy Policy', Icons.policy)),
                      dividerLine,
                      InkWell(
                        onTap: _tosClick,
                        child: settingscontent(
                            'Terms of use', Icons.note_alt_sharp),
                      ),
                      dividerLine,
                      InkWell(
                          onTap: () {
                            SharePage.shareClick();
                          },
                          child: settingscontent('Share this', Icons.share)),
                      dividerLine,
                      InkWell(
                          onTap: () {
                            _rateUsClick();
                          },
                          child: settingscontent('Rate us', Icons.star)),
                      dividerLine,
                      Text("Account".tr(),
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Consumer<VpnProvider>(
                        builder: (context, value, child) {
                          return (value.isPro)
                              ? SizedBox.shrink()
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Divider(
                                      height: 10,
                                      color: Colors.transparent,
                                    ),
                                    // subscription
                                    InkWell(
                                      onTap: () {
                                        _subscriptionClick(context);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.card_giftcard,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          RowDivider(
                                            space: 10,
                                          ),
                                          Expanded(
                                              child: Text(
                                            'Subscription',
                                            style: txtstyle,
                                          )),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.cyan[200],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            width: width * 0.2,
                                            child: Center(
                                              child: Text(
                                                'Premium',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                          trailingicon
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                        },
                      ),
                      dividerLine,
                      // here!
                      settingscontent('Restore Purchase', Icons.shopping_cart),
                      dividerLine,
                      InkWell(
                        onTap: () {
                          _aboutClick(context);
                        },
                        child: settingscontent('Application version',
                            Icons.app_settings_alt_sharp),
                      ),
                      dividerLine,
                      ColumnDivider(space: 90),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingscontent(title, leading) {
    return Row(
      children: [
        Icon(
          leading,
          color: Colors.white,
          size: 30,
        ),
        RowDivider(
          space: 10,
        ),
        Expanded(
            child: Text(
          title,
          style: txtstyle,
        )),
        trailingicon
      ],
    );
  }

  void _subscriptionClick(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SubscriptionDetailScreen()));
  }

  void _checkUpdateClick(BuildContext context) async {
    AppUpdateInfo? resp = await CustomProgressDialog.future(
      context,
      future: InAppUpdate.checkForUpdate(),
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

    if (resp?.updateAvailability as bool? ?? false) {
      if (resp!.flexibleUpdateAllowed)
        return InAppUpdate.startFlexibleUpdate()
            .then((value) => InAppUpdate.completeFlexibleUpdate());
      if (resp.immediateUpdateAllowed)
        return InAppUpdate.performImmediateUpdate();
    } else {
      NAlertDialog(
        title: Text("no_update".tr()),
        content: Text(
          "latest_version".tr(),
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            child: Text("great".tr()),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)))),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show(context);
    }
  }

  void _rateUsClick() async {
    await InAppReview.instance.openStoreListing(appStoreId: appstoreId);
  }

  Widget _customAppBarWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "settings".tr(),
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _tosClick() {
    launch("https://nerdvpn.laskarmedia.id/term-of-services/");
  }

  void _privacyPolicyClick(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PrivacyPolicy()));
  }

  void _aboutClick(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AboutScreen()));
  }
}
