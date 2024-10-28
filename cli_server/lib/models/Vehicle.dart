import 'package:objectbox/objectbox.dart';
import 'Person.dart';

@Entity() // Markera klassen som en ObjectBox Entity
class Vehicle {
  Vehicle({
    this.id = 0,
    required this.registrationNumber,
    required this.type,
    required this.owner,
    required this.ownerId,
    // ID börjar med 0 (angivet att ObjectBox ska auto-generera ID)
  });

  @Id(assignable: true) // ObjectBox genererar ID om du lämnar detta som 0
  int id; // ObjectBox kräver att ID är ett int

  final String registrationNumber; // Registreringsnummer för fordonet
  final String type; // Typ av fordon (t.ex. bil, motorcykel)

  final String ownerId; // Referens till ägarens ID (Personens personNumber)

  // Relation: Koppla fordon till en ägare
  @Backlink()
  final ToOne<Person> owner; // Skapa en relation till Person-entity

  // Serialisering: Konvertera ett objekt till JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'type': type,
      'owner':
          owner.target?.toJson(), // Konvertera ägaren till JSON om den finns
    };
  }

  // Deserialisering: Skapa ett objekt från JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    final vehicle = Vehicle(
      registrationNumber: json['registrationNumber'] as String,
      type: json['type'] as String,
      ownerId: json['ownerId'] as String, // Lägg till ownerId
      owner: ToOne<Person>(), // Skapa en tom ToOne-relation
    );

    // Återställ ägaren från JSON
    vehicle.owner.target =
        Person.fromJson(json['owner'] as Map<String, dynamic>);
    return vehicle;
  }
}
