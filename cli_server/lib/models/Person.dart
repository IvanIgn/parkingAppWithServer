import 'package:objectbox/objectbox.dart';

@Entity() // Markera klassen som en ObjectBox Entity
class Person {
  Person({
    this.id = 0, // ID börjar med 0 för att ObjectBox ska auto-generera ID
    required this.name,
    required this.personNumber,
  });

  @Id() // ObjectBox genererar ID automatiskt
  int id; // ID är ett heltal i ObjectBox

  @Index() // Indexera namn för snabbare sökning
  late final String name; // Personens namn

  final String personNumber; // Personens personnummer

  // Serialisering: Konvertera ett objekt till JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'personNumber': personNumber,
    };
  }

  // Deserialisering: Skapa ett objekt från JSON
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int, // ID är ett heltal
      name: json['name'] as String,
      personNumber: json['personNumber'] as String,
    );
  }
}
