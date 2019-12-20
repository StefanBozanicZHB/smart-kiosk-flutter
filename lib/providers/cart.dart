import 'package:flutter/material.dart';
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/helpers/http_exception.dart';
import 'package:smart_kiosk/models/kiosk.dart';
import 'package:smart_kiosk/models/product.dart';

class CartItem {
  final int id;
  final String name;
  final String pictureUrl;
  final int price;
  int quantity;

  CartItem({this.id, this.name, this.pictureUrl, this.price, this.quantity});
}

class Cart with ChangeNotifier {
//  static CartItem product = CartItem(
//    quantity: 2,
//    price: 55,
//    pictureUrl: 'asdas',
//    name: 'Coca cola',
//    id: 32,
//  );
//
//  static Kiosk kioskProba = Kiosk(
//    id: 8,
//    name: 'Beogradski sajam',
//    streetNumber: '14',
//    streetName: 'Bulevar vojvode Misica',
//  );
//
//  List<CartItem> _cart = [product];
//  Kiosk _cartKiosk = kioskProba;
//  PaymentMethod _paymentMethod = PaymentMethod.cash;

  List<CartItem> _cart = [];
  Kiosk _cartKiosk;
  PaymentMethod _paymentMethod;

  List<CartItem> get cart {
    return [..._cart];
  }

  int get cartCount {
    int _sum = 0;
    _cart.forEach((productCart) => _sum += productCart.quantity);
    return _sum;
  }

  String get paymentMethodString {
    if (_paymentMethod == PaymentMethod.card)
      return 'CARD';
    else
      return 'CASH';
  }

  PaymentMethod get paymentMethod {
    return _paymentMethod;
  }

  Kiosk get kiosk {
    return _cartKiosk;
  }

  addInCart(Product product, Kiosk kiosk, int quntity) {
    CartItem _newCartItem;
    try {
      if (_cart.isEmpty) {
        _newCartItem = CartItem(
          name: product.name,
          id: product.id,
          pictureUrl: product.pictureUrl,
          price: product.price,
          quantity: quntity,
        );
        _cart.add(_newCartItem);
        _cartKiosk = kiosk;
        _paymentMethod = product.paymentMethod;
      } else {
        if (kiosk.id != _cartKiosk.id) throw HttpException('Different kiosk');

        if (product.paymentMethod != _paymentMethod)
          throw HttpException('Different payment method');

        int available = 3;
        _cart.forEach((cartProduct) => available -= cartProduct.quantity);

        int indexInCart =
            _cart.indexWhere((cartProduct) => cartProduct.id == product.id);

        if (indexInCart >= 0) available += _cart[indexInCart].quantity;

        if (available <= 0) throw HttpException('Cart is full. 3 is maximum');

        if (quntity > available)
          throw HttpException(
              'Not available space. Just $available space for this product');

        if (indexInCart >= 0) {
          _cart[indexInCart].quantity = quntity;
        } else {
          _newCartItem = CartItem(
            name: product.name,
            id: product.id,
            pictureUrl: product.pictureUrl,
            price: product.price,
            quantity: quntity,
          );
          _cart.add(_newCartItem);
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  detractCart(int productId, quantity) {
    int _indexInCart =
        _cart.indexWhere((cartProduct) => cartProduct.id == productId);
    if (quantity == 0)
      _cart.removeAt(_indexInCart);
    else
      _cart[_indexInCart].quantity = quantity;
    notifyListeners();
  }

  int countProductInCart(Product product, Kiosk kiosk) {
    if (_cart.isEmpty ||
        kiosk.id != _cartKiosk.id ||
        product.paymentMethod != _paymentMethod) return 0;

    int _countProductInCart = 0;
    int _intdex = _cart.indexWhere((item) => item.id == product.id);

    if (_intdex > -1) {
      _countProductInCart = _cart[_intdex].quantity;
    }

    return _countProductInCart;
  }

  double get totalForPayment {
    var _total = 0.0;
    _cart.forEach(
        (productCart) => _total += (productCart.price * productCart.quantity));
    print(_total);
    return _total;
  }

  void clearCart() {
    _cart = [];
    _cartKiosk = null;
    _paymentMethod = null;
    notifyListeners();
  }
}
