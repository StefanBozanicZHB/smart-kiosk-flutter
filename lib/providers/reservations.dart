import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/models/ResponseReservation.dart';
import 'package:timezone/standalone.dart';
import 'package:timezone/timezone.dart';
import 'package:device_id/device_id.dart';

class ReservatioItem {
  int id;
  String kioskName;
  String paymentMethod;
  int reservationStatusId;
  String timeLastChange;
  int price;
  var color;
  var icon;
  String statusMessage;

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

class Reservations with ChangeNotifier  {
  List<ReservatioItem> _reservations = [];
  var userId;

//  Reservations(this._reservations);

  List<ReservatioItem> get reservation {
    return [..._reservations];
  }

  Future<void> fetchAndSetReservation() async {

    userId = await AdditionalFunctions().getDeviceId();

    final url = 'http://app.smart-shop.rs/api/orders_by_device/$userId';
    try {
      final response = await http.get(url);
      final List<ReservatioItem> loadedOrders = [];
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderData) {
//        print('');
//        print(orderData);
//        print('');

        var color = Colors.green;
        var icon = Icons.check;
        String message;

        switch (orderData['status_order_id']) {
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

        loadedOrders.add(ReservatioItem(
          id: orderData['id'],
          kioskName: orderData['kiosk_name'],
          paymentMethod: orderData['payment_method'],
          reservationStatusId: orderData['status_order_id'],
          timeLastChange: convertDateInLocal(orderData['time_last_change']),
          price: orderData['price'],
          color: color,
          icon: icon,
          statusMessage: message,
        ));
      });

      _reservations = loadedOrders.toList();
      notifyListeners();
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
//      success: true,
      idReservation: extractedData['id_reservation'],
      orderCode: extractedData['order_code'],
//      orderCode: 123,
      errorCode: extractedData['error_code'],
    );

    print(reservationId);

    if(extractedData['success']){
      final reservationIndex = _reservations.indexWhere((reserv) => reserv.id == reservationId);
      _reservations[reservationIndex].reservationStatusId = 1;
      notifyListeners();
    }

    print(extractedData['success']);
    return responseReservation;
  }

  Future<void> fetchAndSetReservationDetails(reservationId) async {
    final url = 'http://app.smart-shop.rs/api/orders/$reservationId';

//    try{
//      final response = await http.get(url);
//      final extractedData = json.decode(response.body);
//
//      if(extractedData == null){
//        return;
//      }
//
//
//
//    }
  }
}
