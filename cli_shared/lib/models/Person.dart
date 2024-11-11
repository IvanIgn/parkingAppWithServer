import 'package:objectbox/objectbox.dart';

@Entity()
class Person {
  Person({required this.name, required this.personNumber, this.id = 0});

  @Id()
  int id;
  String name;
  String personNumber;

  // Deserialize method to convert a Map into a Person object
  Person deserialize(Map<String, dynamic> json) => Person.fromJson(json);

  // Serialize method to convert a Person object into a Map
  Map<String, dynamic> serialize(item) => toJson();

  // Factory constructor to create a Person object from a Map
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? 0, // Default to 0 if id is missing
      name: json['name'] ?? '', // Default to empty string if name is missing
      personNumber: json['personNumber'] ??
          '', // Default to empty string if personNumber is missing
    );
  }

  // Method to convert a Person object to a Map
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'personNumber': personNumber,
      };
}
