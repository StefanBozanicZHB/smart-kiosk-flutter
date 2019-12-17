class ResponseReservation {
  final bool success;
  final int idReservation;
  final int orderCode;
  final int errorCode;

//  final List<Product> products = [];

  ResponseReservation({
    this.success,
    this.idReservation,
    this.orderCode,
    this.errorCode,
//    this.products,
  });
}
