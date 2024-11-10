/*

class VehicleLogic extends SetMain {
  final VehicleRepository vehicleRepository = VehicleRepository.instance;
  final PersonRepository personRepository = PersonRepository.instance;
  final Validator validator = Validator();

  List<String> texts = [
    'Du har valt att hantera Fordon. Vad vill du göra?\n',
    '1. Skapa nytt fordon\n',
    '2. Visa alla fordon\n',
    '3. Uppdatera fordon\n',
    '4. Ta bort fordon\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runLogic(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addVehicleLogic();
        break;
      case 2:
        _showAllVehiclesLogic();
        break;
      case 3:
        _updateVehicleLogic();
        break;
      case 4:
        _deleteVehicleLogic();
        break;
      case 5:
        setMainPage(clearConsole: true);
        break;
      default:
        print('Ogiltigt val');
    }
  }

  Future<void> _addVehicleLogic() async {
    print('\nDu har valt att lägga till ett nytt fordon\n');
    stdout.write('Fyll i personnummer på ägaren: ');
    var socialSecurityNumberInput = stdin.readLineSync();

    if (socialSecurityNumberInput == null ||
        socialSecurityNumberInput.isEmpty) {
      print('Ogiltigt personnummer');
      setMainPage();
      return;
    }

    if (validator.isValidSocialSecurityNumber(socialSecurityNumberInput)) {
      if (socialSecurityNumberInput == '1') {
        setMainPage();
        return;
      }

      final personList = await personRepository.getAllPersons();
      final foundPerson = personList.firstWhere(
        (person) => person.personNumber == socialSecurityNumberInput,
        orElse: () => Person.empty(), // return an empty person if not found
      );

      // Check if foundPerson is valid (not empty)
      if (foundPerson.id == 0) {
        print('Personen med det angivna personnumret finns inte.');
        setMainPage();
        return;
      }

      stdout.write('Fyll i registreringsnummer: ');
      var regNrInput = stdin.readLineSync()?.toUpperCase();

      if (regNrInput == null || regNrInput.isEmpty) {
        print('Ogiltigt registreringsnummer');
        setMainPage();
        return;
      }

      stdout.write('Fyll i fordonstyp (1: Bil, 2: Motorcykel, 3: Annat): ');
      var typeInput = stdin.readLineSync();

      if (typeInput == null || typeInput.isEmpty) {
        print('Ogiltig fordonstyp');
        setMainPage();
        return;
      }

      String vehicleType;
      switch (int.parse(typeInput)) {
        case 1:
          vehicleType = 'Bil';
          break;
        case 2:
          vehicleType = 'Motorcykel';
          break;
        case 3:
          vehicleType = 'Annat';
          break;
        default:
          vehicleType = 'Annat';
          break;
      }
      await vehicleRepository.addVehicle(Vehicle(
        registrationNumber: regNrInput,
        owner: foundPerson == Person.empty() ? null : foundPerson, // owner is nullable
        type: vehicleType, // Add the required 'type' parameter
      ));

      print('Fordon tillagt!');
      setMainPage();
    } else {
      print('Ogiltigt personnummer');
      setMainPage();
    }
  }

  Future<void> _showAllVehiclesLogic() async {
    final vehicleList = await vehicleRepository.getAllVehicles();
    if (vehicleList.isEmpty) {
      print('Inga fordon att visa.');
    } else {
      for (final vehicle in vehicleList) {
        print(
            'RegNr: ${vehicle.registrationNumber}, Typ: ${vehicle.type}, Ägare: ${vehicle.owner?.name}');
      }
    }
    stdout.write('Tryck på Enter för att gå tillbaka till huvudmenyn');
    stdin.readLineSync();
    setMainPage(clearConsole: true);
  }

  Future<void> _updateVehicleLogic() async {
    print('\nDu har valt att uppdatera ett fordon\n');
    final vehicleList = await vehicleRepository.getAllVehicles();
    if (vehicleList.isEmpty) {
      print('Inga fordon att uppdatera');
      setMainPage();
      return;
    }

    stdout.write('Fyll i registreringsnummer för fordonet du vill uppdatera: ');
    var regNrInput = stdin.readLineSync()?.toUpperCase();

    if (regNrInput == null || regNrInput.isEmpty) {
      print('Ogiltigt registreringsnummer');
      setMainPage();
      return;
    }

    Vehicle? vehicle;
    try {
      vehicle = vehicleList.firstWhere(
        (v) => v.registrationNumber == regNrInput,
      );
    } catch (e) {
      vehicle = null;
    }

    if (vehicle == null) {
      print('Fordonet finns inte');
      setMainPage();
      return;
    }

    print(
        'Fyll i nytt registreringsnummer eller tryck Enter för att behålla det gamla: ');
    var newRegNr =
        stdin.readLineSync()?.toUpperCase() ?? vehicle.registrationNumber;

    if (newRegNr != vehicle.registrationNumber) {
      vehicle.registrationNumber = newRegNr;
      await vehicleRepository.updateVehicle(vehicle.id.toString(), vehicle);
      print('Fordon uppdaterat');
    } else {
      print('Ingen ändring gjord');
    }

    setMainPage();
  }

  Future<void> _deleteVehicleLogic() async {
    print('\nDu har valt att ta bort ett fordon\n');
    final vehicleList = await vehicleRepository.getAllVehicles();
    if (vehicleList.isEmpty) {
      print('Inga fordon att ta bort');
      setMainPage();
      return;
    }

    stdout.write('Fyll i registreringsnummer för fordonet du vill ta bort: ');
    var regNrInput = stdin.readLineSync()?.toUpperCase();

    if (regNrInput == null || regNrInput.isEmpty) {
      print('Ogiltigt registreringsnummer');
      setMainPage();
      return;
    }

    Vehicle? vehicle;
    try {
      vehicle = vehicleList.firstWhere(
        (v) => v.registrationNumber == regNrInput,
      );
    } catch (e) {
      vehicle = null;
    }

    if (vehicle == null) {
      print('Fordonet finns inte');
      setMainPage();
      return;
    }

    stdout.write('Är du säker på att du vill ta bort fordonet? (y/n): ');
    var confirmation = stdin.readLineSync()?.toLowerCase();

    if (confirmation == 'y') {
      await vehicleRepository.deleteVehicle(vehicle.id.toString());
      print('Fordon borttaget');
    } else {
      print('Radering avbruten');
    }

    setMainPage();
  }
}
*/

