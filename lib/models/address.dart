// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final GeoLocation? geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  Address copyWith({
    String? street,
    String? suite,
    String? city,
    String? zipcode,
    GeoLocation? geo,
  }) {
    return Address(
      street: street ?? this.street,
      suite: suite ?? this.suite,
      city: city ?? this.city,
      zipcode: zipcode ?? this.zipcode,
      geo: geo ?? this.geo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
      'geo': geo?.toMap(),
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'] as String,
      suite: map['suite'] as String,
      city: map['city'] as String,
      zipcode: map['zipcode'] as String,
      geo: map['geo'] != null
          ? GeoLocation.fromMap(map['geo'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Address(street: $street, suite: $suite, city: $city, zipcode: $zipcode, geo: $geo)';
  }

  @override
  bool operator ==(covariant Address other) {
    if (identical(this, other)) return true;

    return other.street == street &&
        other.suite == suite &&
        other.city == city &&
        other.zipcode == zipcode &&
        other.geo == geo;
  }

  @override
  int get hashCode {
    return street.hashCode ^
        suite.hashCode ^
        city.hashCode ^
        zipcode.hashCode ^
        geo.hashCode;
  }
}

class GeoLocation {
  final double lat;
  final double lng;

  GeoLocation({required this.lat, required this.lng});

  GeoLocation copyWith({double? lat, double? lng}) {
    return GeoLocation(lat: lat ?? this.lat, lng: lng ?? this.lng);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'lat': lat, 'lng': lng};
  }

  factory GeoLocation.fromMap(Map<String, dynamic> map) {
    return GeoLocation(lat: map['lat'] as double, lng: map['lng'] as double);
  }

  String toJson() => json.encode(toMap());

  factory GeoLocation.fromJson(String source) =>
      GeoLocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GeoLocation(lat: $lat, lng: $lng)';

  @override
  bool operator ==(covariant GeoLocation other) {
    if (identical(this, other)) return true;

    return other.lat == lat && other.lng == lng;
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;
}
