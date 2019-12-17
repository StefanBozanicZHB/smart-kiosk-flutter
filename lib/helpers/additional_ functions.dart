import 'package:device_id/device_id.dart';

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
  static String _deviceId;

  Future<String> getDeviceId() async{
    if(_deviceId == null) {
      _deviceId = await DeviceId.getID;
    }
    return _deviceId;
  }
}