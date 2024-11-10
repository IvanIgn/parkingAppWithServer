import 'dart:io';

import 'package:cli_client/cli_operations/vehicles_operations.dart';
import 'package:cli_client/utils/console.dart';
import 'persons_operations.dart';
import 'parkingSpaces_operations.dart';
import 'parkings_operations.dart';

class SetMainPage {
  List<String> firstPageTexts = [
    'Välkommen till parkeringsappen!\n',
    'Vad vill du hantera?\n',
    '1. Personer\n',
    '2. Fordon\n',
    '3. Parkeringsplatser\n',
    '4. Parkeringar\n',
    '5. Avsluta\n\n',
    'Välj ett alternativ (1-5): ',
  ];

  void setMainPage({bool clearCLI = false}) {
    if (clearCLI) {
      clearConsole();
    }
    int pickedMenuOption;
    stdout.writeAll(firstPageTexts);
    final input = stdin.readLineSync();

    if (input == null || input.isEmpty) {
      print('Du har inte valt något giltigt alternativ');
      return;
    } else {
      int option = int.parse(input);

      switch (option) {
        case 1:
          clearConsole();
          print(PersonOperations().texts);
          final personInput = stdin.readLineSync();
          if (personInput == null || personInput.isEmpty) {
            print('Du har inte valt något giltigt alternativ');
            return;
          }
          pickedMenuOption = int.parse(personInput);

          final PersonOperations personLogic = PersonOperations();
          personLogic.runOperation(pickedMenuOption);
          break;
        case 2:
          clearConsole();
          stdout.writeAll(VehicleOperations().texts);
          final vehicleInput = stdin.readLineSync();

          if (vehicleInput == null || vehicleInput.isEmpty) {
            print('Du har inte valt något giltigt alternativ');
            return;
          }
          pickedMenuOption = int.parse(vehicleInput);

          final VehicleOperations vehicleLogic = VehicleOperations();
          vehicleLogic.runOperation(pickedMenuOption);
          break;
        case 3:
          clearConsole();
          stdout.writeAll(ParkingSpaceOperations().texts);
          final parkingSpaceInput = stdin.readLineSync();

          if (parkingSpaceInput == null || parkingSpaceInput.isEmpty) {
            print('Du har inte valt något giltigt alternativ');
            return;
          }
          pickedMenuOption = int.parse(parkingSpaceInput);

          final ParkingSpaceOperations vehicleLogic = ParkingSpaceOperations();
          vehicleLogic.runOperation(pickedMenuOption);
          break;
        case 4:
          clearConsole();
          stdout.writeAll(ParkingOperations().texts);
          final parkingInput = stdin.readLineSync();

          if (parkingInput == null || parkingInput.isEmpty) {
            print('Du har inte valt något giltigt alternativ');
            return;
          }
          pickedMenuOption = int.parse(parkingInput);

          final ParkingOperations vehicleLogic = ParkingOperations();
          vehicleLogic.runOperation(pickedMenuOption);
          break;
        case 5:
          stdout.write('Du valde att avsluta\n');
          return;
        default:
          print('Ogiltigt val');
          return;
      }
      print('\n---------------------------------\n');
    }
  }

  getBackToMainPage(String printText) {
    print(printText);
    setMainPage();
    return;
  }
}
