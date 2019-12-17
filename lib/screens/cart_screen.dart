import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/models/kiosk.dart';
import 'package:smart_kiosk/models/product.dart';
import 'package:smart_kiosk/providers/cart.dart';
import 'package:smart_kiosk/widgets/image_widget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final _cart = Provider.of<Cart>(context);
    return _cart.cart.isEmpty
        ? Container(
            child: Center(
              child: Text('Cart is empty!'),
            ),
          )
        : Container(
      padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _cartDetailsWidget(_cart.kiosk, _cart.paymentMethod, _cart.totalForPayment),
                Expanded(
                  child: ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        _productItem(_cart.cart[index]),
                      ],
                    );
                  },
                  itemCount: _cart.cart.length,
              ),
                )],
            ),
          );
  }
}

Widget _cartDetailsWidget(Kiosk kiosk, String paymentMethod, total) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: Text(
              '${kiosk.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
              '${paymentMethod.toUpperCase()}'),
          const SizedBox(
            width: 5,
          ),
          paymentMethod.toUpperCase() == 'CASH'
              ? Icon(Icons.monetization_on)
              : Icon(Icons.credit_card)
        ],
      ),
      const SizedBox(
        height: 3,
      ),
      Text(
          '${kiosk.streetName} ${kiosk.streetNumber}'),
      const SizedBox(
        height: 15,
      ),
      Container(
          width: double.infinity,
          child: Text(
            'Total price: ${total} RSD',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
          )),
    ],
  );
}


Widget _productItem(Product productCart) {
  return Column(
    children: <Widget>[
      Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageWidget(
                    imageUrl: '${productCart.pictureUrl}',
                  ),
                ),
              ),
              RotationTransition(
                turns: const AlwaysStoppedAnimation(-30 / 360),
                child: Stack(
                  children: <Widget>[
                    // Stroked text as border.
                    Text(
                      '${productCart.quantity}x',
                      style: TextStyle(
                        fontSize: 40,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = Colors.blue[700],
                      ),
                    ),
                    // Solid text as fill.
                    Text(
                      '${productCart.quantity}x',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${productCart.name}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${productCart.price} RSD'),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Total: ${productCart.price * productCart.quantity} RSD',
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
