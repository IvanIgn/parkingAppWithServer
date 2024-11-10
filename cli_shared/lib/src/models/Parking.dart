import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import 'parkingSpace.dart';
import 'vehicle.dart';

import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import 'parkingSpace.dart';
import 'vehicle.dart';

@Entity()
class Parking {
  Parking({
    this.vehicle,
    this.parkingSpace,
    required this.startTime,
    required this.endTime,
    this.id = 0,
  });

  @Id()
  int id;
  @Transient()
  Vehicle? vehicle;
  @Transient()
  ParkingSpace? parkingSpace;
  final DateTime startTime;
  DateTime endTime;

  String? get vehicleInDb {
    // Check if the vehicle is null before attempting to encode
    return vehicle == null ? null : jsonEncode(vehicle!.toJson());
  }

  set vehicleInDb(String? json) {
    if (json == null) {
      vehicle = null; // If json is null, set vehicle to null
      return;
    }

    try {
      var decoded = jsonDecode(json);
      if (decoded != null) {
        vehicle = Vehicle.fromJson(decoded);
      } else {
        vehicle = null;
      }
    } catch (e) {
      vehicle =
          null; // In case of an error during decoding, set vehicle to null
    }
  }

  String? get parkingSpaceInDb {
    // Check if the parkingSpace is null before attempting to encode
    return parkingSpace == null ? null : jsonEncode(parkingSpace!.toJson());
  }

  set parkingSpaceInDb(String? json) {
    if (json == null) {
      parkingSpace = null; // If json is null, set parkingSpace to null
      return;
    }

    try {
      var decoded = jsonDecode(json);
      if (decoded != null) {
        parkingSpace = ParkingSpace.fromJson(decoded);
      } else {
        parkingSpace = null;
      }
    } catch (e) {
      parkingSpace =
          null; // In case of an error during decoding, set parkingSpace to null
    }
  }

  // Method to deserialize a Map into a Parking object
  Parking deserialize(Map<String, dynamic> json) {
    return Parking.fromJson(json);
  }

  // Method to serialize a Parking object into a Map
  Map<String, dynamic> serialize(item) => toJson();

  // Factory constructor for creating a Parking object from a Map
  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      parkingSpace: json['parkingSpace'] != null
          ? ParkingSpace.fromJson(json['parkingSpace'])
          : null,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : DateTime.now(),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'])
          : DateTime.now(),
    );
  }

  // Method to convert Parking object to a Map
  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicle': vehicle?.toJson(),
        'parkingSpace': parkingSpace?.toJson(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
      };
}
