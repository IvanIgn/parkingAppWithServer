import 'package:objectbox/objectbox.dart';

@Entity()
class ParkingSpace {
  ParkingSpace({
    required this.address,
    required this.pricePerHour,
    this.id = 0,
  });

  @Id()
  int id;
  String address; // Removed 'final' to allow changes
  int pricePerHour;

  // Deserialize method to convert a Map into a ParkingSpace object
  ParkingSpace deserialize(Map<String, dynamic> json) =>
      ParkingSpace.fromJson(json);

  // Serialize method to convert a ParkingSpace object into a Map
  Map<String, dynamic> serialize(item) => toJson();

  // Factory constructor to create a ParkingSpace object from a Map
  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json['id'] ?? 0, // Default to 0 if id is missing
      address: json['address'] ??
          '', // Default to empty string if address is missing
      pricePerHour:
          json['pricePerHour'] ?? 0, // Default to 0 if pricePerHour is missing
    );
  }

  // Method to convert a ParkingSpace object to a Map
  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'pricePerHour': pricePerHour,
      };
}
