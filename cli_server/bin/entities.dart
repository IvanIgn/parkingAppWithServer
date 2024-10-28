// lib/objectbox.dart
import 'package:objectbox/objectbox.dart';

@Entity()
class Person {
  int id;
  String name;
  String personNumber;

  Person({this.id = 0, required this.name, required this.personNumber});
}

@Entity()
class Vehicle {
  int id;
  String registrationNumber;
  String ownerId;

  Vehicle(
      {this.id = 0, required this.registrationNumber, required this.ownerId});
}

@Entity()
class ParkingSpace {
  int id;
  bool isAvailable;

  ParkingSpace({this.id = 0, required this.isAvailable});
}

@Entity()
class Parking {
  int id;
  int parkingSpaceId;
  int vehicleId;

  Parking({this.id = 0, required this.parkingSpaceId, required this.vehicleId});
}