/*
import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:cli_client/repositories/VehicleRepository.dart';
import 'package:cli_client/repositories/PersonRepository.dart';
import 'package:cli_client/utils/validator.dart';

class VehicleOperations extends SetMainPage {
  final VehicleRepository vehicleRepository = VehicleRepository.instance;
  final PersonRepository personRepository = PersonRepository.instance;
  final Validator validator = Validator();

  // List of options for the vehicle menu
  List<String> texts = [
    'Du har valt att hantera Fordon. Vad vill du göra?\n',
    '1. Skapa nytt fordon\n',
    '2. Visa alla fordon\n',
    '3. Uppdatera fordon\n',
    '4. Ta bort fordon\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runOperation(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addVehicleOperation();
        break;
      case 2:
        _showAllVehiclesOperation();
        break;
      case 3:
        _updateVehicleOperation();
        break;
      case 4:
        _deleteVehicleOperation();
        break;
      case 5:
        setMainPage(clearCLI: true);
        break;
      default:
        print('Ogiltigt val');
    }
  }

  // Method for adding a new vehicle
  void _addVehicleOperation() async {
    print('\nDu har valt att skapa ett nytt fordon\n');
    stdout.write('Fyll i registreringsnummer (t.ex. ABC123): ');
    var regNr = stdin.readLineSync();

    if (regNr == null || regNr.isEmpty) {
      print('Ogiltigt registreringsnummer.');
      setMainPage();
      return;
    }

    stdout.write('Fyll i fordons typ (t.ex. Bil, Lastbil): ');
    var vehicleType = stdin.readLineSync();

    if (vehicleType == null || vehicleType.isEmpty) {
      print('Ogiltig fordons typ.');
      setMainPage();
      return;
    }

    // Displaying all persons to choose the owner
    final personList = await personRepository.getAllPersons();
    if (personList.isEmpty) {
      print('Inga personer att välja som ägare.');
      setMainPage();
      return;
    }

    print('Välj en ägare från listan:');
    for (int i = 0; i < personList.length; i++) {
      print('${i + 1}. ${personList[i].name} - ${personList[i].personNumber}');
    }

    stdout.write('Välj index för att välja ägare: ');
    var ownerIndex = stdin.readLineSync();

    if (ownerIndex == null ||
        ownerIndex.isEmpty ||
        int.tryParse(ownerIndex) == null) {
      print('Ogiltigt val.');
      setMainPage();
      return;
    }

    int index = int.parse(ownerIndex) - 1;
    if (index < 0 || index >= personList.length) {
      print('Ogiltigt index.');
      setMainPage();
      return;
    }

    Person owner = personList[index];

    // Create a new Vehicle object and save it
    Vehicle newVehicle =
        Vehicle(regNr: regNr, vehicleType: vehicleType, owner: owner);

    await vehicleRepository.addVehicle(newVehicle);
    print('Fordon skapades framgångsrikt.');
    setMainPage();
  }

  // Method for showing all vehicles
  void _showAllVehiclesOperation() async {
    print('\nAlla registrerade fordon:');
    final vehicles = await vehicleRepository.getAllVehicles();
    if (vehicles.isEmpty) {
      print('Inga fordon att visa.');
    } else {
      for (var vehicle in vehicles) {
        print(
            'Registreringsnummer: ${vehicle.regNr}, Typ: ${vehicle.vehicleType}, Ägare: ${vehicle.owner.name}');
      }
    }
    stdout.write('Tryck på Enter för att gå tillbaka till huvudmenyn.');
    stdin.readLineSync();
    setMainPage(clearCLI: true);
  }

  // Method for updating a vehicle
  void _updateVehicleOperation() async {
    print('\nDu har valt att uppdatera ett fordon\n');
    final vehicles = await vehicleRepository.getAllVehicles();

    if (vehicles.isEmpty) {
      print('Inga fordon att uppdatera.');
      setMainPage();
      return;
    }

    print('Välj ett fordon att uppdatera:');
    for (int i = 0; i < vehicles.length; i++) {
      print('${i + 1}. ${vehicles[i].regNr} - ${vehicles[i].vehicleType}');
    }

    stdout.write('Välj index för att uppdatera: ');
    var vehicleIndex = stdin.readLineSync();

    if (vehicleIndex == null ||
        vehicleIndex.isEmpty ||
        int.tryParse(vehicleIndex) == null) {
      print('Ogiltigt val.');
      setMainPage();
      return;
    }

    int index = int.parse(vehicleIndex) - 1;
    if (index < 0 || index >= vehicles.length) {
      print('Ogiltigt index.');
      setMainPage();
      return;
    }

    Vehicle vehicleToUpdate = vehicles[index];
    stdout.write(
        'Uppdatera registreringsnummer (nuvarande: ${vehicleToUpdate.regNr}): ');
    var newRegNr = stdin.readLineSync();
    if (newRegNr != null && newRegNr.isNotEmpty) {
      vehicleToUpdate.regNr = newRegNr;
    }

    stdout.write(
        'Uppdatera fordons typ (nuvarande: ${vehicleToUpdate.vehicleType}): ');
    var newVehicleType = stdin.readLineSync();
    if (newVehicleType != null && newVehicleType.isNotEmpty) {
      vehicleToUpdate.vehicleType = newVehicleType;
    }

    await vehicleRepository.updateVehicle(
        vehicleToUpdate.id.toString(), vehicleToUpdate);
    print('Fordon uppdaterat framgångsrikt.');
    setMainPage();
  }

  // Method for deleting a vehicle
  void _deleteVehicleOperation() async {
    print('\nDu har valt att ta bort ett fordon\n');
    final vehicles = await vehicleRepository.getAllVehicles();

    if (vehicles.isEmpty) {
      print('Inga fordon att ta bort.');
      setMainPage();
      return;
    }

    print('Välj ett fordon att ta bort:');
    for (int i = 0; i < vehicles.length; i++) {
      print('${i + 1}. ${vehicles[i].regNr} - ${vehicles[i].vehicleType}');
    }

    stdout.write('Välj index för att ta bort: ');
    var vehicleIndex = stdin.readLineSync();

    if (vehicleIndex == null ||
        vehicleIndex.isEmpty ||
        int.tryParse(vehicleIndex) == null) {
      print('Ogiltigt val.');
      setMainPage();
      return;
    }

    int index = int.parse(vehicleIndex) - 1;
    if (index < 0 || index >= vehicles.length) {
      print('Ogiltigt index.');
      setMainPage();
      return;
    }

    Vehicle vehicleToDelete = vehicles[index];
    await vehicleRepository.deleteVehicle(vehicleToDelete.id.toString());
    print('Fordon raderat framgångsrikt.');
    setMainPage();
  }
}
*/

