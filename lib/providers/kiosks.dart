import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_kiosk/helpers/additional_%20functions.dart';
import 'package:smart_kiosk/models/kiosk.dart';

class Kiosks with ChangeNotifier {
  List<Kiosk> _allKiosks = [];
  List<Kiosk> _shownKiosks = [];
  List<Kiosk> _favoriteKiosk = [];
  Kiosk currentKiosk;
  var userId;

  List<Kiosk> get kiosks {
    return [..._shownKiosks];
  }

  List<Kiosk> get kiosksFavorite {
    return [..._shownKiosks.where((item)=>item.isFavourite)];
  }

  Future<void> fetchAndSetKiosks() async {
    final url = 'http://app.smart-shop.rs/api/kiosks';

    try {
      final response = await http.get(url);
      final List<Kiosk> _loadingKiosks = [];
      final extractedData = json.decode(response.body);


      if (extractedData == null) {
        return;
      }

      extractedData.forEach((kioskData) {
        bool isFavourite = false;

        _favoriteKiosk.forEach((favoriteKiosk) {
          if (kioskData['id'] == favoriteKiosk.id) isFavourite = true;
        });

        _loadingKiosks.add(Kiosk(
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
      _allKiosks = _loadingKiosks.toList();
      _shownKiosks = _allKiosks;
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
      final List<Kiosk> _loadingKiosks = [];
      final extractedData = json.decode(response.body);

      if (extractedData == null) {
        return;
      }

      extractedData.forEach((kioskData) {
        _loadingKiosks.add(Kiosk(
          id: kioskData['id'],
          name: kioskData['name'],
          streetName: kioskData['location_street'],
          streetNumber: kioskData['location_number'],
          longitude: kioskData['longitude'],
          latitude: kioskData['latitude'],
          cityId: kioskData['city_id'],
          createdAt: kioskData['created_at'],
          updatedAt: kioskData['updated_at'],
          isFavourite: true,
          distanceBetweenKioskAndCurrentLocation: kioskData['latitude'],
        ));
      });

      print('prikupljeni omiljeni kiosci');
      _favoriteKiosk = _loadingKiosks.toList();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  filteringKiosk(String content, type) {
    List<Kiosk> _filteringKiosks = [];

    if (type == MainMenu.byName) {
      _allKiosks.forEach((kiosks) {
        if (kiosks.name.toLowerCase().contains(content.toLowerCase())) {
          _filteringKiosks.add(kiosks);
        }
      });
    } else if (type == MainMenu.byStreet) {
      _allKiosks.forEach((kiosks) {
        if (kiosks.streetName.toLowerCase().contains(content.toLowerCase())) {
          _filteringKiosks.add(kiosks);
        }
      });
    } else if (type == MainMenu.byFavorite) {
      _allKiosks.forEach((kiosks) {
        if (kiosks.isFavourite) {
          if (kiosks.name.toLowerCase().contains(content.toLowerCase())) {
            _filteringKiosks.add(kiosks);
          }
        }
      });
    }

    _shownKiosks = _filteringKiosks;
    notifyListeners();
  }

  returnAllKiosk() {
    _shownKiosks = _allKiosks;
    notifyListeners();
  }

  Future<void> changeFavorite(newValue, id) async {
    userId = await AdditionalFunctions().getDeviceId();

    final index = _allKiosks.indexWhere((item) => item.id == id);
    _allKiosks[index].isFavourite = newValue;
    notifyListeners();

    if (newValue) {
      try {
        final url = 'http://app.smart-shop.rs/api/kiosk_devices';
        final response = await http
            .post(url, body: {"device_id": userId, "kiosk_id": id.toString()});
        final extractedData = json.decode(response.body);
        if (extractedData == null) {
          throw ('error');
        }
        if (extractedData['result'] == 'ok') {
          return 1;
        }
      } catch (error) {
        _allKiosks[index].isFavourite = false;
        notifyListeners();
        print(error);
        throw error;
      }
    } else {
      try {
        final url =
            'http://app.smart-shop.rs/api/favourite_kiosks?device_id=$userId&kiosk_id=$id';
        final response = await http.delete(url);
        final extractedData = json.decode(response.body);

        if (extractedData == null || extractedData['result'] == 'error') {
          throw ('error');
        }
      } catch (error) {
        print(error);
        _allKiosks[index].isFavourite = true;
        notifyListeners();
        throw error;
      }
    }
  }
}
