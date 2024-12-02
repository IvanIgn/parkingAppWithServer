// import 'dart:io';
// import 'package:cli_client/cli_operations/main.dart';
// import 'package:cli_client/repositories/PersonRepository.dart';
// import 'package:cli_client/utils/validator.dart';
// import 'package:cli_shared/cli_shared.dart';

// class PersonsOperations extends SetMainPage {
//   final PersonRepository personRepository = PersonRepository.instance;

//   List<String> menuTexts = [
//     'Du har valt att hantera Personer. Vad vill du göra?\n',
//     '1. Skapa ny person\n',
//     '2. Visa alla personer\n',
//     '3. Uppdatera person\n',
//     '4. Ta bort person\n',
//     '5. Gå tillbaka till huvudmenyn\n\n',
//     'Välj ett alternativ (1-5): ',
//   ];

//   void runOperation(int chosenOption) {
//     try {
//       switch (chosenOption) {
//         case 1:
//           _addPersonOperation();
//           break;
//         case 2:
//           _showAllPersonsOperation();
//           break;
//         case 3:
//           _updatePersonOperation();
//           break;
//         case 4:
//           _deletePersonOperation();
//           break;
//         case 5:
//           setMainPage(clearCLI: true);
//           return;
//         default:
//           printError('Ogiltigt val, vänligen försök igen.');
//       }
//     } catch (e) {
//       printError('Ett oväntat fel inträffade: ${e.toString()}');
//     }
//   }

//   // Add new person
//   Future<void> _addPersonOperation() async {
//     try {
//       print('\n--- Skapa ny person ---');

//       final name = _promptInput('Fyll i namn:');

//       // Kontrollera att namnet inte är tomt
//       if (name == null || name.trim().isEmpty || !Validator.isString(name)) {
//         printError('Namnet får inte vara tomt eller ogiltigt.');
//         return;
//       }
//       final ssn = _promptInput('Fyll i personnummer (12 siffror):');
//       // Kontrollera att personnumret är giltigt
//       if (ssn == null || !Validator.isValidSocialSecurityNumber(ssn)) {
//         printError('Ogiltig inmatning för personnummer, fyll i 12 siffror.');
//         return;
//       }

//       // Skapa person och lägg till den i repository
//       final person = Person(name: name, personNumber: ssn);
//       await personRepository.createPerson(person);
//       print('Personen "${person.name}" har lagts till.');
//     } catch (e) {
//       printError('Fel vid skapande av person: ${e.toString()}');
//     } finally {
//       setMainPage();
//     }
//   }

//   // Show all persons
//   Future<void> _showAllPersonsOperation() async {
//     try {
//       print('\n--- Alla personer ---');
//       final persons = await personRepository.getAllPersons();

//       if (persons.isEmpty) {
//         print('Inga personer hittades.');
//       } else {
//         for (var person in persons) {
//           print(
//               'ID: ${person.id}, Namn: ${person.name}, Personnummer: ${person.personNumber}');
//         }
//       }
//     } catch (e) {
//       printError('Fel vid visning av personer: ${e.toString()}');
//     } finally {
//       setMainPage();
//     }
//   }

//   Future<void> _updatePersonOperation() async {
//     try {
//       print('\n--- Uppdatera person ---');

//       // Read SSN input asynchronously
//       final ssn = _promptInput('Ange ID för personen som du vill uppdatera:');

//       // Validate SSN
//       // if (ssn == null || !Validator.isValidSocialSecurityNumber(ssn)) {
//       //   printError('Ogiltigt personnummer.');
//       //   return;
//       // }

//       // // Convert SSN to ID
//       // final personId = int.tryParse(ssn);
//       // if (personId == null) {
//       //   printError('Ogiltigt personnummer.');
//       //   return;
//       // }

//       // Fetch person by ID asynchronously
//       final personId = int.tryParse(ssn ?? '');
//       if (personId == null) {
//         printError('Ogiltigt ID.');
//         return;
//       }
//       final person = await personRepository.getPersonById(personId);

//       // Read new name input asynchronously
//       final newName =
//           _promptInput('Nytt namn (lämna tomt för att behålla aktuellt namn):');

