import 'package:smart_kiosk/helpers/additional_%20functions.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String pictureUrl;
  final String ingredients;
  final int price;
  int quantity;
  final PaymentMethod paymentMethod;
  final int unitPrice;

  Product({
    this.id,
    this.name,
    this.description,
    this.pictureUrl,
    this.ingredients,
    this.price,
    this.quantity,
    this.paymentMethod,
    this.unitPrice,
  });
}
