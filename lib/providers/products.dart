import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kiosk/helpers/additional_%20functions.dart';

enum typeOfPaymentMethod {
  card,
  cash,
}

class ProductItem {
  final int id;
  final String name;
  final String description;
  final String pictureUrl;
  final String ingredients;
  final int price;
  final int quantity;
  final typeOfPaymentMethod paymentMethod;

  ProductItem({
    this.id,
    this.name,
    this.description,
    this.pictureUrl,
    this.ingredients,
    this.price,
    this.quantity,
    this.paymentMethod,
  });
}

class Products with ChangeNotifier {
  List<ProductItem> _products = [];

  List<ProductItem> get products{
    return [..._products];
  }

  List<ProductItem> get productsCash{
    return [..._products.where((product)=> product.paymentMethod == typeOfPaymentMethod.cash)];
  }

  List<ProductItem> get productsCard{
    return [..._products.where((product)=> product.paymentMethod == typeOfPaymentMethod.card)];
  }

  Future<void> fetchAndSetProducts(kioskId) async {
    final url = 'http://app.smart-shop.rs/api/kiosks/$kioskId/products/all';

    try {
      final response = await http.get(url);
      final List<ProductItem> _loadingProducts = [];
      final extractedData = json.decode(response.body);

      if(extractedData == null){
        return;
      }

      extractedData.forEach((productData){
//        print(productData);
        _loadingProducts.add(ProductItem(
            id: productData['id'],
            name: productData['name'],
            description: productData['description'],
            ingredients: productData['ingredients'],
            pictureUrl: AdditionalFunctions.IMAGE_URL_PREF + productData['picture_url'],
            price: productData['price'],
            quantity: productData['quantity'],
            paymentMethod: productData['payment_method'] == 'cash' ? typeOfPaymentMethod.cash : typeOfPaymentMethod.card,
          ));
      });

      _products = _loadingProducts.toList();

    } catch (error) {
      print(error);
      throw error;
    }
  }
}
