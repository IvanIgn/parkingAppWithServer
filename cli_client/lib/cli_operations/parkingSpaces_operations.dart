/*
class ParkingSpaceOperations extends SetMainPage {
  final ParkingSpaceRepository parkingSpaceRepository =
      ParkingSpaceRepository.instance;

  List<String> texts = [
    'Du har vara Parkeringsplatser. Vad vill du göra?\n',
    '1. Skapa ny parkeringsplats\n',
    '2. Visa alla parkeringsplatser\n',
    '3. Uppdatera parkeringsplatser\n',
    '4. Ta bort parkeringsplatser\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runLogic(int chosenOption) {
    switch (chosenOption) {
      case 1:
        _addParkingSpaceOperation();
        break;
      case 2:
        _showAllParkingSpacesOperation();
        break;
      case 3:
        _updateParkingSpacesOperation();
        break;
      case 4:
        _deleteParkingSpaceOperation();
        break;
      case 5:
        setMainPage(clearCLI: true);
        return;
      default:
        print('Ogiltigt val');
        return;
    }
  }

  void _addParkingSpaceOperation() async {
    print('\nDu har valt att skapa en ny parkeringsplats\n');

    stdout.write('Fyll i adress: ');
    var addressInput = stdin.readLineSync();

    if (addressInput == null || addressInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något adress, vänligen fyll i ett adress: ');
      addressInput = stdin.readLineSync();
    }

    if (addressInput == null || addressInput.isEmpty) {
      setMainPage();
      return;
    }

    stdout.write('Fyll i pris per timme för parkeringsplatsen: ');
    var pricePerHourInput = stdin.readLineSync();

    if (pricePerHourInput == null || pricePerHourInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något pris per timme för parkeringsplatsen, vänligen fyll i ett pris per timme för parkeringsplatsen: ');
      pricePerHourInput = stdin.readLineSync();
    }

    // Dubbelkollar så inga tomma värden skickas
    if (pricePerHourInput == null || pricePerHourInput.isEmpty) {
      setMainPage();
      return;
    }
    final RegExp numberRegExp = RegExp(r'\d');
    if (numberRegExp.hasMatch(pricePerHourInput)) {
      final pricePerHourFormatted = int.parse(pricePerHourInput);

      final res = await parkingSpaceRepository.addParkingSpace(ParkingSpace(
          address: addressInput, pricePerHour: pricePerHourFormatted));
      if (res.statusCode == 200) {
        print(
            'Parkeringsplats tillagd, välj att se alla i menyn för att se parkeringsplatser');
      } else {
        print('Något gick fel du omdirigeras till huvudmenyn');
      }
      setMainPage();
    } else {
      getBackToMainPage('Du angav ett felaktigt värde');
      return;
    }
  }

  void _showAllParkingSpacesOperation() async {
    final parkingSpaceList = await parkingSpaceRepository.getAllParkingSpaces();
    if (parkingSpaceList.isNotEmpty) {
      for (var parkingSpace in parkingSpaceList) {
        print(
          'Id: ${parkingSpace.id}\n Adress: ${parkingSpace.address}\n Pris per timme: ${parkingSpace.pricePerHour}',
        );
      }
    } else {
      print('Inga parkeringsplatser att visa för tillfället....');
    }
    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMainPage(clearCLI: true);
  }

  void _updateParkingSpacesOperation() async {
    print('\nDu har valt att uppdatera en parkeringsplats\n');
    final parkingSpaceList = await parkingSpaceRepository.getAllParkingSpaces();
    if (parkingSpaceList.isEmpty) {
      getBackToMainPage(
          'Finns inga parkeringsplatser att uppdatera, testa att lägga till en parkeringsplats först');
      return;
    }

    stdout.write('Fyll i id för parkeringsplatsen du vill uppdatera: ');
    var parkingPlaceIdInput = stdin.readLineSync();

    if (parkingPlaceIdInput == null || parkingPlaceIdInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringsplatsen, vänligen fyll i ett id för parkeringsplatsen: ');
      parkingPlaceIdInput = stdin.readLineSync();
    }

    if (parkingPlaceIdInput == null || parkingPlaceIdInput.isEmpty) {
      setMainPage();
      return;
    }

    if (Validator.isValidSocialSecurityNumber(parkingPlaceIdInput)) {
      int transformedId = int.parse(parkingPlaceIdInput);
      final foundParkingSpaceIdIndex =
          parkingSpaceList.indexWhere((i) => i.id == transformedId);

      if (foundParkingSpaceIdIndex != -1) {
        // Hade inte behövt använda nedanstående här men för att påvisa att getParkingSpaceById fungerar så kör jag den här
        ParkingSpace? parkingSpaceById = await parkingSpaceRepository
            .getParkingSpaceById(transformedId.toString());
        if (parkingSpaceById == null) {
          getBackToMainPage('Parkeringsplats med angivet id hittades inte');
          return;
        }
        ParkingSpace? oldParkingSpace =
            parkingSpaceList[foundParkingSpaceIdIndex];

        print(
            'Vill du uppdatera parkeringsplatsens adress? Annars tryck Enter: ');
        var addressInput = stdin.readLineSync();
        String updatedAddress;
        if (addressInput == null || addressInput.isEmpty) {
          updatedAddress = oldParkingSpace.address;
          print('Du gjorde ingen ändring!');
        } else {
          updatedAddress = addressInput;
          print('Du har ändrat adressen till $updatedAddress!');
        }

        print(
            'Vill du uppdatera parkeringsplatsens pris per timme? Annars tryck Enter: ');
        var pphInput = stdin.readLineSync();
        int updatedPph;
        if (pphInput == null || pphInput.isEmpty) {
          updatedPph = oldParkingSpace.pricePerHour;
          print('Du gjorde ingen ändring!');
        } else {
          if (Validator.isNumber(pphInput)) {
            updatedPph = int.parse(pphInput);
            print('Du har ändrat pris per timme till $updatedPph!');
          } else {
            getBackToMainPage('Du måste ange ett pris med siffror');
            return;
          }
        }

        final res = await parkingSpaceRepository.updateParkingSpace(
            parkingSpaceById.id.toString(),
            ParkingSpace(
                id: parkingSpaceById.id,
                address: updatedAddress,
                pricePerHour: updatedPph));

        if (res.statusCode == 200) {
          print(
              'Parkeringsplats uppdaterad, välj att se alla i menyn för att se parkeringsplatser');
        } else {
          print('Något gick fel du omdirigeras till huvudmenyn');
        }
        setMainPage();
      } else {
        getBackToMainPage('Du angav ett id som inte finns');
        return;
      }
    } else {
      getBackToMainPage('Du angav ett felaktigt id');
      return;
    }
  }

  void _deleteParkingSpaceOperation() async {
    print('\nDu har valt att ta bort en parkeringsplats\n');
    final parkingSpaceList = await parkingSpaceRepository.getAllParkingSpaces();
    if (parkingSpaceList.isEmpty) {
      getBackToMainPage(
          'Finns inga parkeringsplatser att radera, testa att lägga till en parkeringsplats först');
      return;
    }

    stdout.write('Fyll i id för parkeringsplatsen: ');
    var parkingPlaceIdInput = stdin.readLineSync();

    if (parkingPlaceIdInput == null || parkingPlaceIdInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något id för parkeringsplatsen, vänligen fyll i ett id för parkeringsplatsen: ');
      parkingPlaceIdInput = stdin.readLineSync();
    }

    if (parkingPlaceIdInput == null || parkingPlaceIdInput.isEmpty) {
      setMainPage();
      return;
    }

    if (Validator.isValidSocialSecurityNumber(parkingPlaceIdInput)) {
      int transformedId = int.parse(parkingPlaceIdInput);
      final foundParkingSpaceIdIndex =
          parkingSpaceList.indexWhere((i) => i.id == transformedId);

      if (foundParkingSpaceIdIndex != -1) {
        final res = await parkingSpaceRepository.deleteParkingSpace(
            parkingSpaceList[foundParkingSpaceIdIndex].id.toString());

        if (res.statusCode == 200) {
          print(
              'Parkeringsplats raderad, välj att se alla i menyn för att se parkeringsplatser');
        } else {
          print('Något gick fel du omdirigeras till huvudmenyn');
        }
        setMainPage();
      } else {
        getBackToMainPage('Du angav ett id som inte finns');
        return;
      }
    } else {
      getBackToMainPage('Du angav ett felaktigt id');
      return;
    }
  }
}
*/

