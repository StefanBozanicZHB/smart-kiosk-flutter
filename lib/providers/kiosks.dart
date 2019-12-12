import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kiosk/helpers/additional_%20functions.dart';

class KioskItem {
  int id;
  String name;
  String streetName;
  String streetNumber;
  double latitude;
  double longitude;
  int cityId;
  String createdAt;
  String updatedAt;
  bool isFavourite;
  double distanceBetweenKioskAndCurrentLocation;

  KioskItem({
    this.id,
    this.name,
    this.streetName,
    this.streetNumber,
    this.latitude,
    this.longitude,
    this.cityId,
    this.createdAt,
    this.updatedAt,
    this.isFavourite,
    this.distanceBetweenKioskAndCurrentLocation,
  });
}

class Kiosks with ChangeNotifier {
  List<KioskItem> _kiosks = [];
  List<KioskItem> _favoriteKiosk = [];
  var userId;

  List<KioskItem> get kiosks {
    return [..._kiosks];
  }

  Future<void> fetchAndSetKiosks() async {
    final url = 'http://app.smart-shop.rs/api/kiosks';

    try {
      final response = await http.get(url);
      final List<KioskItem> _loadingKiosks = [];
      final extractedData = json.decode(response.body);

//      print(extractedData);

      if (extractedData == null) {
        return;
      }

      extractedData.forEach((kioskData) {
        print(kioskData);
        bool isFavourite = false;

        _favoriteKiosk.forEach((favoriteKiosk) {
          if(kioskData['id'] == favoriteKiosk.id)
            isFavourite = true;
        });

        _loadingKiosks.add(KioskItem(
          id: kioskData['id'],
          name: kioskData['name'],
          streetName: kioskData['location_street'],
          streetNumber: kioskData['location_number'],
          longitude: kioskData['longitude'],
          latitude: kioskData['latitude'],
          cityId: kioskData['city_id'],
          createdAt: kioskData['created_at'],
          updatedAt: kioskData['updated_at'],
          isFavourite: isFavourite,
          distanceBetweenKioskAndCurrentLocation: kioskData['latitude'],
        ));
      });

      _kiosks = _loadingKiosks.toList();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchAndSetFavoriteKiosks() async {
    userId = await AdditionalFunctions().getDeviceId();

    final url =
        'http://app.smart-shop.rs/api/favourite_kiosks?device_id=$userId';

    try {
      final response = await http.get(url);
      final List<KioskItem> _loadingKiosks = [];
      final extractedData = json.decode(response.body);

      if (extractedData == null) {
        return;
      }

      extractedData.forEach((kioskData) {
        _loadingKiosks.add(KioskItem(
          id: kioskData['id'],
//          name: kioskData['name'],
//          streetName: kioskData['location_street'],
//          streetNumber: kioskData['location_number'],
//          longitude: kioskData['longitude'],
//          latitude: kioskData['latitude'],
//          cityId: kioskData['city_id'],
//          createdAt: kioskData['created_at'],
//          updatedAt: kioskData['updated_at'],
//          isFavourite: true,
//          distanceBetweenKioskAndCurrentLocation: kioskData['latitude'],
        ));
      });
      print('prikupljeni omiljeni kiosci');
      _favoriteKiosk = _loadingKiosks.toList();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
