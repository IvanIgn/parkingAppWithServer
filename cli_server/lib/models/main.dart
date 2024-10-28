import 'dart:io';
import '../repositories/PersonRepository.dart';
import '../repositories/VehicleRepository.dart';
import '../repositories/ParkingSpaceRepository.dart';
import '../repositories/ParkingRepository.dart';
import 'Person.dart';
import 'Vehicle.dart';
import 'ParkingSpace.dart';
//import 'objectbox.dart';

void main() async {
  PersonRepository personRepo = PersonRepository.instance;
  VehicleRepository vehicleRepo = VehicleRepository.instance;
  ParkingSpaceRepository parkingSpaceRepo = ParkingSpaceRepository.instance;
  ParkingRepository parkingRepo = ParkingRepository.instance;

  while (true) {
    print('----------------------------------');
    print('\n Välkommen till Parkeringsappen! \n');
    print('----------------------------------');
    print('Vad vill du hantera?');
    print('1. Personer');
    print('2. Fordon');
    print('3. Parkeringsplatser');
    print('4. Parkeringar');
    print('5. Avsluta');
    print('\n');

    stdout.write('Välj ett alternativ (1-5): ');
    print('\n');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        handlePersons(personRepo);
        break;
      case '2':
        handleVehicles(vehicleRepo, personRepo);
        break;
      case '3':
        handleParkingSpaces(parkingSpaceRepo);
        break;
      case '4':
        handleParkings(parkingRepo, vehicleRepo, parkingSpaceRepo);
        break;
      case '5':
        print('Avslutar programmet...');
        return;
      default:
        print('Ogiltigt alternativ, försök igen.');
    }
  }
}

void handlePersons(PersonRepository repo) {
  print('\nDu hanterar nu Personer. Vad vill du göra?');
  print('\n');
  print('1. Skapa ny person');
  print('2. Visa alla personer');
  print('3. Uppdatera person');
  print('4. Ta bort person');
  print('5. Gå tillbaka');
  print('\n');

  stdout.write('Välj ett alternativ (1-5): ');
  print('\n');
  final choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      stdout.write('Ange namn: ');
      final name = stdin.readLineSync()!;
      stdout.write('Ange personnummer: ');
      final personNumber = stdin.readLineSync()!;
      repo.addPerson(Person(name: name, personNumber: personNumber));
      print('\n');
      print('Personen har skapats.');
      print('\n');
      break;
    case '2':
      print('\n');
      print('Alla personer:');
      print('\n');
      repo.getAllPersons();
      break;
    case '3':
      print('\n');
      stdout.write('Ange personnummer för att uppdatera: ');
      final personNumber = stdin.readLineSync()!;
      final person = repo.getPersonByPersonNumber(personNumber);
      stdout.write('Ange nytt namn: ');
      person.name = stdin.readLineSync()!;
      repo.updatePerson(person);
      print('Personen har uppdaterats.');
      break;
    case '4':
      print('\n');
      stdout.write('Ange personnummer för att ta bort: ');
      print('\n');
      final personNumber = stdin.readLineSync()!;
      repo.deletePerson(personNumber);
      print('Personen har tagits bort.');
      break;
    case '5':
      return;
    default:
      print('Ogiltigt alternativ.');
  }
}

Future<void> handleVehicles(
    VehicleRepository vehicleRepo, PersonRepository personRepo) async {
  print('\n');
  print('\nDu hanterar nu Fordon. Vad vill du göra?');
  print('\n');
  print('1. Skapa nytt fordon');
  print('2. Visa alla fordon');
  print('3. Uppdatera fordon');
  print('4. Ta bort fordon');
  print('5. Gå tillbaka');
  print('\n');

  stdout.write('Välj ett alternativ (1-5): ');
  print('\n');
  final choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      stdout.write('Ange registreringsnummer: ');
      final registrationNumber = stdin.readLineSync()!;
      stdout.write('Ange typ (bil, motorcykel, etc.): ');
      final type = stdin.readLineSync()!;
      stdout.write('Ange ägarens personnummer: ');
      final personNumber = stdin.readLineSync()!;
      final owner = await personRepo.getPersonByPersonNumber(personNumber);
      if (owner != null) {
        vehicleRepo.addVehicle(Vehicle(
            registrationNumber: registrationNumber, type: type, owner: owner));
        print('Fordonet har skapats.');
      } else {
        print('Ägaren med personnummer $personNumber hittades inte.');
      }
      print('Fordonet har skapats.');
      break;
    case '2':
      print('Alla fordon:');
      vehicleRepo.getAllVehicles();
      break;
    case '3':
      stdout.write('Ange registreringsnummer för att uppdatera: ');
      final registrationNumber = stdin.readLineSync()!;
      final vehicle =
          vehicleRepo.getVehicleByRegistrationNumber(registrationNumber);
      stdout.write('Ange ny typ: ');
      vehicle.type = stdin.readLineSync()!;
      vehicleRepo.updateVehicle(registrationNumber, vehicle);
      print('Fordonet har uppdaterats.');
      break;
    case '4':
      stdout.write('Ange registreringsnummer för att ta bort: ');
      final registrationNumber = stdin.readLineSync()!;
      vehicleRepo.deleteVehicle(registrationNumber);
      print('Fordonet har tagits bort.');
      break;
    case '5':
      return;
    default:
      print('Ogiltigt alternativ.');
  }
}

