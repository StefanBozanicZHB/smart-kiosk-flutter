import 'dart:ui' as prefix0;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_kiosk/providers/products.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductItem product;

  ProductItemWidget(this.product);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
//    print(height);
//    print(width);
    return GestureDetector(
      onTap: () {},
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                child: Image.network(
                  product.pictureUrl,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 5,
                left: 5,
                child: Container(
//                  width: width,
                  color: Colors.black54,
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  child: Text(
                    '${product.price} RSD',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              Positioned(
                top: -0,
                right: -0,
                bottom: 0,
                child: Container(
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.1, 0.2, 0.5, 0.9],
                      colors: [
                        Colors.white.withOpacity(0),
                        Colors.white.withOpacity(.2),
                        Colors.white.withOpacity(.6),
                        Colors.white.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          print('remove');
                        },
                        iconSize: 35,
                        icon: Icon(Icons.remove_circle),
                        color: Colors.red,
                      ),
                      IconButton(
                        onPressed: () {
                          print('cart');
                        },
                        iconSize: 35,
                        icon: Icon(Icons.shopping_cart),
                        color: Colors.red,
                      ),
                      IconButton(
                        onPressed: () {
                          print('add');
                        },
                        iconSize: 35,
                        icon: Icon(Icons.add_circle),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 50,
                left: 0,
                child: Container(
                  width: width,
                  color: Colors.black45,
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                  child: Text(
                    product.name,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    softWrap: true,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
