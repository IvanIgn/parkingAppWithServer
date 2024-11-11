import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_client/repositories/PersonRepository.dart';
import 'package:cli_shared/models/Person.dart';

class PersonsOperations extends SetMainPage {
  final PersonRepository personRepository = PersonRepository.instance;

  List<String> menuTexts = [
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
        _updatePersonOperation();
        break;
      case 4:
        _deletePersonOperation();
        break;
      case 5:
        setMainPage(clearCLI: true);
        break;
      default:
        print('Ogiltigt val, vänligen försök igen.');
    }
  }

  // Add new person
  Future<void> _addPersonOperation() async {
    print('\n--- Skapa ny person ---');
    final name = _promptInput('Fyll i namn:');
    final ssn = _promptInput('Fyll i personnummer (12 siffror):');

    if (name != null && ssn != null) {
      final person = Person(name: name, personNumber: ssn);
      await personRepository.addPerson(person);
      print('Personen "${person.name}" har lagts till.');
    } else {
      printError('Ogiltig inmatning för att skapa person.');
    }
    setMainPage();
  }

  // Show all persons
  Future<void> _showAllPersonsOperation() async {
    print('\n--- Alla personer ---');
    final persons = await personRepository.getAllPersons();
    if (persons.isEmpty) {
      print('Inga personer hittades.');
    } else {
      for (var person in persons) {
        print(
            'ID: ${person.id}, Namn: ${person.name}, Personnummer: ${person.personNumber}');
      }
    }
    setMainPage();
  }

  // Update a person
  Future<void> _updatePersonOperation() async {
    print('\n--- Uppdatera person ---');
    final ssn =
        _promptInput('Fyll i personnummer för personen du vill uppdatera:');
    if (ssn == null) return;

    final person = await personRepository.getPersonByPersonNumber(ssn);
    if (person != null) {
      final newName =
          _promptInput('Nytt namn (lämna tomt för att behålla aktuellt namn):');
      if (newName != null && newName.isNotEmpty) person.name = newName;
      await personRepository.updatePerson(person);
      print('Personen "${person.name}" har uppdaterats.');
    } else {
      printError('Ingen person hittades med personnummer $ssn.');
    }
    setMainPage();
  }

  // Delete a person
  Future<void> _deletePersonOperation() async {
    print('\n--- Ta bort person ---');
    final ssn = _promptInput('Fyll i personnummer för att ta bort:');
    if (ssn == null) return;

    await personRepository.deletePerson(ssn);
    print('Person med personnummer $ssn har tagits bort.');
    setMainPage();
  }

  // Helper for user input prompt
  String? _promptInput(String promptText) {
    stdout.write(promptText);
    return stdin.readLineSync()?.trim();
  }

  // Helper for error messages
  void printError(String message) {
    print('Fel: $message');
  }
}
