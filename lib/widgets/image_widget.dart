import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final width;
  final height;
  final imageUrl;
  final assetAddressPlaceHolder;
  final assetAddressError;
  final BoxFit boxFit;

  ImageWidget({
    @required this.imageUrl,
    this.width = 100.0,
    this.height = 100.0,
    this.assetAddressError = 'assets/images/no_product_image.jpg',
    this.assetAddressPlaceHolder = 'assets/gif/loading_gif.gif',
    this.boxFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: boxFit,
      imageUrl: imageUrl,
      placeholder: (context, url) =>
      new Container(
          height: height,
          width: width,
          padding: EdgeInsets.all(20),
          child: Image.asset(
            assetAddressPlaceHolder,
            fit: BoxFit.contain,
          )),
      errorWidget: (context, url, error) =>
          Container(
              height: height,
              width: width,
              child: Image.asset(
                assetAddressError,
              fit: boxFit,
              )),
    );
  }
}
