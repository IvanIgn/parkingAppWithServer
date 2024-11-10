import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import 'person.dart';

@Entity()
class Vehicle {
  Vehicle({
    required this.regNumber,
    required this.vehicleType,
    this.owner,
    this.id = 0,
  });

  @Id()
  int id;
  final String regNumber;
  final String vehicleType;
  @Transient()
  Person? owner;

  String? get ownerInDb {
    // Null check for owner before encoding to JSON
    return owner == null ? null : jsonEncode(owner!.toJson());
  }

  set ownerInDb(String? json) {
    if (json == null) {
      owner = null; // If json is null, set owner to null
      return;
    }

    try {
      var decoded = jsonDecode(json);
      if (decoded != null) {
        owner = Person.fromJson(decoded);
      } else {
        owner = null;
      }
    } catch (e) {
      owner = null; // In case of an error during decoding, set owner to null
    }
  }

  // Deserialize method to convert a Map into a Vehicle object
  Vehicle deserialize(Map<String, dynamic> json) {
    return Vehicle.fromJson(json);
  }

  // Serialize method to convert a Vehicle object into a Map
  Map<String, dynamic> serialize(item) => toJson();

  // Factory constructor to create a Vehicle object from a Map
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      regNumber: json['regNumber'],
      vehicleType: json['vehicleType'],
      owner: json['owner'] != null ? Person.fromJson(json['owner']) : null,
    );
  }

  // Method to convert a Vehicle object to a Map
  Map<String, dynamic> toJson() => {
        'id': id,
        'regNumber': regNumber,
        'vehicleType': vehicleType,
        'owner': owner?.toJson(), // Null check for owner
      };
}