//       // Validate new name
//       if (newName != null && newName.trim().isNotEmpty) {
//         person.name = newName;
//       } else if (newName != null && newName.trim().isEmpty) {
//         printError(
//             'Nytt namn får inte vara tomt eller bara bestå av mellanslag.');
//         return;
//       }

//       // Update the person asynchronously
//       await personRepository.updatePerson(
//           person.id, person); // Correct usage of await
//       print('Personen "${person.name}" har uppdaterats.');
//     } catch (e) {
//       printError('Fel vid uppdatering av person: ${e.toString()}');
//     } finally {
//       setMainPage();
//     }
//   }

//   Future<void> _deletePersonOperation() async {
//     try {
//       print('\n--- Ta bort person ---');
//       final ssn = _promptInput('Ange ID för person du vill ta bort:');
//       if (ssn == null) {
//         printError('Ogiltigt ID.');
//         return;
//       }

//       final person = await personRepository
//           .getPersonById(int.parse(ssn)); // Await for fetching the person

//       await personRepository
//           .deletePerson(person.id); // Await for deleting the person
//       print(
//           'Person med ID ${person.id} och personnummer ${person.personNumber} har tagits bort.');
//     } catch (e) {
//       printError('Fel vid borttagning av person: ${e.toString()}');
//     } finally {
//       setMainPage();
//     }
//   }

//   // Helper for user input prompt
//   String? _promptInput(String promptText) {
//     stdout.write(promptText);
//     return stdin.readLineSync()?.trim();
//   }

//   // Helper for error messages
//   void printError(String message) {
//     print('Fel: $message');
//   }

//   // Helper function to validate social security number
//   // bool _isValidSSN(String ssn) {
//   //   final regex = RegExp(r'^\d{12}$');
//   //   return regex.hasMatch(ssn);
//   // }
// }