void handleParkingSpaces(ParkingSpaceRepository repo) {
  print('\nDu hanterar nu Parkeringsplatser. Vad vill du göra?');
  print('1. Skapa ny parkeringsplats');
  print('2. Visa alla parkeringsplatser');
  print('3. Uppdatera parkeringsplats');
  print('4. Ta bort parkeringsplats');
  print('5. Gå tillbaka');
  print('\n');
  stdout.write('Välj ett alternativ (1-5): ');
  print('\n');
  final choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      stdout.write('Ange parkeringsplatsens ID: ');
      final id = stdin.readLineSync()!;
      stdout.write('Ange adress: ');
      final address = stdin.readLineSync()!;
      stdout.write('Ange pris per timme: ');
      final pricePerHour = double.parse(stdin.readLineSync()!);
      repo.addParkingSpace(
          ParkingSpace(id: id, address: address, pricePerHour: pricePerHour));
      print('Parkeringsplatsen har skapats.');
      break;
    case '2':
      print('Alla parkeringsplatser:');
      repo.getAllParkingSpaces().forEach(print);
      break;
    case '3':
      stdout.write('Ange ID för att uppdatera: ');
      final id = stdin.readLineSync()!;
      final space = repo.getParkingSpaceById(id);
      stdout.write('Ange ny adress: ');
      space.address = stdin.readLineSync()!;
      stdout.write('Ange nytt pris per timme: ');
      space.pricePerHour = double.parse(stdin.readLineSync()!);
      repo.updateParkingSpace(id, space);
      print('Parkeringsplatsen har uppdaterats.');
      break;
    case '4':
      stdout.write('Ange ID för att ta bort: ');
      final id = stdin.readLineSync()!;
      repo.deleteParkingSpace(id);
      print('Parkeringsplatsen har tagits bort.');
      break;
    case '5':
      return;
    default:
      print('Ogiltigt alternativ.');
  }
}

void handleParkings(ParkingRepository repo, VehicleRepository vehicleRepo,
    ParkingSpaceRepository spaceRepo) {
  print('\nDu hanterar nu Parkeringar. Vad vill du göra?');
  print('1. Skapa ny parkering');
  print('2. Visa alla parkeringar');
  print('3. Uppdatera parkering');
  print('4. Ta bort parkering');
  print('5. Gå tillbaka');
  print('\n');
  stdout.write('Välj ett alternativ (1-5): ');
  print('\n');
  final choice = stdin.readLineSync();

  switch (choice) {
    case '1':
      stdout.write('Ange fordonets registreringsnummer: ');
      final registrationNumber = stdin.readLineSync()!;
      final vehicle =
          vehicleRepo.getVehicleByRegistrationNumber(registrationNumber);
      stdout.write('Ange parkeringsplatsens ID: ');
      final spaceId = stdin.readLineSync()!;
      final parkingSpace = spaceRepo.getParkingSpaceById(spaceId);
      if (parkingSpace == null) {
        print('Parkeringsplatsen med ID $spaceId hittades inte.');
        break;
      }
      repo.addParking(spaceId, vehicle.registrationNumber, DateTime.now());
      print('Parkeringen har skapats.');
      break;
    case '2':
      print('Alla parkeringar:');
      repo.getAllParkings();
      break;
    case '3':
      stdout.write('Ange registreringsnummer för parkering att uppdatera: ');
      final registrationNumber = stdin.readLineSync()!;
      final parking = repo.getParkingByVehicleRegistration(registrationNumber);
      if (parking != null) {
        stdout.write('Ange ny sluttid (YYYY-MM-DD HH:MM): ');
        final newEndTime = DateTime.parse(stdin.readLineSync()!);
        parking.endTime = newEndTime;
        repo.updateParking(registrationNumber, parking);
        print('Parkeringen har uppdaterats');
      } else {
        print('Parkeringen hittades inte.');
      }
      break;
    case '4':
      stdout.write('Ange registreringsnummer för att ta bort: ');
      final registrationNumber = stdin.readLineSync()!;
      final parking = repo.getParkingById(registrationNumber);
      repo.deleteParking(registrationNumber);
      print('Parkeringen har tagits bort.');
      break;
    case '5':
      return;
    default:
      print('Ogiltigt alternativ.');
  }
}

// Lägg till en ny person
//   try {
//     await repo.addPerson(Person(name: 'John Doe', personNumber: '123456-7890'));
//   } catch (e) {
//     print(e);
//   }

//   // Hämta alla personer
//   try {
//     final persons = await repo.getAllPersons();
//     for (var person in persons) {
//       print('${person.name}, ${person.personNumber}');
//     }
//   } catch (e) {
//     print(e);
//   }

//   // Uppdatera en person
//   try {
//     await repo.updatePerson(Person(name: 'John Updated', personNumber: '123456-7890'));
//   } catch (e) {
//     print(e);
//   }

//   // Ta bort en person
//   try {
//     await repo.deletePerson('123456-7890');
//   } catch (e) {
//     print(e);
//   }
// }

void main() async {
  // Инициализация базы данных
  final objectBox = await ObjectBox.create();

  // Добавление новой записи
  final person = Person(name: 'John Doe', age: 30);
  objectBox.personBox.put(person);
  print('Person added: ${person.name}, id: ${person.id}');

  // Получение всех записей
  final persons = objectBox.personBox.getAll();
  print('All persons:');
  for (var person in persons) {
    print('${person.name}, age: ${person.age}');
  }
}
