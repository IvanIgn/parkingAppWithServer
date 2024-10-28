import 'package:objectbox/objectbox.dart';

@Entity() // Markera klassen som en ObjectBox Entity
class ParkingSpace {
  ParkingSpace({
    this.id = 0, // ID börjar med 0 för ObjectBox auto-generering
    required this.address,
    required this.pricePerHour,
  });

  @Id() // ObjectBox hanterar ID
  int id;

  @Index() // Indexera address för snabbare sökning
  String address;

  double pricePerHour;

  // Serialisering: Konvertera ett objekt till JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'pricePerHour': pricePerHour,
    };
  }

  // Deserialisering: Skapa ett objekt från JSON
  factory ParkingSpace.fromJson(Map<String, dynamic> json) {
    return ParkingSpace(
      id: json['id'] as int, // ID är nu ett heltal
      address: json['address'] as String,
      pricePerHour: json['pricePerHour'] as double,
    );
  }
}
