/*
class PersonOperations extends SetMainPage {
  final PersonRepository personRepository = PersonRepository.instance;

  // Simplified main menu texts to a single constant
  List<String> texts = [
    'Du har valt att hantera Personer. Vad vill du göra?\n',
    '1. Skapa ny person\n',
    '2. Visa alla personer\n',
    '3. Uppdatera person\n',
    '4. Ta bort person\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runOperation(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addPersonOperation();
        break;
      case 2:
        _showAllPersonsOperation();
        break;
      case 3:
        _updatePersonsOperation();
        break;
      case 4:
        _addPersonOperation();
        break;
      case 5:
        setMainPage(clearCLI: true);
        break;
      default:
        _showInvalidChoice();
    }
  }

  void _addPersonOperation() async {
    final name = _getValidatedInput('Fyll i namn: ', 'Namn är obligatoriskt.');
    final socialSecurityNr = _getValidatedSSN();

    if (name != null && socialSecurityNr != null) {
      final response = await personRepository
          .addPerson(Person(name: name, personNumber: socialSecurityNr));
      _handleRepositoryResponse(response, 'Person tillagd.', 'Något gick fel.');
      return;
    }
  }

  void _showAllPersonsOperation() async {
    final personList = await personRepository.getAllPersons();
    if (personList.isEmpty) {
      print('Inga personer att visa. Testa att lägga till personer.');
    } else {
      personList.forEach((person) => print(
          'Id: ${person.id}, Namn: ${person.name}, Personnummer: ${person.personNumber}'));
    }
    _returnToMainMenu();
  }

  void _updatePersonsOperation() async {
    print('\nDu har valt att uppdatera en person');
    final socialSecurityNr = _getValidatedSSN();
    if (socialSecurityNr == null) return;

    final person = await _findPersonBySSN(socialSecurityNr);
    if (person == null) return;

    final updatedName = _getValidatedInput(
        'Ange nytt namn eller tryck Enter för att behålla: ');
    if (updatedName != null && updatedName.isNotEmpty) {
      final response = await personRepository.updatePerson(Person(
        id: person.id,
        name: updatedName,
        personNumber: socialSecurityNr,
      ));
      _handleRepositoryResponse(
          response, 'Person uppdaterad.', 'Något gick fel.');
    } else {
      print('Ingen ändring gjord.');
      setMainPage();
    }
  }

  void _deletePersonOperation() async {
    print('\nDu har valt att ta bort en person');
    final socialSecurityNr = _getValidatedSSN();
    if (socialSecurityNr == null) return;

    final person = await _findPersonBySSN(socialSecurityNr);
    if (person == null) return;

    final response = await personRepository.deletePerson(person.id.toString());
    _handleRepositoryResponse(response, 'Person raderad.', 'Något gick fel.');
  }

  // Helper Methods
  String? _getValidatedInput(String prompt, [String? errorMessage]) {
    stdout.write(prompt);
    var input = stdin.readLineSync()?.trim();
    if ((input == null || input.isEmpty) && errorMessage != null) {
      print(errorMessage);
      return null;
    }
    return input;
  }

  String? _getValidatedSSN() {
    final ssn = _getValidatedInput(
        'Fyll i personnummer (12 siffror utan bindestreck): ',
        'Personnummer är obligatoriskt.');
    if (ssn != null && Validator.isValidSocialSecurityNumber(ssn)) return ssn;
    print('Ogiltigt personnummer. Försök igen.');
    return null;
  }

  Future<Person?> _findPersonBySSN(String ssn) async {
    final personList = await personRepository.getAllPersons();
    final person =
        personList.firstWhere((p) => p.personNumber == ssn, orElse: () => null);
    if (person == null) {
      print('Ingen person hittades med det angivna personnumret.');
      setMainPage();
    }
    return person;
  }

  void _handleRepositoryResponse(
      HttpResponse response, String successMsg, String errorMsg) {
    print(response.statusCode == 200 ? successMsg : errorMsg);
    setMainPage();
  }

  void _returnToMainMenu() {
    print('Tryck på Enter för att återgå till huvudmenyn.');
    stdin.readLineSync();
    setMainPage(clearCLI: true);
  }

  void _showInvalidChoice() {
    print('Ogiltigt val. Vänligen välj ett alternativ mellan 1 och 5.');
    setMainPage();
  }
}
*/

