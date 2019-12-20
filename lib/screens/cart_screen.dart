import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/helpers/http_exception.dart';
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
                _cartDetailsWidget(_cart.kiosk, _cart.paymentMethodString,
                    _cart.totalForPayment),
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: _cart.cart.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: AdditionalFunctions.DURACTION_ANIMATION_LIST_VIEW_MILLISECONDS,
                          child: SlideAnimation(
                            verticalOffset: AdditionalFunctions.VERTICAL_OFF_SET_ANIMATION,
                            child: ScaleAnimation(
                              child: Dismissible(
                                key: ValueKey(_cart.cart[index].id),
                                background: Container(
                                  color: Theme.of(context).errorColor,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20),
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 4,
                                  ),
                                ),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction){
                                  _cart.detractCart(_cart.cart[index].id, 0);
                                },
                                child: Column(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _productItem(
                                        _cart.cart[index], _cart, context),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _cartDetailsWidget(Kiosk kiosk, String paymentMethod, total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              child: Expanded(
                child: Text(
                  '${kiosk.name}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Text('${paymentMethod.toUpperCase()}'),
            const SizedBox(
              width: 5,
            ),
            paymentMethod.toUpperCase() == 'CASH'
                ? const Icon(Icons.monetization_on)
                : const Icon(Icons.credit_card)
          ],
        ),
        const SizedBox(
          height: 3,
        ),
        Text('${kiosk.streetName} ${kiosk.streetNumber}'),
        const SizedBox(
          height: 15,
        ),
        Container(
            width: double.infinity,
            child: Text(
              'Total price: $total RSD',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            )),
      ],
    );
  }

  Widget _productItem(CartItem productCart, cartProvider, context) {
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('${productCart.quantity} x ${productCart.price} RSD'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${productCart.price * productCart.quantity} RSD',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(productCart.quantity - 1 == 0
                      ? Icons.delete
                      : Icons.remove_circle),
                  color: Colors.red,
                  iconSize: 30,
                  onPressed: () {
                    cartProvider.detractCart(
                        productCart.id, (productCart.quantity - 1));
                    print('remove item');
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_circle),
                  color: Colors.green,
                  iconSize: 30,
                  onPressed: () {
                    try {
                      cartProvider.addInCart(
                          Product(
                              paymentMethod: cartProvider.paymentMethod,
                              id: productCart.id),
                          cartProvider.kiosk,
                          (productCart.quantity + 1));
                    } on HttpException catch (error) {
                      _showSnackBar(context, error);
                    } catch (error) {
                      _showSnackBar(context, error);
                    }
                    print('add item');
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _showSnackBar(context, content) {
    Scaffold.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(content: Text('$content'));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
