import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
//import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../core/provider/adsProvider.dart';
import '../../core/provider/purchaseProvider.dart';
import '../../core/provider/vpnProvider.dart';
import '../../core/resources/warna.dart';
import '../components/customDivider.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  @override
  _SubscriptionDetailScreenState createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  String? _selectedId;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((val) {
      PurchaseProvider value = PurchaseProvider.instance(context);
      if (value.subscriptionProducts != null &&
          value.subscriptionProducts!.length > 0) {
        setState(() {
          _selectedId = "one_month_subs";
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(
      builder: (context, value, child) {
        if (value.isPro)
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(LineIcons.windowClose),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/28.png'))),
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /*  LottieBuilder.asset(
                        "assets/animations/crown.json",
                        height: 150,
                        width: 150,
                        fit: BoxFit.contain,
                      ),*/
                      ColumnDivider(),
                      Text(
                        "great".tr(),
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "premium_purchased".tr(),
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        else
          return _subscribeBody(context);
      },
    );
  }

  Widget _subscribeBody(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/28(2).png'))),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: height * 0.74,
              left: width * 0.12,
              right: width * 0.12,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/Rectangle 90.png',
                        ),
                        fit: BoxFit.cover),
                  ),
                  height: height * 0.06,
                  width: width - 50,
                  child: Center(
                    child: Text("Start",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  )),
            ),
            Positioned(
              bottom: height * 0.28,
              left: width * 0.12,
              right: width * 0.12,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple),
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20)),
                height: height * 0.12,
                child: Column(
                  children: [
                    Text(
                      'Weekly',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24),
                    ),
                    Text(
                      '(The first 3 days are free)',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.015),
                      child: Text(
                        'Automatically renews 699.00 rub/week',
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    )
                  ],
                ),
              ), /* Image.asset('assets/images/Group 83.png'), */
            ),
            Container(
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: Container()),
                        CloseButton(
                          color: Colors.white,
                        ),
                        RowDivider(),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              top: 20, left: 20, right: 20, bottom: 80),
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [primaryColor, accentColor],
                                ).createShader(bounds);
                              },
                            ),
                            ColumnDivider(space: 5),
                            ColumnDivider(space: 5),
                            _listPremium(),
                            ColumnDivider(space: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 50,
        // here
      ),
      bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }

  Widget _listPremium() {
    return Consumer<PurchaseProvider>(
      builder: (context, value, child) {
        if (value.subscriptionProducts != null &&
            (value.subscriptionProducts?.length ?? 0) > 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: value.subscriptionProducts!.map(
              (e) {
                String harga = e.currency! +
                    " " +
                    (e.price!.contains(".")
                        ? e.price!.split(".").first
                        : e.price!);
                String label = "";
                switch (e.productId) {
                  case "one_year_subs":
                    label = "Yearly";
                    break;
                  case "one_month_subs":
                    label = "Monthly";
                    break;
                  case "one_week_subs":
                    label = "Weekly";
                    break;
                }
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedId = e.productId;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                RowDivider(space: 5),
                                e.productId == "one_month_subs"
                                    ? Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                            color: accentColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          "most_popular".tr(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                          ),
                          Text(
                            harga,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          RowDivider(),
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: _selectedId == e.productId
                                  ? Icon(LineIcons.check, color: accentColor)
                                  : SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _selectedId == e.productId
                            ? accentColor
                            : Colors.transparent,
                        width: 2),
                  ),
                );
              },
            ).toList(),
          );
        } else {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Text(
              "".tr(),
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }

  /*  void _subscribeClick() async {
    PurchaseProvider purchaseProvider = PurchaseProvider.instance(context);
    await purchaseProvider.subscribe(_selectedId!);
  } */
}

class CustomInfoWidget extends StatelessWidget {
  final double? leftTop;
  final double? leftBottom;
  final double? rightTop;
  final Widget? child;

  const CustomInfoWidget(
      {Key? key, this.leftTop, this.leftBottom, this.rightTop, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 40,
      decoration: BoxDecoration(
        color: greyMuchWhite,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(leftBottom ?? 0),
          topRight: Radius.circular(rightTop ?? 0),
          topLeft: Radius.circular(leftTop ?? 0),
        ),
      ),
      child: child,
    );
  }
}
