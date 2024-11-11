import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_client/repositories/PersonRepository.dart';
import 'package:cli_client/repositories/VehicleRepository.dart';
import 'package:cli_shared/models/Vehicle.dart';
import 'package:cli_shared/models/Person.dart';
import 'package:cli_client/utils/validator.dart';

class VehiclesOperations extends SetMainPage {
  final VehicleRepository _vehicleRepository = VehicleRepository.instance;
  final PersonRepository _personRepository = PersonRepository.instance;

  List<String> menuTexts = [
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
        return;
      default:
        _printError('Ogiltigt val, vänligen försök igen.');
    }
  }

  // Create new vehicle
  Future<void> _addVehicleOperation() async {
    print('\n--- Skapa nytt fordon ---');
    final regNumber = _promptInput('Ange registreringsnummer:');
    final vehicleType =
        _promptInput('Ange fordonstyp (t.ex., bil, motorcykel):');
    final ownerSSN = _promptInput('Ange ägarens personnummer (valfritt):');

    if (Validator.isString(regNumber) && Validator.isString(vehicleType)) {
      Person? owner;

      if (ownerSSN != null && Validator.isValidSocialSecurityNumber(ownerSSN)) {
        owner = await _personRepository.getPersonByPersonNumber(ownerSSN);
        if (owner == null) {
          print(
              'Ingen person hittades med personnummer $ownerSSN. Fordonet kommer inte ha någon ägare.');
        }
      }

      final vehicle = Vehicle(
        regNumber: regNumber!,
        vehicleType: vehicleType!,
        owner: owner,
      );
      await _vehicleRepository.addVehicle(vehicle);
      print(
          'Fordon med registreringsnummer ${vehicle.regNumber} har lagts till.');
    } else {
      _printError('Ogiltig inmatning, fordonet skapades inte.');
    }
    setMainPage();
  }

  // Show all vehicles
  Future<void> _showAllVehiclesOperation() async {
    print('\n--- Alla fordon ---');
    final vehicles = await _vehicleRepository.getAllVehicles();

    if (vehicles.isEmpty) {
      print('Inga fordon hittades.');
    } else {
      vehicles.asMap().forEach((index, vehicle) {
        final ownerInfo = vehicle.owner != null
            ? 'Ägare: ${vehicle.owner!.name}, Personnummer: ${vehicle.owner!.personNumber}'
            : 'Ingen ägare';
        print(
            '${index + 1}. Registreringsnummer: ${vehicle.regNumber}, Typ: ${vehicle.vehicleType}, $ownerInfo');
      });
    }
    setMainPage();
  }

  // Update vehicle
  Future<void> _updateVehicleOperation() async {
    print('\n--- Uppdatera fordon ---');
    final regNumber = _promptInput(
        'Ange registreringsnummer för det fordon du vill uppdatera:');

    if (!Validator.isString(regNumber)) {
      _printError('Ogiltig inmatning.');
      return;
    }

    final vehicle = await _vehicleRepository.getVehicleByRegNumber(regNumber!);
    if (vehicle == null) {
      _printError('Fordonet hittades inte.');
      return;
    }

    final newRegNumber = _promptInput(
        'Nytt registreringsnummer (lämna tomt för att behålla aktuellt):');
    final newVehicleType =
        _promptInput('Ny fordonstyp (lämna tomt för att behålla aktuell):');
    final newOwnerSSN =
        _promptInput('Ange nytt ägarens personnummer (valfritt):');

    if (Validator.isString(newRegNumber) && newRegNumber!.isNotEmpty) {
      vehicle.regNumber = newRegNumber;
    }
    if (Validator.isString(newVehicleType) && newVehicleType!.isNotEmpty) {
      vehicle.vehicleType = newVehicleType;
    }

    if (newOwnerSSN != null &&
        Validator.isValidSocialSecurityNumber(newOwnerSSN)) {
      final newOwner =
          await _personRepository.getPersonByPersonNumber(newOwnerSSN);
      if (newOwner != null) {
        vehicle.owner = newOwner;
      } else {
        print(
            'Ingen person hittades med personnummer $newOwnerSSN. Ägaren kommer inte att uppdateras.');
      }
    }

    await _vehicleRepository.updateVehicle(vehicle.regNumber, vehicle);
    print('Fordonet har uppdaterats.');
    setMainPage();
  }

  // Delete vehicle
  Future<void> _deleteVehicleOperation() async {
    print('\n--- Ta bort fordon ---');
    final regNumber = _promptInput(
        'Ange registreringsnummer för det fordon du vill ta bort:');

    if (!Validator.isString(regNumber)) {
      _printError('Ogiltig inmatning.');
      return;
    }

    final vehicle = await _vehicleRepository.getVehicleByRegNumber(regNumber!);
    if (vehicle != null) {
      await _vehicleRepository.deleteVehicle(vehicle.regNumber);
      print(
          'Fordon med registreringsnummer ${vehicle.regNumber} har tagits bort.');
    } else {
      _printError('Fordonet hittades inte.');
    }
    setMainPage();
  }

  // Prompt input helper
  static String? _promptInput(String promptText) {
    stdout.write(promptText);
    return stdin.readLineSync()?.trim();
  }

  // Error print helper
  static void _printError(String message) {
    print('Fel: $message');
  }
}
