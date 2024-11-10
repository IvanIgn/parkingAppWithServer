/*
class ParkingOperations extends SetMainPage {
  final ParkingRepository parkingRepository = ParkingRepository.instance;
  final ParkingSpaceRepository parkingSpaceRepository =
      ParkingSpaceRepository.instance;
  final VehicleRepository vehicleRepository = VehicleRepository.instance;

  List<String> texts = [
    'Du har valt att hantera Parkeringar. Vad vill du göra?\n',
    '1. Skapa ny parkering\n',
    '2. Visa alla parkeringar\n',
    '3. Uppdatera parkeringar\n',
    '4. Ta bort parkeringar\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void runLogic(int chosenOption) {
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
        print('Ogiltigt val');
        return;
    }
  }

  String _getCorrectDate(String endTime) {
    DateTime dateToday = DateTime.now();
    String date = dateToday.toString().substring(0, 10);
    return '$date $endTime';
  }

  void _addParkingOperation() async {
    print('\nDu har valt att skapa en ny parkering\n');
    final parkingList = await parkingRepository.getAllParkings();
    stdout.write('Fyll i registreringsnummer: ');
    var regNrInput = stdin.readLineSync();

    if (regNrInput == null || regNrInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något registreringsnummer, vänligen fyll i ett registreringsnummer: ');
      regNrInput = stdin.readLineSync();
    }

    if (regNrInput == null || regNrInput.isEmpty) {
      setMainPage();
      return;
    }

    final foundActiveParking = parkingList.indexWhere(
      (activeParking) => (activeParking.vehicle?.regNr.toUpperCase() ==
              regNrInput!.toUpperCase() &&
          activeParking.endTime.microsecondsSinceEpoch >
              DateTime.now().microsecondsSinceEpoch),
    );

    if (foundActiveParking != -1) {
      getBackToMainPage(
          'Det finns redan en aktiv parkering på angivet regnr testa att uppdatera den istället, du skickas tillbaka till huvudsidan');
      return;
    } else {
      final vehicleList = await vehicleRepository.getAllVehicles();
      final foundMatchingRegNr = vehicleList.indexWhere((vehicle) =>
          (vehicle.regNr.toUpperCase() == regNrInput!.toUpperCase()));

      if (foundMatchingRegNr != -1) {
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
          final parkingSpaceList =
              await parkingSpaceRepository.getAllParkingSpaces();
          final parkingSpaceIndexId =
              parkingSpaceList.indexWhere((i) => i.id == transformedId);

          if (parkingSpaceIndexId != -1) {
            stdout.write(
                'Fyll i sluttid för din parkering i korrekt format -> (hh:mm): ');
            var endTimeInput = stdin.readLineSync();

            if (endTimeInput == null || endTimeInput.isEmpty) {
              stdout.write(
                  'Du har inte fyllt i någon sluttid för din parkering, vänligen fyll i en sluttid för din parkering: ');
              endTimeInput = stdin.readLineSync();
            }

            if (endTimeInput == null || endTimeInput.isEmpty) {
              setMainPage();
              return;
            }

            final formattedEndTimeInput =
                DateTime.tryParse(_getCorrectDate(endTimeInput));

            if (formattedEndTimeInput == null) {
              print('Du angav ett felaktigt tidsformat');
              setMainPage();
              return;
            }

            final res = await parkingRepository.addParking(Parking(
              vehicle: vehicleList[foundMatchingRegNr],
              parkingSpace: ParkingSpace(
                  id: parkingSpaceList[parkingSpaceIndexId].id,
                  address: parkingSpaceList[parkingSpaceIndexId].address,
                  pricePerHour:
                      parkingSpaceList[parkingSpaceIndexId].pricePerHour),
              startTime: DateTime.now(),
              endTime: formattedEndTimeInput,
            ));

            if (res.statusCode == 200) {
              calculateDuration(
                  DateTime.now(),
                  formattedEndTimeInput,
                  parkingSpaceList[parkingSpaceIndexId]
                      .pricePerHour
                      .toDouble());
              print(
                  'Parkering startad, välj att se alla i menyn för att se parkeringar');
            } else {
              print('Något gick fel du omdirigeras till huvudmenyn');
            }
            setMainPage();
          } else {
            getBackToMainPage('Finns ingen parkeringsplats med angivet id');
            return;
          }
        } else {
          getBackToMainPage('Finns ingen parkeringsplats med angivet id');
          return;
        }
      } else {
        getBackToMainPage('Finns inget matchande registreringsnummer');
        return;
      }
    }
  }

  void _showAllParkingsOperation() async {
    var parkingList = await parkingRepository.getAllParkings();
    if (parkingList.isNotEmpty) {
      // finns det några aktiva i listan och tiden har gått ut så tas dessa bort
      final foundActiveParkingIndex = parkingList.indexWhere(
        (Parking activeParking) =>
            (activeParking.endTime.microsecondsSinceEpoch <
                DateTime.now().microsecondsSinceEpoch),
      );

      if (foundActiveParkingIndex != -1) {
        final foundActiveParking = parkingList[foundActiveParkingIndex];
        await parkingRepository.deleteParking(foundActiveParking.id.toString());
      }
      parkingList = await parkingRepository.getAllParkings();
      if (parkingList.isNotEmpty) {
        for (var park in parkingList) {
          print(
              'Id: ${park.id}\n Parkering: ${park.parkingSpace?.address}\n Time (start and end): ${park.startTime}-${park.endTime}\n RegNr: ${park.vehicle?.regNr}');
        }
      } else {
        print('Inga parkeringar att visa för tillfället.....');
        getBackToMainPage('');
        return;
      }
    } else {
      print('Inga parkeringar att visa för tillfället.....');
    }
    stdout.write('Tryck på något för att komma till huvudmenyn');
    stdin.readLineSync();
    setMainPage(clearCLI: true);
  }

  void _updateParkingOperation() async {
    print('\nDu har valt att uppdatera en parkering\n');
    final parkingList = await parkingRepository.getAllParkings();
    if (parkingList.isEmpty) {
      getBackToMainPage(
          'Finns inga parkeringar att uppdatera, testa att lägga till en parkering först');
      return;
    }

    stdout.write('Fyll i registreringsnummer: ');
    var regNrInput = stdin.readLineSync();

    if (regNrInput == null || regNrInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något registreringsnummer, vänligen fyll i ett registreringsnummer: ');
      regNrInput = stdin.readLineSync();
    }

    if (regNrInput == null || regNrInput.isEmpty) {
      setMainPage();
      return;
    }

    final foundParkingIndexId = parkingList
        .indexWhere((i) => (i.vehicle?.regNr == regNrInput!.toUpperCase()));

    if (foundParkingIndexId != -1) {
      print('Vill du uppdatera parkeringens sluttid? Annars tryck Enter: ');
      var endTimeInput = stdin.readLineSync();
      String endTime;
      if (endTimeInput == null || endTimeInput.isEmpty) {
        endTime = '';
        print('Du gjorde ingen ändring!');
      } else {
        endTime = endTimeInput;

        final formattedEndTimeInput =
            DateTime.tryParse(_getCorrectDate(endTime));

        if (formattedEndTimeInput == null) {
          print('Du angav ett felaktigt tidsformat');
          setMainPage();
          return;
        }

        Parking parkingById = (await parkingRepository
            .getParkingById(parkingList[foundParkingIndexId].id.toString()))!;

        final res = await parkingRepository.updateParking(
          parkingById.id.toString(),
          Parking(
            id: parkingById.id,
            vehicle: parkingById.vehicle,
            parkingSpace: parkingById.parkingSpace,
            startTime: parkingById.startTime,
            endTime: formattedEndTimeInput,
          ),
        );

        if (res.statusCode == 200) {
          calculateDuration(parkingById.startTime, formattedEndTimeInput,
              parkingById.parkingSpace!.pricePerHour.toDouble());
          print(
              'Parkering uppdaterad, välj att se alla i menyn för att se parkeringar');
        } else {
          print('Något gick fel du omdirigeras till huvudmenyn');
        }
      }
      setMainPage();
    } else {
      getBackToMainPage(
          'Finns ingen aktiv parkering med angivet registreringsnummer');
      return;
    }
  }

  void _deleteParkingOperation() async {
    print('\nDu har valt att ta bort en parkering\n');
    final parkingList = await parkingRepository.getAllParkings();
    if (parkingList.isEmpty) {
      getBackToMainPage(
          'Finns inga parkeringar att radera, testa att lägga till en parkering först');
      return;
    }

    stdout.write('Fyll i registreringsnummer: ');
    var regNrInput = stdin.readLineSync();

    if (regNrInput == null || regNrInput.isEmpty) {
      stdout.write(
          'Du har inte fyllt i något registreringsnummer, vänligen fyll i ett registreringsnummer: ');
      regNrInput = stdin.readLineSync();
    }

    if (regNrInput == null || regNrInput.isEmpty) {
      setMainPage();
      return;
    }

    final foundParkingIndexId = parkingList
        .indexWhere((i) => (i.vehicle?.regNr == regNrInput!.toUpperCase()));

    if (foundParkingIndexId != -1) {
      final parking = parkingList[foundParkingIndexId];
      final res = await parkingRepository.deleteParking(parking.id.toString());

      if (res.statusCode == 200) {
        print(
            'Parkering avslutad, välj att se alla i menyn för att se parkeringar');
      } else {
        print('Något gick fel du omdirigeras till huvudmenyn');
      }
      setMainPage();
    } else {
      getBackToMainPage('Finns ingen aktiv parkering med angivet id');
      return;
    }
  }
}
*/