/*

class ParkingSpaceOperations extends SetMainPage {
  // ObjectBox Store och Box
  final Store _store = Store(getObjectBoxModel());
  late final Box<ParkingSpace> parkingSpaceBox;

  ParkingSpaceOperations() {
    // Initiera Box för ParkingSpace
    parkingSpaceBox = _store.box<ParkingSpace>();
  }

  // Menytext för parkeringsplatsoperationer
  List<String> texts = [
    'Du har valt att hantera Parkeringsplatser. Vad vill du göra?\n',
    '1. Skapa ny parkeringsplats\n',
    '2. Visa alla parkeringsplatser\n',
    '3. Uppdatera parkeringsplats\n',
    '4. Ta bort parkeringsplats\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  // Hantera användarens val för parkeringsplatsoperationer
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
        break;
      default:
        _showInvalidChoice();
    }
  }

  // Skapa en ny parkeringsplats
  void _addParkingSpaceOperation() {
    print('Ange adress för parkeringsplatsen:');
    String address = stdin.readLineSync() ?? '';

    print('Ange pris per timme för parkeringsplatsen:');
    int? pricePerHour = int.tryParse(stdin.readLineSync() ?? '');

    if (pricePerHour == null || pricePerHour <= 0) {
      print('Ogiltigt pris. Försök igen.');
      return;
    }

    // Skapa ett nytt ParkingSpace-objekt
    ParkingSpace newParkingSpace = ParkingSpace(
      address: address,
      pricePerHour: pricePerHour,
    );

    // Spara parkeringsplatsen i ObjectBox
    parkingSpaceBox.put(newParkingSpace);

    print(
        'Parkeringsplats med adress ${newParkingSpace.address} har skapats och sparats lokalt.');
  }

  // Visa alla parkeringsplatser
  void _showAllParkingSpacesOperation() {
    List<ParkingSpace> allParkingSpaces = parkingSpaceBox.getAll();

    if (allParkingSpaces.isEmpty) {
      print('Inga parkeringsplatser finns i systemet.');
    } else {
      print('Alla parkeringsplatser:');
      for (var parkingSpace in allParkingSpaces) {
        print(
            'ID: ${parkingSpace.id}, Adress: ${parkingSpace.address}, Pris per timme: ${parkingSpace.pricePerHour}');
      }
    }
  }

  // Uppdatera en parkeringsplats
  void _updateParkingSpaceOperation() {
    print('Ange ID för den parkeringsplats du vill uppdatera:');
    int? parkingSpaceId = int.tryParse(stdin.readLineSync() ?? '');

    if (parkingSpaceId == null || parkingSpaceId == 0) {
      print('Ogiltigt ID.');
      return;
    }

    // Hämta parkeringsplatsen baserat på ID
    ParkingSpace? existingParkingSpace = parkingSpaceBox.get(parkingSpaceId);

    if (existingParkingSpace == null) {
      print('Parkeringsplats med ID $parkingSpaceId finns inte.');
    } else {
      print('Ange ny adress (nuvarande: ${existingParkingSpace.address}):');
      String newAddress = stdin.readLineSync() ?? existingParkingSpace.address;

      print(
          'Ange nytt pris per timme (nuvarande: ${existingParkingSpace.pricePerHour}):');
      int? newPricePerHour = int.tryParse(stdin.readLineSync() ?? '');

      if (newPricePerHour == null || newPricePerHour <= 0) {
        print('Ogiltigt pris. Försök igen.');
        return;
      }

      // Uppdatera värden
      existingParkingSpace.address = newAddress;
      existingParkingSpace.pricePerHour = newPricePerHour;

      // Uppdatera parkeringsplatsen i ObjectBox
      parkingSpaceBox.put(existingParkingSpace);

      print(
          'Parkeringsplats med ID ${existingParkingSpace.id} har uppdaterats.');
    }
  }

  // Ta bort en parkeringsplats
  void _deleteParkingSpaceOperation() {
    print('Ange ID för den parkeringsplats du vill ta bort:');
    int? parkingSpaceId = int.tryParse(stdin.readLineSync() ?? '');

    if (parkingSpaceId == null || parkingSpaceId == 0) {
      print('Ogiltigt ID.');
      return;
    }

    // Hämta och ta bort parkeringsplatsen baserat på ID
    ParkingSpace? parkingSpaceToDelete = parkingSpaceBox.get(parkingSpaceId);

    if (parkingSpaceToDelete == null) {
      print('Parkeringsplats med ID $parkingSpaceId finns inte.');
    } else {
      // Ta bort från databasen
      parkingSpaceBox.remove(parkingSpaceId);
      print('Parkeringsplats med ID $parkingSpaceId har tagits bort.');
    }
  }

  // Hantera ogiltiga val
  void _showInvalidChoice() {
    print('Ogiltigt val, vänligen försök igen.');
  }
}
*/