import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_client/repositories/PersonRepository.dart';
import 'package:cli_client/utils/validator.dart';
import 'package:cli_shared/cli_shared.dart';

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
    try {
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
          return;
        default:
          printError('Ogiltigt val, vänligen försök igen.');
      }
    } catch (e) {
      printError('Ett oväntat fel inträffade: ${e.toString()}');
    }
  }

  // Add new person
  Future<void> _addPersonOperation() async {
    try {
      print('\n--- Skapa ny person ---');

      // Name input
      String? name;
      do {
        name = _promptInput('Fyll i namn:');
        if (name == null || name.trim().isEmpty || !Validator.isString(name)) {
          printError('Namnet får inte vara tomt eller ogiltigt. Försök igen.');
        }
      } while (
          name == null || name.trim().isEmpty || !Validator.isString(name));

      // Social Security Number (SSN) input
      String? ssn;
      do {
        ssn = _promptInput('Fyll i personnummer (12 siffror):');
        if (ssn == null || !Validator.isValidSocialSecurityNumber(ssn)) {
          printError('Ogiltigt personnummer, fyll i 12 siffror. Försök igen.');
        }
      } while (ssn == null || !Validator.isValidSocialSecurityNumber(ssn));

      // Create person and add to repository
      final person = Person(name: name, personNumber: ssn);
      await personRepository.createPerson(person);
      print('Personen "${person.name}" har lagts till.');
    } catch (e) {
      printError('Fel vid skapande av person: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Show all persons
  Future<void> _showAllPersonsOperation() async {
    try {
      print('\n');
      print('\n--- Alla personer ---');
      print('\n');
      final persons = await personRepository.getAllPersons();

      if (persons.isEmpty) {
        print('Inga personer hittades.');
      } else {
        for (var person in persons) {
          print(
              'ID: ${person.id}, Namn: ${person.name}, Personnummer: ${person.personNumber}');
        }
        print('\n');
      }
    } catch (e) {
      printError('Fel vid visning av personer: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  // Update person
  Future<void> _updatePersonOperation() async {
    print('\n--- Uppdatera en person ---\n');

    try {
      final personList = await personRepository.getAllPersons();

      if (personList.isEmpty) {
        print('Inga personer hittades.');
        setMainPage();
        return;
      }

      final personNrInput = _promptInput(
          'Fyll i personnummer på personen du vill uppdatera (12 siffror):');

      if (personNrInput == null || personNrInput.isEmpty) {
        print('Inget personnummer angavs. Återgår till huvudmenyn.');
        setMainPage();
        return;
      }

      final foundPersonIndex = personList
          .indexWhere((person) => person.personNumber == personNrInput);

      if (foundPersonIndex == -1) {
        print('Ingen person hittades med det angivna personnumret.');
        return;
      }

      final Person personToUpdate =
          await personRepository.getPersonById(personList[foundPersonIndex].id);

      final newName = _promptInput(
          'Nytt namn (tryck enter för att behålla aktuellt namn "${personToUpdate.name}"):');

      final updatedName =
          (newName == null || newName.isEmpty) ? personToUpdate.name : newName;

      final updateResult = await personRepository.updatePerson(
        personToUpdate.id,
        Person(
          id: personToUpdate.id,
          name: updatedName,
          personNumber: personNrInput,
        ),
      );

      print('Personen har uppdaterats framgångsrikt.');
    } catch (e) {
      print('Ett fel inträffade:');
    } finally {
      setMainPage();
    }
  }

  // Delete person

  // Future<void> _deletePersonOperation() async {
  //   print('\n--- Ta bort en person ---\n');

  //   try {
  //     // Hämta alla personer från lagret
  //     final personList = await personRepository.getAllPersons();

  //     if (personList.isEmpty) {
  //       printError('Inga personer hittades.');
  //       setMainPage();
  //       return;
  //     }

  //     String? personNrInput;

  //     // Upprepa tills användaren fyller i ett giltigt personnummer
  //     do {
  //       personNrInput = _promptInput(
  //           'Fyll i personnummer (12 siffror) på personen du vill ta bort:');
  //       if (personNrInput == null || personNrInput.isEmpty) {
  //         printError('Personnummer krävs. Försök igen.');
  //       }
  //     } while (personNrInput == null || personNrInput.isEmpty);

  //     // Kontrollera om personen existerar i listan
  //     final personIndex = personList
  //         .indexWhere((person) => person.personNumber == personNrInput);

  //     if (personIndex == -1) {
  //       printError('Ingen person hittades med det angivna personnumret.');
  //       return;
  //     }

  //     // Radera personen från lagret
  //     final result =
  //         await personRepository.deletePerson(personList[personIndex].id);

  //     if (result != null) {
  //       print('Person med personnummer $personNrInput har raderats.');
  //     } else {
  //       printError('Ett fel inträffade vid raderingen av personen.');
  //     }
  //   } catch (e) {
  //     printError('Ett oväntat fel inträffade: ${e.toString()}');
  //   } finally {
  //     setMainPage();
  //   }
  // }

  Future<void> _deletePersonOperation() async {
    print('\n--- Ta bort en person ---\n');

    try {
      // Step 1: Retrieve all persons from the repository
      final personList = await personRepository.getAllPersons();

      if (personList.isEmpty) {
        print('Inga personer hittades.');
        setMainPage();
        return;
      }

      // Step 2: Prompt for a valid personal number
      String? personNrInput;
      do {
        personNrInput = _promptInput(
            'Fyll i personnummer (12 siffror) på personen du vill ta bort:');
        if (personNrInput == null || personNrInput.isEmpty) {
          printError('Personnummer krävs. Försök igen.');
        }
      } while (personNrInput == null || personNrInput.isEmpty);

      // Step 3: Find the person in the list
      final personIndex = personList
          .indexWhere((person) => person.personNumber == personNrInput);

      if (personIndex == -1) {
        printError('Ingen person hittades med det angivna personnumret.');
        setMainPage();
        return;
      }

      final personToDelete = personList[personIndex];

      // Step 4: Delete the person from the repository
      await personRepository.deletePerson(personToDelete.id);

      // Step 5: Notify the user
      print('Person med personnummer $personNrInput har raderats.');
    } catch (e) {
      // Handle any errors during the deletion process
      printError('Ett oväntat fel inträffade: ${e.toString()}');
    } finally {
      setMainPage();
    }
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
