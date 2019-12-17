import 'package:smart_kiosk/models/product.dart';

class ResponseReservationDetails {
  final int id;
  final String kioskName;
  final String kioskAddressStreet;
  final String kioskAddressNumber;
  final String paymentMethod;
  final int orderCode;
  final String statusOrder;
  final String timeLastChange;
  final int price;
  List<Product> productList = [];

  ResponseReservationDetails({
    this.id,
    this.kioskName,
    this.kioskAddressStreet,
    this.kioskAddressNumber,
    this.paymentMethod,
    this.orderCode,
    this.statusOrder,
    this.timeLastChange,
    this.price,
    this.productList,
  });

}
