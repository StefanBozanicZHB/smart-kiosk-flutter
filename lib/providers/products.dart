import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products{
    return [..._products];
  }

  List<Product> get productsCash{
    return [..._products.where((product)=> product.paymentMethod == PaymentMethod.cash)];
  }

  List<Product> get productsCard{
    return [..._products.where((product)=> product.paymentMethod == PaymentMethod.card)];
  }

  Future<void> fetchAndSetProducts(kioskId) async {
    final url = 'http://app.smart-shop.rs/api/kiosks/$kioskId/products/all';

    try {
      final _response = await http.get(url);
      final List<Product> _loadingProducts = [];
      final _extractedData = json.decode(_response.body);

      if(_extractedData == null){
        return;
      }

      _extractedData.forEach((productData){
//        print(productData);
        _loadingProducts.add(Product(
            id: productData['id'],
            name: productData['name'],
            description: productData['description'],
            ingredients: productData['ingredients'],
            pictureUrl: AdditionalFunctions.IMAGE_URL_PREF + productData['picture_url'],
            price: productData['price'],
            quantity: productData['quantity'],
            paymentMethod: productData['payment_method'] == 'cash' ? PaymentMethod.cash : PaymentMethod.card,
          ));
      });

      _products = _loadingProducts.toList();

    } catch (error) {
      print(error);
      throw error;
    }
  }
}
