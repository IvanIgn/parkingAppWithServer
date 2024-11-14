/*
@Entity()
class Parking {
  Parking({
    this.vehicle,
    this.parkingSpace, // Keep parkingSpace nullable
    required this.startTime,
    required this.endTime,
    this.id = 0,
  });

  @Id()
  int id;
  @Transient()
  Vehicle? vehicle;
  @Transient()
  ParkingSpace? parkingSpace; // Nullable parkingSpace
  DateTime startTime;
  DateTime endTime;

  String? get vehicleInDb {
    if (vehicle == null) {
      return null;
    } else {
      return jsonEncode(vehicle!.toJson());
    }
  }

  set vehicleInDb(String? json) {
    if (json == null) {
      vehicle = null;
      return;
    }
    var decoded = jsonDecode(json);

    if (decoded != null) {
      vehicle = Vehicle.fromJson(decoded);
    } else {
      vehicle = null;
    }
  }

  String? get parkingSpaceInDb {
    if (parkingSpace == null) {
      return null;
    } else {
      return jsonEncode(parkingSpace!.toJson());
    }
  }

  set parkingSpaceInDb(String? json) {
    if (json == null) {
      parkingSpace = null;
      return;
    }
    var decoded = jsonDecode(json);

    if (decoded != null) {
      parkingSpace = ParkingSpace.fromJson(decoded);
    } else {
      parkingSpace = null;
    }
  }

  Parking deserialize(Map<String, dynamic> json) => Parking.fromJson(json);

  Map<String, dynamic> serialize(item) => toJson();

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'],
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      parkingSpace: json['parkingSpace'] != null
          ? ParkingSpace.fromJson(json['parkingSpace'])
          : null, // parkingSpace can be null
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vehicle': vehicle?.toJson(),
        'parkingSpace': parkingSpace?.toJson(),
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
      };
}
*/

import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import 'package:cli_shared/src/models/ParkingSpace.dart';
import 'package:cli_shared/src/models/Vehicle.dart';

@Entity()
class Parking {
  @Id()
  int id;
  @Transient()
  Vehicle? vehicle;
  @Transient()
  ParkingSpace? parkingSpace; // Nullable parkingSpace
  DateTime startTime;
  DateTime endTime;

  Parking({
    this.vehicle,
    this.parkingSpace,
    required this.startTime,
    required this.endTime,
    this.id = -1, // Default to -1 for unassigned ID
  });

  // Convert vehicle to a JSON string for database storage
  String? get vehicleInDb =>
      vehicle == null ? null : jsonEncode(vehicle!.toJson());

  set vehicleInDb(String? json) {
    vehicle = json == null ? null : Vehicle.fromJson(jsonDecode(json));
  }

  // Convert parkingSpace to a JSON string for database storage
  String? get parkingSpaceInDb =>
      parkingSpace == null ? null : jsonEncode(parkingSpace!.toJson());

  set parkingSpaceInDb(String? json) {
    parkingSpace =
        json == null ? null : ParkingSpace.fromJson(jsonDecode(json));
  }

  // Factory constructor to create a Parking instance from JSON
  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
      id: json['id'] ?? -1,
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      parkingSpace: json['parkingSpace'] != null
          ? ParkingSpace.fromJson(json['parkingSpace'])
          : null,
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }

  // Convert a Parking instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle': vehicle?.toJson(),
      'parkingSpace': parkingSpace?.toJson(),
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }
}
