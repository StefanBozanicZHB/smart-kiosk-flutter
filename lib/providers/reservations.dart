import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/helpers/http_exception.dart';
import 'package:smart_kiosk/models/Product.dart';
import 'package:smart_kiosk/models/ResponseReservation.dart';
import 'package:smart_kiosk/models/ResponseReservationDetails.dart';

class ReservatioItem {
  final int id;
  final String kioskName;
  final String paymentMethod;
  int reservationStatusId;
  final String timeLastChange;
  final int price;
  final color;
  final icon;
  final String statusMessage;

  ReservatioItem({
    this.id,
    this.kioskName,
    this.paymentMethod,
    this.reservationStatusId,
    this.timeLastChange,
    this.price,
    this.color,
    this.icon,
    this.statusMessage,
  });
}

class Reservations with ChangeNotifier {
  List<ReservatioItem> _reservations = [];
  ResponseReservationDetails reservationDetails;
  var userId;

  List<ReservatioItem> get reservation {
    return [..._reservations];
  }

  Future<void> fetchAndSetReservation() async {
    userId = await AdditionalFunctions().getDeviceId();

    final url = 'http://app.smart-shop.rs/api/orders_by_device/$userId';
    try {
      final response = await http.get(url);
      final List<ReservatioItem> _loadedReservation = [];
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((reservationData) {
        print(reservationData);

        var color = Colors.green;
        var icon = Icons.check;
        String message;

        switch (reservationData['status_order_id']) {
          case 1:
            color = Colors.green;
            icon = Icons.alarm;
            message = 'Reservation received';
            break;
          case 2:
            color = Colors.green;
            icon = Icons.check;
            message = 'Reservation successfully forwarded to kiosk';
            break;
          case 3:
            color = Colors.yellow;
            icon = Icons.warning;
            message = 'Reservation unsuccessfully forwarded to kiosk';
            break;
          case 4:
            color = Colors.yellow;
            icon = Icons.backup;
            message =
                'Reservation successfully forwarded to kiosk, but kiosk could not reserve products';
            break;
          case 5:
            color = Colors.green;
            icon = Icons.check;
            message = 'Buying successful';
            break;
          case 2:
            color = Colors.red;
            icon = Icons.not_interested;
            message = 'Buying unsuccessful';
            break;
          case 7:
            color = Colors.red;
            icon = Icons.alarm_off;
            message = 'Reservation expired';
            break;
          case 8:
            color = Colors.green;
            icon = Icons.not_interested;
            message = 'Reservation canceled';
            break;
        }

        _loadedReservation.add(ReservatioItem(
          id: reservationData['id'],
          kioskName: reservationData['kiosk_name'],
          paymentMethod: reservationData['payment_method'],
          reservationStatusId: reservationData['status_order_id'],
          timeLastChange: convertDateInLocal(reservationData['time_last_change']),
          price: reservationData['price'],
          color: color,
          icon: icon,
          statusMessage: message,
        ));
      });

      _reservations = _loadedReservation.toList();

//      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  String convertDateInLocal(String time) {
    DateTime datum = DateTime.parse(time).toLocal();
    var dateFormat = new DateFormat('dd.MM.yyyy HH:mm');
    return dateFormat.format(datum);
  }

  Future<ResponseReservation> updateReservation(int reservationId) async {
    final url = 'http://app.smart-shop.rs/api/orders/$reservationId?action=1';

    final response = await http.patch(url);
    final extractedData = json.decode(response.body);

    var responseReservation = ResponseReservation(
      success: extractedData['success'],
      idReservation: extractedData['id_reservation'],
      orderCode: extractedData['order_code'],
      errorCode: extractedData['error_code'],
    );

    print(reservationId);

    if (extractedData['success']) {
      final reservationIndex =
          _reservations.indexWhere((reserv) => reserv.id == reservationId);
      _reservations[reservationIndex].reservationStatusId = 1;
      notifyListeners();
    }

    print(extractedData['success']);
    return responseReservation;
  }

  Future<void> fetchAndSetReservationDetails(reservationId) async {
    final url = 'http://app.smart-shop.rs/api/orders/$reservationId';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);

      if (extractedData == null) {
        return null;
      }

      String message;
      switch (extractedData['status_order_id']) {
        case 1:
          message = 'Reservation received';
          break;
        case 2:
          message = 'Reservation successfully forwarded to kiosk';
          break;
        case 3:
          message = 'Reservation unsuccessfully forwarded to kiosk';
          break;
        case 4:
          message =
              'Reservation successfully forwarded to kiosk, but kiosk could not reserve products';
          break;
        case 5:
          message = 'Buying successful';
          break;
        case 2:
          message = 'Buying unsuccessful';
          break;
        case 7:
          message = 'Reservation expired';
          break;
        case 8:
          message = 'Reservation canceled';
          break;
      }

      final ResponseReservationDetails loadedReservationDetails =
          ResponseReservationDetails(
        id: extractedData['id'],
        kioskName: extractedData['kiosk_name'],
        kioskAddressStreet: extractedData['kiosk_address_street'],
        kioskAddressNumber: extractedData['kiosk_address_number'],
        paymentMethod: extractedData['payment_method'],
        orderCode: extractedData['order_code'],
        statusOrder: message,
        timeLastChange: convertDateInLocal(extractedData['time_last_change']),
        price: extractedData['price'],
        productList: (extractedData['product_list'] as List<dynamic>)
            .map((item) => Product(
                  id: item['id'],
                  description: item['description'],
                  name: item['name'],
                  quantity: item['quantity'],
                  ingredients: item['ingredients'],
                  pictureUrl: AdditionalFunctions.IMAGE_URL_PREF + item['picture_url'],
                  unitPrice: item['unit_price'],
                ))
            .toList(),
      );

      reservationDetails = loadedReservationDetails;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteReservation(reservationId) async {
    final url = 'http://app.smart-shop.rs/api/orders/$reservationId';

    try {
      final response = await http.delete(url);
      final extractedData = json.decode(response.body);

      if (extractedData == null) {
        throw HttpException('Could not delete reservation.');
      }

      if(extractedData['success'] == 'false'){
        print('12');
        throw HttpException(extractedData['description']);
      }
      print('23');

      if (response.statusCode >= 400) {
        throw HttpException('Could not delete reservation.');
      }

//      final _reservationIndex = _reservations.indexWhere((reservationItem) => reservationItem.id == reservationId);
//      _reservations.removeAt(_reservationIndex);
//      notifyListeners();

    } catch (error) {
      throw error;
    }
  }
}
