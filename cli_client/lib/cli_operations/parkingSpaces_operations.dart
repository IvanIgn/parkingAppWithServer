import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_client/repositories/ParkingSpaceRepository.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:cli_client/utils/validator.dart';

/// Hanterar operationer för parkeringsplatser
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

  /// Kör vald operation baserat på användarens input
  void runOperation(int chosenOption) {
    try {
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
          Validator.printError('Ogiltigt val, försök igen.');
      }
    } catch (e) {
      Validator.printError('Ett oväntat fel inträffade: ${e.toString()}');
    }
  }

  /// Skapa ny parkeringsplats
  Future<void> _addParkingSpaceOperation() async {
    try {
      print('\n--- Skapa ny parkeringsplats ---');

      // Address input
      String? address;
      do {
        address = _promptInput('Ange adress för parkeringsplatsen:');
        if (address == null || address.trim().isEmpty) {
          _printError('Adressen får inte vara tom. Försök igen.');
        }
      } while (address == null || address.trim().isEmpty);

      // Price per hour input
      String? pricePerHourInput;
      double? pricePerHour;
      do {
        pricePerHourInput = _promptInput('Ange pris per timme:');
        if (pricePerHourInput == null ||
            pricePerHourInput.trim().isEmpty ||
            double.tryParse(pricePerHourInput) == null ||
            double.parse(pricePerHourInput) <= 0) {
          _printError(
              'Ogiltigt pris. Ange ett positivt numeriskt värde. Försök igen.');
        } else {
          pricePerHour = double.parse(pricePerHourInput);
        }
      } while (pricePerHourInput == null ||
          pricePerHourInput.trim().isEmpty ||
          pricePerHour == null ||
          pricePerHour <= 0);

      // Create parking space and add to repository
      final parkingSpace = ParkingSpace(
        address: address,
        pricePerHour: pricePerHour.toInt(),
      );
      await parkingSpaceRepository.createParkingSpace(parkingSpace);
      print('Parkeringsplats på "${parkingSpace.address}" har lagts till.');
    } catch (e) {
      _printError('Fel vid skapande av parkeringsplats: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  /// Visa alla parkeringsplatser
  Future<void> _showAllParkingSpacesOperation() async {
    try {
      print('\n--- Alla parkeringsplatser ---\n');

      // Fetch all parking spaces
      final parkingSpaces = await parkingSpaceRepository.getAllParkingSpaces();

      // Handle case where no parking spaces are found
      if (parkingSpaces.isEmpty) {
        print('Inga parkeringsplatser hittades.');
      } else {
        // Iterate through and display each parking space
        for (var space in parkingSpaces) {
          print(
              'ID: ${space.id}, Adress: ${space.address}, Pris per timme: ${space.pricePerHour} kr');
        }
        print('\n');
      }
    } catch (e) {
      // Handle any errors during the operation
      _printError('Fel vid visning av parkeringsplatser: ${e.toString()}');
    } finally {
      // Return to main menu
      setMainPage();
    }
  }

  /// Uppdatera parkeringsplats
  Future<void> _updateParkingSpaceOperation() async {
    print('\n--- Uppdatera en parkeringsplats ---');

    try {
      // Step 1: Fetch all parking spaces
      final parkingSpaceList =
          await parkingSpaceRepository.getAllParkingSpaces();
      if (parkingSpaceList.isEmpty) {
        print('Inga parkeringsplatser hittades för att uppdatera.');
        setMainPage();
        return;
      }

      // Step 2: Prompt for the address of the parking space to update
      String? address;
      do {
        address = _promptInput(
            'Ange adressen för den parkeringsplats du vill uppdatera:');
        if (address == null || address.trim().isEmpty) {
          _printError('Adressen är obligatorisk. Försök igen.');
        }
      } while (address == null || address.trim().isEmpty);

      // Step 3: Find the parking space by address
      final foundParkingSpaceIndex =
          parkingSpaceList.indexWhere((space) => space.address == address);

      if (foundParkingSpaceIndex == -1) {
        _printError('Ingen parkeringsplats hittades med adressen "$address".');
        setMainPage();
        return;
      }

      final parkingSpaceToUpdate = parkingSpaceList[foundParkingSpaceIndex];

      // Step 4: Prompt for new address and price per hour
      final newAddress = _promptInput(
          'Ange ny adress för parkeringsplatsen (lämna tomt för att behålla aktuell):');
      final newPriceInput = _promptInput(
          'Ange nytt pris per timme (lämna tomt för att behålla aktuellt):');

      // Step 5: Update the address and/or price per hour
      final updatedAddress = (newAddress == null || newAddress.trim().isEmpty)
          ? parkingSpaceToUpdate.address
          : newAddress.trim();
      final updatedPricePerHour =
          (newPriceInput == null || newPriceInput.trim().isEmpty)
              ? parkingSpaceToUpdate.pricePerHour
              : double.parse(newPriceInput).toInt();

      // Step 6: Update the parking space in the repository
      await parkingSpaceRepository.updateParkingSpace(
        parkingSpaceToUpdate.id,
        ParkingSpace(
          id: parkingSpaceToUpdate.id,
          address: updatedAddress,
          pricePerHour: updatedPricePerHour,
        ),
      );

      // Notify the user
      print('Parkeringsplatsen med adress "$updatedAddress" har uppdaterats.');
    } catch (e) {
      _printError(
          'Ett fel inträffade vid uppdatering av parkeringsplats: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  Future<void> _deleteParkingSpaceOperation() async {
    print('\n--- Ta bort en parkeringsplats ---\n');

    try {
      // Step 1: Retrieve all parking spaces from the repository
      final parkingSpaceList =
          await parkingSpaceRepository.getAllParkingSpaces();

      if (parkingSpaceList.isEmpty) {
        print('Inga parkeringsplatser hittades.');
        setMainPage();
        return;
      }

      // Step 2: Prompt the user for the ID of the parking space to delete
      String? idInput;
      int? parkingSpaceId;
      do {
        idInput =
            _promptInput('Ange ID för den parkeringsplats du vill ta bort:');
        if (idInput == null ||
            idInput.isEmpty ||
            !Validator.isNumber(idInput)) {
          _printError('Ogiltigt ID. Ange ett positivt heltal.');
        } else {
          parkingSpaceId = int.tryParse(idInput);
        }
      } while (idInput == null || idInput.isEmpty || parkingSpaceId == null);

      // Step 3: Find the parking space by ID
      final parkingSpaceIndex =
          parkingSpaceList.indexWhere((space) => space.id == parkingSpaceId);

      if (parkingSpaceIndex == -1) {
        _printError('Ingen parkeringsplats hittades med det angivna ID:et.');
        setMainPage();
        return;
      }

      final parkingSpaceToDelete = parkingSpaceList[parkingSpaceIndex];

      // Step 4: Delete the parking space from the repository
      await parkingSpaceRepository.deleteParkingSpace(parkingSpaceToDelete.id);

      // Notify the user
      print(
          'Parkeringsplatsen med ID ${parkingSpaceToDelete.id} har tagits bort.');
    } catch (e) {
      _printError('Ett oväntat fel inträffade: ${e.toString()}');
    } finally {
      setMainPage();
    }
  }

  /// Hjälpmetod för att hämta inmatning
  String? _promptInput(String promptText) {
    stdout.write(promptText);
    return stdin.readLineSync()?.trim();
  }

  /// Hjälpmetod för felutskrift
  void _printError(String message) {
    print('Fel: $message');
  }
}
