import 'package:device_id/device_id.dart';

class AdditionalFunctions {
  static String _deviceId;

  Future<String> getDeviceId() async{
    if(_deviceId == null) {
      _deviceId = await DeviceId.getID;
    }
    return _deviceId;
  }
}