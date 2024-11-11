import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_client/repositories/ParkingSpaceRepository.dart';
import 'package:cli_shared/models/ParkingSpace.dart';
import 'package:cli_client/utils/validator.dart';

class ParkingSpaceOperations extends SetMainPage {
  final ParkingSpaceRepository parkingSpaceRepository =
      ParkingSpaceRepository.instance;

  final List<String> menuTexts = [
    'Du har valt att hantera Parkeringsplatser. Vad vill du göra?\n',
    '1. Skapa ny parkeringsplats\n',
    '2. Visa alla parkeringsplatser\n',
    '3. Uppdatera parkeringsplats\n',
    '4. Ta bort parkeringsplats\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runOperation(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addParkingSpaceOperation();
        break;
      case 2:
        _showAllParkingSpacesOperation();
        break;
      case 3:
        _updateParkingSpaceOperation();
        break;
      case 4:
        _deleteParkingSpaceOperation();
        break;
      case 5:
        setMainPage(clearCLI: true);
        return;
      default:
        _printError('Ogiltigt val, försök igen.');
    }
  }

  // Add new parking space
  Future<void> _addParkingSpaceOperation() async {
    print('\n--- Skapa ny parkeringsplats ---');
    final address = _promptInput('Ange adress för parkeringsplatsen:');
    final pricePerHourInput = _promptInput('Ange pris per timme:');

    if (!_isValidAddressAndPrice(address, pricePerHourInput)) return;

    final pricePerHour = double.parse(pricePerHourInput!);
    final parkingSpace = ParkingSpace(
      address: address!,
      pricePerHour: pricePerHour.toInt(),
    );
    await parkingSpaceRepository.addParkingSpace(parkingSpace);
    print('Parkeringsplats på ${parkingSpace.address} har lagts till.');
    setMainPage();
  }

  // Show all parking spaces
  Future<void> _showAllParkingSpacesOperation() async {
    print('\n--- Alla parkeringsplatser ---');
    final parkingSpaces = await parkingSpaceRepository.getAllParkingSpaces();

    if (parkingSpaces.isEmpty) {
      print('Inga parkeringsplatser hittades.');
    } else {
      for (var i = 0; i < parkingSpaces.length; i++) {
        final space = parkingSpaces[i];
        print(
            '${i + 1}. Adress: ${space.address}, Pris per timme: ${space.pricePerHour} kr');
      }
    }
    _waitForUserInput();
  }

  // Update parking space
  Future<void> _updateParkingSpaceOperation() async {
    print('\n--- Uppdatera parkeringsplats ---');
    final address = _promptInput(
        'Ange adressen för den parkeringsplats du vill uppdatera:');

    if (!_validateStringInput(address, 'Ogiltig adress.')) return;

    final parkingSpace =
        await parkingSpaceRepository.getParkingSpaceById(address!);
    if (parkingSpace == null) {
      _printError('Parkeringsplatsen hittades inte.');
      return;
    }

    final newAddress =
        _promptInput('Ny adress (lämna tomt för att behålla aktuell):');
    final newPriceInput = _promptInput(
        'Nytt pris per timme (lämna tomt för att behålla aktuellt):');

    if (Validator.isString(newAddress) && newAddress!.isNotEmpty) {
      parkingSpace.address = newAddress;
    }
    if (Validator.isNumber(newPriceInput) && newPriceInput!.isNotEmpty) {
      parkingSpace.pricePerHour = double.parse(newPriceInput).toInt();
    }

    await parkingSpaceRepository.updateParkingSpace(
        parkingSpace.id.toString(), parkingSpace);
    print('Parkeringsplatsen har uppdaterats.');
    setMainPage();
  }

  // Delete parking space
  Future<void> _deleteParkingSpaceOperation() async {
    print('\n--- Ta bort parkeringsplats ---');
    final address =
        _promptInput('Ange adressen för den parkeringsplats du vill ta bort:');

    if (!_validateStringInput(address, 'Ogiltig adress.')) return;

    final parkingSpace =
        await parkingSpaceRepository.getParkingSpaceById(address!);
    if (parkingSpace != null) {
      await parkingSpaceRepository
          .deleteParkingSpace(parkingSpace.id.toString());
      print('Parkeringsplatsen på ${parkingSpace.address} har tagits bort.');
    } else {
      _printError('Parkeringsplatsen hittades inte.');
    }
    setMainPage();
  }

  // Helper for input prompts
  String? _promptInput(String promptText) {
    stdout.write(promptText);
    return stdin.readLineSync()?.trim();
  }

  // Wait for user input before returning to main menu
  void _waitForUserInput() {
    print('Tryck på valfri tangent för att återgå till huvudmenyn.');
    stdin.readLineSync();
    setMainPage(clearCLI: true);
  }

  // Validate address and price input
  bool _isValidAddressAndPrice(String? address, String? pricePerHourInput) {
    if (!Validator.isString(address) ||
        !Validator.isNumber(pricePerHourInput)) {
      _printError('Ogiltig adress eller pris, vänligen försök igen.');
      return false;
    }
    return true;
  }

  // Validate single string input
  bool _validateStringInput(String? input, String errorMessage) {
    if (!Validator.isString(input) || input == null || input.isEmpty) {
      _printError(errorMessage);
      return false;
    }
    return true;
  }

  // Error print helper
  void _printError(String message) {
    print('Fel: $message');
  }
}