import 'dart:convert';
import 'dart:io';
import 'package:cli_shared/cli_shared.dart';
import 'package:cli_client/utils/console.dart';
import 'package:cli_client/utils/validator.dart';
// Importera ObjectBox
import 'main.dart';
//import 'vehicle.dart'; // Importera Vehicle-klass (Entity)
//import 'person.dart';  // Importera Person-klass för ägaren

class VehicleOperations extends SetMainPage {
  // ObjectBox Store och Box
  final Store _store = Store(getObjectBoxModel());
  late final Box<Vehicle> vehicleBox;
  late final Box<Person> personBox;

  VehicleOperations() {
    // Initiera Box för Vehicle och Person
    vehicleBox = _store.box<Vehicle>();
    personBox = _store.box<Person>();
  }

  // Menytext för fordonshantering
  List<String> texts = [
    'Du har valt att hantera Fordon. Vad vill du göra?\n',
    '1. Skapa nytt fordon\n',
    '2. Visa alla fordon\n',
    '3. Uppdatera fordon\n',
    '4. Ta bort fordon\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  // Hantera användarens val för fordonsoperationer
  void runOperation(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addVehicleOperation();
        break;
      case 2:
        _showAllVehiclesOperation();
        break;
      case 3:
        _updateVehicleOperation();
        break;
      case 4:
        _deleteVehicleOperation();
        break;
      case 5:
        setMainPage(clearCLI: true);
        break;
      default:
        _showInvalidChoice();
    }
  }

