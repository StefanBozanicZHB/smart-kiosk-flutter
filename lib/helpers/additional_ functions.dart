import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';

enum MainMenu {
  byLocation,
  byName,
  byStreet,
  byFavorite,
}

enum PaymentMethod {
  card,
  cash,
}

class AdditionalFunctions {
  static const IMAGE_URL_PREF = 'http://app.smart-shop.rs/';
  static const VERTICAL_OFF_SET_ANIMATION = 50.0;
  static const DURACTION_ANIMATION_LIST_VIEW_MILLISECONDS = Duration(milliseconds: 300);
  static const WIDTH_FOR_CHANGING_ORIENTATION = 400;

  static String _deviceId;

  Future<String> getDeviceId() async{
    if(_deviceId == null) {
      _deviceId = await DeviceId.getID;
    }
    return _deviceId;
  }
}