import 'dart:io';
import 'package:cli_client/cli_operations/main.dart';
import 'package:cli_shared/cli_shared.dart';
import 'package:cli_client/utils/validator.dart';
import 'package:cli_client/utils/calculate.dart';

class ParkingOperations extends SetMainPage {
  // ObjectBox Store and Box for Parking
  final Store _store = Store(getObjectBoxModel());
  late final Box<Parking> parkingBox;
  late final Box<Vehicle> vehicleBox;
  late final Box<ParkingSpace> parkingSpaceBox;

  ParkingOperations() {
    // Initialize Boxes for Parking, Vehicle, and ParkingSpace
    parkingBox = _store.box<Parking>();
    vehicleBox = _store.box<Vehicle>();
    parkingSpaceBox = _store.box<ParkingSpace>();
  }

  // Menu texts for managing parking
  List<String> texts = [
    'Du har valt att hantera Parkeringar. Vad vill du göra?\n',
    '1. Skapa ny parkering\n',
    '2. Visa alla parkeringar\n',
    '3. Uppdatera parkering\n',
    '4. Ta bort parkering\n',
    '5. Gå tillbaka till huvudmenyn\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  // Handle user's choice for parking operations
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
        break;
      default:
        _showInvalidChoice();
    }
  }

  // Create a new parking record
  void _addParkingOperation() {
    // Get ParkingSpace details
    print('Ange parkeringens adress (ex. "P1"):');
    String address = stdin.readLineSync() ?? '';

    print('Ange parkeringens pris per timme (ex. 20):');
    int pricePerHour = int.tryParse(stdin.readLineSync() ?? '') ?? 0;

    // Create a ParkingSpace object
    ParkingSpace parkingSpace =
        ParkingSpace(address: address, pricePerHour: pricePerHour);
    parkingSpaceBox.put(parkingSpace); // Save the ParkingSpace

    // Get vehicle details
    print('Ange fordonets registreringsnummer (ex. "ABC123"):');
    String regNumber = stdin.readLineSync() ?? '';

    print('Ange fordonets typ (ex. "Bil", "Lastbil"):');
    String vehicleType = stdin.readLineSync() ?? '';

    // Ask for Vehicle owner details
    print('Ange fordonets ägares namn:');
    String ownerName = stdin.readLineSync() ?? '';

    // Create a Vehicle object
    Vehicle vehicle = Vehicle(
      regNr: regNumber,
      vehicleType: vehicleType,
      owner: Person(name: ownerName, personNumber: '1234567890'),
    );
    vehicleBox.put(vehicle); // Save the Vehicle

    // Get Parking start and end time
    print('Ange parkeringens starttid (ex. 2024-11-10 08:00):');
    String startTimeStr = stdin.readLineSync() ?? '';
    DateTime startTime;
    try {
      startTime = DateTime.parse(startTimeStr);
    } catch (e) {
      print('Ogiltig starttid.');
      return;
    }

    print('Ange parkeringens sluttid (ex. 2024-11-10 10:00):');
    String endTimeStr = stdin.readLineSync() ?? '';
    DateTime endTime;
    try {
      endTime = DateTime.parse(endTimeStr);
    } catch (e) {
      print('Ogiltig sluttid.');
      return;
    }

    // Create a Parking object
    Parking newParking = Parking(
      startTime: startTime,
      endTime: endTime,
      parkingSpace: parkingSpace as ParkingSpace?,
      vehicle: vehicle,
    );

    // Save the parking to ObjectBox
    parkingBox.put(newParking);

    print('Parkering har skapats och sparats.');
  }

  // Show all parking records
  void _showAllParkingsOperation() {
    // Fetch all parking records from Box
    List<Parking> allParkings = parkingBox.getAll();

    if (allParkings.isEmpty) {
      print('Inga parkeringar finns i systemet.');
    } else {
      print('Alla parkeringar:');
      for (var parking in allParkings) {
        String vehicleInfo =
            parking.vehicle != null ? parking.vehicle!.regNr : 'Inget fordon';
        String parkingSpaceInfo =
            parking.parkingSpace?.address ?? 'Okänd plats';
        print(
            'ID: ${parking.id}, Starttid: ${parking.startTime}, Sluttid: ${parking.endTime}, Plats: $parkingSpaceInfo, Fordon: $vehicleInfo');
      }
    }
  }

  // Update an existing parking record
  void _updateParkingOperation() {
    print('Ange ID för den parkering du vill uppdatera:');
    int? parkingId = int.tryParse(stdin.readLineSync() ?? '');

    if (parkingId == null || parkingId == 0) {
      print('Ogiltigt ID.');
      return;
    }

    // Fetch the parking record based on ID
    Parking? existingParking = parkingBox.get(parkingId);

    if (existingParking == null) {
      print('Parkering med ID $parkingId finns inte.');
    } else {
      print('Ange ny starttid (nuvarande: ${existingParking.startTime}):');
      String newStartTime =
          stdin.readLineSync() ?? existingParking.startTime.toString();

      print('Ange ny sluttid (nuvarande: ${existingParking.endTime}):');
      String newEndTime =
          stdin.readLineSync() ?? existingParking.endTime.toString();

      print(
          'Ange ny parkeringplats (nuvarande: ${existingParking.parkingSpace?.address}):');
      String newParkingSpace =
          stdin.readLineSync() ?? existingParking.parkingSpace!.address;

      // Update parking details
      existingParking.startTime = DateTime.parse(newStartTime);
      existingParking.endTime = DateTime.parse(newEndTime);
      var newSpace = ParkingSpace(
          address: newParkingSpace,
          pricePerHour: existingParking.parkingSpace!.pricePerHour);
      parkingSpaceBox.put(newSpace);
      existingParking.parkingSpace = newSpace;

      // Ask user to update vehicle (if applicable)
      print('Vill du uppdatera fordonet? (Ja/Nej)');
      String updateVehicleChoice = stdin.readLineSync()?.toLowerCase() ?? '';
      if (updateVehicleChoice == 'ja') {
        print('Ange registreringsnummer för fordonet:');
        String newVehicleReg = stdin.readLineSync() ?? '';
        existingParking.vehicle = Vehicle(
            regNr: newVehicleReg,
            vehicleType: existingParking.vehicle!.vehicleType,
            owner: existingParking.vehicle!.owner);
      }

      // Save the updated parking record to ObjectBox
      parkingBox.put(existingParking);

      print('Parkering med ID ${existingParking.id} har uppdaterats.');
    }
  }

  // Delete a parking record
  void _deleteParkingOperation() {
    print('Ange ID för den parkering du vill ta bort:');
    int? parkingId = int.tryParse(stdin.readLineSync() ?? '');

    if (parkingId == null || parkingId == 0) {
      print('Ogiltigt ID.');
      return;
    }

    // Fetch and delete the parking record based on ID
    Parking? parkingToDelete = parkingBox.get(parkingId);

    if (parkingToDelete == null) {
      print('Parkering med ID $parkingId finns inte.');
    } else {
      // Remove from the database
      parkingBox.remove(parkingId);
      print('Parkering med ID $parkingId har tagits bort.');
    }
  }

  // Handle invalid choices
  void _showInvalidChoice() {
    print('Ogiltigt val, vänligen försök igen.');
  }
}