  // Skapa ett nytt fordon
  void _addVehicleOperation() {
    print('Ange registreringsnummer:');
    String regNumber = stdin.readLineSync() ?? '';

    print('Ange fordons typ (ex. Bil, Lastbil):');
    String vehicleType = stdin.readLineSync() ?? '';

    print('Vill du ange en ägare? (Ja/Nej):');
    String? ownerResponse = stdin.readLineSync();

    Person? owner;
    if (ownerResponse != null && ownerResponse.toLowerCase() == 'ja') {
      print('Ange personnummer för ägaren:');
      String ownerPersonNumber = stdin.readLineSync() ?? '';
      owner = personBox
          .query(Person_.personNumber.equals(ownerPersonNumber)
              as Condition<Person>)
          .build()
          .findFirst();
    }

    // Skapa ett nytt Vehicle-objekt
    Vehicle newVehicle = Vehicle(
      regNr: regNumber,
      vehicleType: vehicleType,
      owner: owner ?? Person(name: 'Okänd ägare', personNumber: '00000000'),
    );

    // Spara fordonet i ObjectBox
    vehicleBox.put(newVehicle);

    print(
        'Fordon med registreringsnummer ${newVehicle.regNr} har skapats och sparats lokalt.');
  }

  // Visa alla fordon
  void _showAllVehiclesOperation() {
    List<Vehicle> allVehicles = vehicleBox.getAll();

    if (allVehicles.isEmpty) {
      print('Inga fordon finns i systemet.');
    } else {
      print('Alla fordon:');
      for (var vehicle in allVehicles) {
        String ownerName = vehicle.owner?.name ?? 'Ingen ägare';
        print(
            'ID: ${vehicle.id}, Regnummer: ${vehicle.regNr}, Typ: ${vehicle.vehicleType}, Ägare: $ownerName');
      }
    }
  }

  // Uppdatera ett fordon
  void _updateVehicleOperation() {
    print('Ange ID för det fordon du vill uppdatera:');
    int? vehicleId = int.tryParse(stdin.readLineSync() ?? '');

    if (vehicleId == null || vehicleId == 0) {
      print('Ogiltigt ID.');
      return;
    }

    // Hämta fordonet baserat på ID
    Vehicle? existingVehicle = vehicleBox.get(vehicleId);

    if (existingVehicle == null) {
      print('Fordon med ID $vehicleId finns inte.');
    } else {
      print(
          'Ange nytt registreringsnummer (nuvarande: ${existingVehicle.regNr}):');
      String newRegNumber = stdin.readLineSync() ?? existingVehicle.regNr;

      print('Ange ny fordons typ (nuvarande: ${existingVehicle.vehicleType}):');
      String newVehicleType =
          stdin.readLineSync() ?? existingVehicle.vehicleType;

      // Uppdatera värden
      existingVehicle.regNr = newRegNumber;
      existingVehicle.vehicleType = newVehicleType;

      print('Vill du uppdatera ägaren? (Ja/Nej):');
      String? ownerResponse = stdin.readLineSync();

      if (ownerResponse != null && ownerResponse.toLowerCase() == 'ja') {
        print('Ange personnummer för den nya ägaren:');
        String newOwnerPersonNumber = stdin.readLineSync() ?? '';
        existingVehicle.owner = personBox
            .query(Person_.personNumber.equals(newOwnerPersonNumber)
                as Condition<Person>?)
            .build()
            .findFirst()!;
      }

      // Uppdatera fordonet i ObjectBox
      vehicleBox.put(existingVehicle);

      print('Fordon med ID ${existingVehicle.id} har uppdaterats.');
    }
  }

  // Ta bort ett fordon
  void _deleteVehicleOperation() {
    print('Ange ID för det fordon du vill ta bort:');
    int? vehicleId = int.tryParse(stdin.readLineSync() ?? '');

    if (vehicleId == null || vehicleId == 0) {
      print('Ogiltigt ID.');
      return;
    }

    // Hämta och ta bort fordonet baserat på ID
    Vehicle? vehicleToDelete = vehicleBox.get(vehicleId);

    if (vehicleToDelete == null) {
      print('Fordon med ID $vehicleId finns inte.');
    } else {
      // Ta bort från databasen
      vehicleBox.remove(vehicleId);
      print('Fordon med ID $vehicleId har tagits bort.');
    }
  }

  // Hantera ogiltiga val
  void _showInvalidChoice() {
    print('Ogiltigt val, vänligen försök igen.');
  }
}
