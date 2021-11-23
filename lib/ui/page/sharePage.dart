import 'package:easy_localization/easy_localization.dart';
//import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

class SharePage {
  static void shareClick() async {
    PackageInfo pinfo = await PackageInfo.fromPlatform();
    Share.share(
      "${"share_message".tr()}\nhttps://play.google.com/store/apps/details?id=" +
          (pinfo.packageName),
    );
  }
}
