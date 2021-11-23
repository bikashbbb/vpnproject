// import 'package:firebase_admob/firebase_admob.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/core/resources/environment.dart';
import 'package:provider/provider.dart';

import 'vpnProvider.dart';

class AdsProvider extends ChangeNotifier {
  AdmobInterstitial? intersAd1;
  AdmobInterstitial? intersAd2;
  AdmobInterstitial? intersAd3;

  bool _footerBannerShow = false;
  dynamic _bannerAd;

  set footBannerShow(bool value) {
    _footerBannerShow = value;
    notifyListeners();
  }

  bool get footBannerShow => !showAds ? false : _footerBannerShow;

  get bannerIsAvailable => _bannerAd != null;

  AdmobInterstitial _intersAd1Create() => AdmobInterstitial(
      adUnitId: inters1,
      listener: (event, data) {
        if (event == AdmobAdEvent.closed) {
          intersAd1 = _intersAd1Create();
          intersAd1!.load();
        }
      });
  AdmobInterstitial _intersAd2Create() => AdmobInterstitial(
      adUnitId: inters2,
      listener: (event, data) {
        if (event == AdmobAdEvent.closed) {
          intersAd2 = _intersAd1Create();
          intersAd2!.load();
        }
      });
  AdmobInterstitial _intersAd3Create() => AdmobInterstitial(
      adUnitId: inters3,
      listener: (event, data) {
        if (event == AdmobAdEvent.closed) {
          intersAd3 = _intersAd1Create();
          intersAd3!.load();
        }
      });

  static void initAds(BuildContext context) {
    if (!showAds) return;
    AdsProvider adsProvider = AdsProvider.instance(context);

    adsProvider.intersAd1 = adsProvider._intersAd1Create();
    adsProvider.intersAd2 = adsProvider._intersAd2Create();
    adsProvider.intersAd3 = adsProvider._intersAd3Create();

    adsProvider.intersAd1?.load();
    adsProvider.intersAd2?.load();
    adsProvider.intersAd3?.load();
  }

  void showAd1(BuildContext context) async {
    if (!showAds) return;
    VpnProvider vpnProvider = VpnProvider.instance(context);
    if (vpnProvider.isPro) return;
    if ((await intersAd1?.isLoaded) ?? false) {
      intersAd1?.show();
    } else {
      intersAd1?.load();
    }
  }

  void showAd2(BuildContext context) async {
    if (!showAds) return;
    VpnProvider vpnProvider = VpnProvider.instance(context);
    if (vpnProvider.isPro) return;
    if ((await intersAd2?.isLoaded) ?? false) {
      intersAd2?.show();
    } else {
      intersAd2?.load();
    }
  }

  void showAd3(BuildContext context) async {
    if (!showAds) return;
    VpnProvider vpnProvider = VpnProvider.instance(context);
    if (vpnProvider.isPro) return;
    if ((await intersAd3?.isLoaded) ?? false) {
      intersAd3?.show();
    } else {
      intersAd3?.load();
    }
  }

  static Widget adWidget(BuildContext context, {String? bannerId, AdmobBannerSize? adsize}) {
    if (!showAds) return SizedBox.shrink();
    VpnProvider vpnProvider = VpnProvider.instance(context);
    if (vpnProvider.isPro) {
      return SizedBox.shrink();
    } else {
      // return SizedBox.shrink();
      return AdmobBanner(adUnitId: bannerId ?? banner1, adSize: adsize ?? AdmobBannerSize.SMART_BANNER(context));
    }
  }

  static Widget adbottomSpace() {
    if (!showAds) return SizedBox.shrink();
    return Consumer<AdsProvider>(
      builder: (context, value, child) => value.footBannerShow
          ? SizedBox(
              height: 50,
            )
          : SizedBox.shrink(),
    );
  }

  void removeBanner() {
    if (!showAds) return;
    footBannerShow = false;
    _bannerAd.dispose();
    _bannerAd = null;
  }

  static AdsProvider instance(BuildContext context) => Provider.of(context, listen: false);
}