import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:cli_client/repositories/VehicleRepository.dart';
import 'package:cli_client/repositories/PersonRepository.dart';
import 'package:cli_client/repositories/ParkingRepository.dart';
import 'package:cli_client/repositories/ParkingSpaceRepository.dart';
import 'package:cli_client/utils/validator.dart';
import 'package:cli_client/utils/calculate.dart';

// Importera ParkingSpace-klass (din Entity)

class ParkingSpaceOperations extends SetMainPage {
  // ObjectBox Store och Box
  final Store _store = Store(getObjectBoxModel());
  late final Box<ParkingSpace> parkingSpaceBox;

  ParkingSpaceOperations() {
    // Initiera Box för ParkingSpace
    parkingSpaceBox = _store.box<ParkingSpace>();
  }

  // Menytexter för hantering av parkeringsplatser
  List<String> texts = [
    'Du har valt att hantera Parkeringsplatser. Vad vill du göra?\n',
    '1. Skapa ny parkeringsplats\n',
    '2. Visa alla parkeringsplatser\n',
    '3. Uppdatera parkeringsplats\n',
    '4. Ta bort parkeringsplats\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  // Hantera användarens val för parkeringsplatsoperationer
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
        break;
      default:
        _showInvalidChoice();
    }
  }

  // Skapa en ny parkeringsplats
  void _addParkingSpaceOperation() {
    print('Ange adress för parkeringsplatsen:');
    String address = stdin.readLineSync() ?? '';

    print('Ange pris per timme:');
    int pricePerHour = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    // Skapa en ny ParkingSpace-instans
    ParkingSpace newParkingSpace = ParkingSpace(
      address: address,
      pricePerHour: pricePerHour,
    );

    // Spara parkeringsplatsen till ObjectBox
    parkingSpaceBox.put(newParkingSpace);

    print(
        'Parkeringsplats ${newParkingSpace.address} har skapats och sparats lokalt.');
  }

  // Visa alla parkeringsplatser
  void _showAllParkingSpacesOperation() {
    // Hämta alla parkeringsplatser från Box
    List<ParkingSpace> allParkingSpaces = parkingSpaceBox.getAll();

    if (allParkingSpaces.isEmpty) {
      print('Inga parkeringsplatser finns i systemet.');
    } else {
      print('Alla parkeringsplatser:');
      for (var space in allParkingSpaces) {
        print(
            'ID: ${space.id}, Adress: ${space.address}, Pris per timme: ${space.pricePerHour}');
      }
    }
  }

  // Uppdatera en befintlig parkeringsplats
  void _updateParkingSpaceOperation() {
    print('Ange ID för den parkeringsplats du vill uppdatera:');
    int? parkingSpaceId = int.tryParse(stdin.readLineSync() ?? '');

    if (parkingSpaceId == null || parkingSpaceId == 0) {
      print('Ogiltigt ID.');
      return;
    }

    // Hämta parkeringsplatsen baserat på ID
    ParkingSpace? existingParkingSpace = parkingSpaceBox.get(parkingSpaceId);

    if (existingParkingSpace == null) {
      print('Parkeringsplats med ID $parkingSpaceId finns inte.');
    } else {
      print('Ange ny adress (nuvarande: ${existingParkingSpace.address}):');
      String newAddress = stdin.readLineSync() ?? existingParkingSpace.address;

      print(
          'Ange nytt pris per timme (nuvarande: ${existingParkingSpace.pricePerHour}):');
      int newPricePerHour = int.tryParse(stdin.readLineSync() ?? '') ??
          existingParkingSpace.pricePerHour;

      // Skapa en ny instans med uppdaterade värden
      ParkingSpace updatedParkingSpace = ParkingSpace(
        id: existingParkingSpace.id,
        address: newAddress,
        pricePerHour: newPricePerHour,
      );

      // Spara den uppdaterade parkeringsplatsen till ObjectBox
      parkingSpaceBox.put(updatedParkingSpace);

      print(
          'Parkeringsplats med ID ${existingParkingSpace.id} har uppdaterats.');
    }
  }

  // Ta bort en parkeringsplats
  void _deleteParkingSpaceOperation() {
    print('Ange ID för den parkeringsplats du vill ta bort:');
    int? parkingSpaceId = int.tryParse(stdin.readLineSync() ?? '');

    if (parkingSpaceId == null || parkingSpaceId == 0) {
      print('Ogiltigt ID.');
      return;
    }

    // Hämta och ta bort parkeringsplatsen baserat på ID
    ParkingSpace? parkingSpaceToDelete = parkingSpaceBox.get(parkingSpaceId);

    if (parkingSpaceToDelete == null) {
      print('Parkeringsplats med ID $parkingSpaceId finns inte.');
    } else {
      // Ta bort från databasen
      parkingSpaceBox.remove(parkingSpaceId);
      print('Parkeringsplats med ID $parkingSpaceId har tagits bort.');
    }
  }

  // Hantera ogiltiga val
  void _showInvalidChoice() {
    print('Ogiltigt val, vänligen försök igen.');
  }
}
