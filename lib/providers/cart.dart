import 'package:flutter/material.dart';
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/helpers/http_exception.dart';
import 'package:smart_kiosk/models/kiosk.dart';
import 'package:smart_kiosk/models/product.dart';

class Cart with ChangeNotifier {
  static Product product = Product(
    paymentMethod: PaymentMethod.cash,
    quantity: 2,
    price: 55,
    pictureUrl: 'asdas',
    name: 'Coca cola',
    id: 32,
    ingredients: 'nesto',
    description: 'nesto',
  );
  static Kiosk kioskProba = Kiosk(
    id: 8,
    name: 'Beogradski sajam',
    streetNumber: '14',
    streetName: 'Bulevar vojvode Misica',
  );
//  List<Product> _cart = [product];
  List<Product> _cart = [];
//  Kiosk _cartKiosk = kioskProba;
  Kiosk _cartKiosk;
//  PaymentMethod _paymentMethod = PaymentMethod.cash;
  PaymentMethod _paymentMethod;

  List<Product> get cart {
    return [..._cart];
  }

  int get cartCount {
    int _sum = 0;
    _cart.forEach((productCart)=>_sum += productCart.quantity);
    return _sum;
  }

  String get paymentMethod{
    if(_paymentMethod == PaymentMethod.card)
      return 'CARD';
    else
      return 'CASH';
  }

  Kiosk get kiosk{
    return _cartKiosk;
  }

  addInCart(Product product, Kiosk kiosk, int quntity) {
    try {
      if (_cart.isEmpty) {
        Product _newProduct = product;
        _newProduct.quantity = quntity;
        _cart.add(_newProduct);
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
        }
        else {
          Product newProduct = product;
          newProduct.quantity = quntity;
          _cart.add(newProduct);
        }
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  detractCart(Product product, quantity){
    int _indexInCart = _cart.indexWhere((cartProduct) => cartProduct.id == product.id);
    if(quantity == 0)
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
    int _intdex = _cart.indexWhere((item)=>item.id == product.id);

    if(_intdex > -1){
      _countProductInCart = _cart[_intdex].quantity;
    }

    return _countProductInCart;
  }

  double get totalForPayment{
    var _total = 0.0;
    _cart.forEach((productCart)=> _total += (productCart.price* productCart.quantity));
    print(_total);
    return _total;
  }

  void clearCart(){
    _cart = [];
    _cartKiosk = null;
    _paymentMethod = null;
    notifyListeners();
  }
}
