
class Kiosk {
  final int id;
  final String name;
  final String streetName;
  final String streetNumber;
  final double latitude;
  final double longitude;
  final int cityId;
  final String createdAt;
  final String updatedAt;
  bool isFavourite;
  final double distanceBetweenKioskAndCurrentLocation;

  Kiosk({
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
