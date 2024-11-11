import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import '../repositories/ParkingRepository.dart';
import '../repositories/ParkingSpaceRepository.dart';
import '../repositories/VehicleRepository.dart';
import 'package:cli_shared/models/Parking.dart';

class ParkingsOperations extends SetMainPage {
  final ParkingRepository parkingRepository = ParkingRepository.instance;
  final ParkingSpaceRepository parkingSpaceRepository =
      ParkingSpaceRepository.instance;
  final VehicleRepository vehicleRepository = VehicleRepository.instance;

  final List<String> menuTexts = [
    'Du har valt att hantera Parkeringar. Vad vill du göra?\n',
    '1. Skapa ny parkering\n',
    '2. Visa alla parkeringar\n',
    '3. Uppdatera parkering\n',
    '4. Ta bort parkering\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runOperation(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addParkingOperation();
        break;
      case 2:
        _showAllParkingsOperation();
        break;
      case 3:
        _updateParkingOperation();
        break;
      case 4:
        _deleteParkingOperation();
        break;
      case 5:
        setMainPage(clearCLI: true);
        return;
      default:
        _printError('Ogiltigt val, vänligen försök igen.');
    }
  }

  // Add new parking entry
  Future<void> _addParkingOperation() async {
    print('\n--- Skapa ny parkering ---');
    final regNumber = _promptInput('Ange registreringsnummer för fordonet:');
    final parkingAddress = _promptInput('Ange adress för parkeringsplatsen:');
    final startTimeInput = _promptInput('Ange starttid (yyyy-mm-dd hh:mm):');
    final endTimeInput = _promptInput('Ange sluttid (yyyy-mm-dd hh:mm):');

    if ([regNumber, parkingAddress, startTimeInput, endTimeInput]
        .contains(null)) {
      _printError('Alla fält måste fyllas i.');
      return;
    }

    final vehicle = await vehicleRepository.getVehicleByRegNumber(regNumber!);
    final parkingSpace =
        await parkingSpaceRepository.getParkingSpaceById(parkingAddress!);

    if (vehicle == null) {
      _printError('Fordonet med registreringsnummer $regNumber hittades inte.');
      return;
    }
    if (parkingSpace == null) {
      _printError(
          'Parkeringsplatsen med adress $parkingAddress hittades inte.');
      return;
    }

    try {
      final startTime = DateTime.parse(startTimeInput!);
      final endTime = DateTime.parse(endTimeInput!);

      if (endTime.isBefore(startTime)) {
        _printError('Sluttiden kan inte vara före starttiden.');
        return;
      }

      final parking = Parking(
        vehicle: vehicle,
        parkingSpace: parkingSpace,
        startTime: startTime,
        endTime: endTime,
      );

      await parkingRepository.addParking(parking);
      print(
          'Parkering tillagd för fordon ${vehicle.regNumber} på ${parkingSpace.address}.');
    } catch (e) {
      _printError('Ogiltigt tidsformat.');
    }
    setMainPage();
  }

  // Show all parking entries
  Future<void> _showAllParkingsOperation() async {
    print('\n--- Alla parkeringar ---');
    final parkings = await parkingRepository.getAllParkings();

    if (parkings.isEmpty) {
      print('Inga parkeringar hittades.');
    } else {
      for (var parking in parkings) {
        print(
            'Fordon: ${parking.vehicle?.regNumber}, Adress: ${parking.parkingSpace?.address}, '
            'Starttid: ${parking.startTime}, Sluttid: ${parking.endTime}');
      }
    }
    _waitForUserInput();
  }

  // Update a parking entry
  Future<void> _updateParkingOperation() async {
    print('\n--- Uppdatera parkering ---');
    final regNumber = _promptInput(
        'Ange registreringsnummer för fordonet du vill uppdatera:');

    if (regNumber == null) {
      _printError('Registreringsnummer krävs.');
      return;
    }

    final parking = await parkingRepository.getParkingById(regNumber);
    if (parking == null) {
      _printError(
          'Ingen parkering hittades för fordon med registreringsnummer $regNumber.');
      return;
    }

    final newStartTimeInput = _promptInput(
        'Ny starttid (yyyy-mm-dd hh:mm, lämna tomt för att behålla aktuell):');
    final newEndTimeInput = _promptInput(
        'Ny sluttid (yyyy-mm-dd hh:mm, lämna tomt för att behålla aktuell):');

    if (newStartTimeInput != null) {
      parking.startTime =
          DateTime.tryParse(newStartTimeInput) ?? parking.startTime;
    }
    if (newEndTimeInput != null) {
      final newEndTime = DateTime.tryParse(newEndTimeInput);
      if (newEndTime != null && newEndTime.isAfter(parking.startTime)) {
        parking.endTime = newEndTime;
      } else {
        _printError('Ogiltig sluttid.');
      }
    }

    await parkingRepository.updateParking(parking.id.toString(), parking);
    print(
        'Parkeringen för fordon ${parking.vehicle?.regNumber} har uppdaterats.');
    setMainPage();
  }

  // Delete a parking entry
  Future<void> _deleteParkingOperation() async {
    print('\n--- Ta bort parkering ---');
    final regNumber =
        _promptInput('Ange registreringsnummer för att ta bort parkeringen:');

    if (regNumber == null) {
      _printError('Registreringsnummer krävs.');
      return;
    }

    final parking = await parkingRepository.getParkingById(regNumber);
    if (parking != null) {
      await parkingRepository.deleteParking(parking.id.toString());
      print(
          'Parkeringen för fordon ${parking.vehicle?.regNumber} har tagits bort.');
    } else {
      _printError(
          'Ingen parkering hittades för fordon med registreringsnummer $regNumber.');
    }
    setMainPage();
  }

  // Input prompt helper
  String? _promptInput(String promptText) {
    stdout.write(promptText);
    return stdin.readLineSync()?.trim();
  }

  // Wait for user action before returning to main menu
  void _waitForUserInput() {
    print('Tryck på valfri tangent för att återgå till huvudmenyn.');
    stdin.readLineSync();
    setMainPage(clearCLI: true);
  }

  // Error message helper
  void _printError(String message) {
    print('Fel: $message');
  }
}
