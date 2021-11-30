import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String? url;
  final double? width, height;
  final BorderRadius? borderRadius;
  final BoxFit? fit;
  final bool zoomOnTouch;
  final bool showBlackGradient;

  const CustomImage(
      {Key? key,
      required this.url,
      this.width,
      this.height,
      this.borderRadius,
      this.fit,
      this.zoomOnTouch = false,
      this.showBlackGradient = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: NetworkImage(url!), fit: BoxFit.cover)),
      child: ClipRRect(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            showBlackGradient
                ? Container(
                    decoration: BoxDecoration(),
                  )
                : SizedBox.shrink(),
            zoomOnTouch
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: SizedBox.shrink(),
                      onTap: () {},
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class BottomImageCityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 0),
    );
  }
}
