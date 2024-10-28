import 'package:objectbox/objectbox.dart';
import 'ParkingSpace.dart';
import 'Vehicle.dart';

@Entity() // Markera klassen som en ObjectBox Entity
class Parking {
  Parking({
    this.id = 0, // ID börjar med 0 för ObjectBox auto-generering
    required this.startTime,
    required this.endTime,
    // ID börjar med 0 för ObjectBox auto-generering
  }) : vehicle = ToOne<Vehicle>(); // Initialize vehicle

  @Id() // ObjectBox genererar ID automatiskt
  int id;

  // Relationer till Vehicle och ParkingSpace
  final ToOne<Vehicle> vehicle; // ToOne relation till Vehicle
  final ToOne<ParkingSpace> parkingSpace =
      ToOne<ParkingSpace>(); // ToOne relation till ParkingSpace

  @Property(type: PropertyType.date) // Hantering av DateTime i ObjectBox
  final DateTime startTime;

  @Property(type: PropertyType.date) // Hantering av DateTime i ObjectBox
  DateTime endTime;

  // Beräkna hur länge parkeringen har pågått
  Duration get time => endTime.difference(startTime);

  // Serialisering: Konvertera ett objekt till JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle': vehicle.target?.toJson(), // Serialisera Vehicle om det finns
      'parkingSpace': parkingSpace.target
          ?.toJson(), // Serialisera ParkingSpace om det finns
      'startTime':
          startTime.toIso8601String(), // Konvertera DateTime till ISO-sträng
      'endTime':
          endTime.toIso8601String(), // Konvertera DateTime till ISO-sträng
    };
  }

  // Deserialisering: Skapa ett objekt från JSON
  factory Parking.fromJson(Map<String, dynamic> json) {
    final parking = Parking(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : DateTime.now(),
    );

    // Återställ relationer från JSON
    parking.vehicle.target =
        Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>);
    parking.parkingSpace.target =
        ParkingSpace.fromJson(json['parkingSpace'] as Map<String, dynamic>);

    return parking;
  }
}