import 'dart:io';
import 'package:cli_shared/cli_shared.dart';
import 'package:cli_client/utils/console.dart';
import 'package:cli_client/utils/validator.dart';
import 'main.dart';
//import 'Person.dart'; // Importera Person-klass (din Entity)

class PersonOperations extends SetMainPage {
  // ObjectBox Store och Box
  final Store _store = Store(getObjectBoxModel());
  late final Box<Person> personBox;

  PersonOperations() {
    // Initiera Box för Person
    personBox = _store.box<Person>();
  }

  // Menytexter för hantering av personer
  List<String> texts = [
    'Du har valt att hantera Personer. Vad vill du göra?\n',
    '1. Skapa ny person\n',
    '2. Visa alla personer\n',
    '3. Uppdatera person\n',
    '4. Ta bort person\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  // Hantera användarens val för personoperationer
  void runOperation(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addPersonOperation();
        break;
      case 2:
        _showAllPersonsOperation();
        break;
      case 3:
        _updatePersonsOperation();
        break;
      case 4:
        _deletePersonOperation();
        break;
      case 5:
        setMainPage(clearCLI: true);
        break;
      default:
        _showInvalidChoice();
    }
  }

  // Skapa en ny person
  void _addPersonOperation() {
    print('Ange personnummer:');
    String personNumber = stdin.readLineSync() ?? '';

    print('Ange namn:');
    String name = stdin.readLineSync() ?? '';

    // Skapa en ny Person-instans
    Person newPerson = Person(personNumber: personNumber, name: name);

    // Spara personen till ObjectBox
    personBox.put(newPerson);

    print('Person ${newPerson.name} har skapats och sparats lokalt.');
  }

  // Visa alla personer
  void _showAllPersonsOperation() {
    // Hämta alla personer från Box
    List<Person> allPersons = personBox.getAll();

    if (allPersons.isEmpty) {
      print('Inga personer finns i systemet.');
    } else {
      print('Alla personer:');
      for (var person in allPersons) {
        print(
            'ID: ${person.id}, Personnummer: ${person.personNumber}, Namn: ${person.name}');
      }
    }
  }

  // Uppdatera en befintlig person
  void _updatePersonsOperation() {
    print('Ange ID för den person du vill uppdatera:');
    int? personId = int.tryParse(stdin.readLineSync() ?? '');

    if (personId == null || personId == 0) {
      print('Ogiltigt ID.');
      return;
    }

    // Hämta personen baserat på ID
    Person? existingPerson = personBox.get(personId);

    if (existingPerson == null) {
      print('Person med ID $personId finns inte.');
    } else {
      print('Ange nytt namn (nuvarande: ${existingPerson.name}):');
      String newName = stdin.readLineSync() ?? existingPerson.name;

      // Uppdatera namn
      existingPerson.name = newName;

      // Spara den uppdaterade personen till ObjectBox
      personBox.put(existingPerson);

      print('Person med ID ${existingPerson.id} har uppdaterats.');
    }
  }

  // Ta bort en person
  void _deletePersonOperation() {
    print('Ange ID för den person du vill ta bort:');
    int? personId = int.tryParse(stdin.readLineSync() ?? '');

    if (personId == null || personId == 0) {
      print('Ogiltigt ID.');
      return;
    }

    // Hämta och ta bort personen baserat på ID
    Person? personToDelete = personBox.get(personId);

    if (personToDelete == null) {
      print('Person med ID $personId finns inte.');
    } else {
      // Ta bort från databasen
      personBox.remove(personId);
      print('Person med ID $personId har tagits bort.');
    }
  }

  // Hantera ogiltiga val
  void _showInvalidChoice() {
    print('Ogiltigt val, vänligen försök igen.');
  }
}
