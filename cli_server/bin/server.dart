import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart' as shelf_router;

//importerade classer
import 'package:cli_server/models/Person.dart';
import 'package:cli_server/models/Vehicle.dart';
import 'package:cli_server/models/Parking.dart';
import 'package:cli_server/models/ParkingSpace.dart';

//importerade repositories
import 'package:cli_server/repositories/PersonRepository.dart';
import 'package:cli_server/repositories/VehicleRepository.dart';
import 'package:cli_server/repositories/ParkingRepository.dart';
import 'package:cli_server/repositories/ParkingSpaceRepository.dart';

final ip = InternetAddress.anyIPv4;
final port = 8080;

const _jsonHeaders = {
  'Content-Type': 'application/json',
};

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

// Instanser av repositories
final personRepo = PersonRepository.instance;
final vehicleRepo = VehicleRepository.instance;
final parkingRepo = ParkingRepository.instance;
final parkingSpaceRepo = ParkingSpaceRepository.instance;

// Skapa en router
// final router = shelf_router.Router();

final _router = shelf_router.Router()
  ..get('/persons', _getAllPersons)
  ..get('/persons/<id>', _getPersonById)
  ..post('/persons', _createPerson)
  ..put('/persons', _updatePerson)
  ..delete('/persons', _deletePerson)
  ..get('/vehicles', _getAllVehicles)
  ..get('/vehicles/<id>', _getVehicleById)
  ..post('/vehicles', _createVehicle)
  ..put('/vehicles', _updateVehicle)
  ..delete('/vehicles', _deleteVehicle)
  ..get('/parkingSpaces', _getAllParkingSpaces)
  ..get('/parkingSpaces/<id>', _getParkingSpaceById)
  ..post('/parkingSpaces', _createParkingSpace)
  ..put('/parkingSpaces', _updateParkingSpace)
  ..delete('/parkingSpaces', _deleteParkingSpace)
  ..get('/parkings', _getAllParkings)
  ..get('/parkings/<id>', _getParkingById)
  ..post('/parkings', _createParking)
  ..put('/parkings', _updateParking)
  ..delete('/parkings', _deleteParking);

Future<Response> _getAllPersons(Request request) async {
  final persons = await personRepo.getAllPersons();
  return Response.ok(
    jsonEncode(persons.map((p) => p.toJson()).toList()),
    headers: _jsonHeaders,
  );
}

// POST /persons
Future<Response> _createPerson(Request request) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final person = Person.fromJson(data);
  await personRepo.addPerson(person); // await för asynkron operation
  return Response.ok('Person med ID ${person.personNumber} skapad.');
}

// GET /persons/<id>
Future<Response> _getPersonById(Request request, String id) async {
  final person = await personRepo.getPersonByPersonNumber(id);
  if (person != null) {
    return Response.ok(jsonEncode(person.toJson()), headers: _jsonHeaders);
  } else {
    return Response.notFound('Person med ID $id hittades inte.');
  }
}

// PUT /persons/<id>
Future<Response> _updatePerson(Request request, String id) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final updatedPerson = Person.fromJson(data);
  await personRepo.updatePerson(updatedPerson); // await för asynkron operation
  return Response.ok('Person med ID $id uppdaterad.');
}

// DELETE /persons/<id>
Future<Response> _deletePerson(Request request, String id) async {
  await personRepo.deletePerson(id); // await för asynkron operation
  return Response.ok('Person med ID $id har tagits bort.');
}

////////////////////////////////
// VEHICLE ROUTES
// GET /vehicles
Future<Response> _getAllVehicles(Request request) async {
  final vehicles = await vehicleRepo.getAllVehicles();
  return Response.ok(
    jsonEncode(vehicles.map((v) => v.toJson()).toList()),
    headers: _jsonHeaders,
  );
}

// POST /vehicles
Future<Response> _createVehicle(Request request) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final vehicle = Vehicle.fromJson(data);
  await vehicleRepo.addVehicle(vehicle); // await för asynkron operation
  return Response.ok(
      'Fordon med registreringsnummer ${vehicle.registrationNumber} skapad.');
}

// GET /vehicles/<id>
Future<Response> _getVehicleById(Request request, String id) async {
  final vehicle = await vehicleRepo.getVehicleByRegistrationNumber(id);
  if (vehicle != null) {
    return Response.ok(jsonEncode(vehicle.toJson()), headers: _jsonHeaders);
  } else {
    return Response.notFound('Fordon med ID $id hittades inte.');
  }
}

// PUT /vehicles/<id>
Future<Response> _updateVehicle(Request request, String id) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final updatedVehicle = Vehicle.fromJson(data);
  await vehicleRepo.updateVehicle(
      id, updatedVehicle); // await för asynkron operation
  return Response.ok('Fordon med ID $id uppdaterad.');
}

// DELETE /vehicles/<id>
Future<Response> _deleteVehicle(Request request, String id) async {
  await vehicleRepo.deleteVehicle(id); // await för asynkron operation
  return Response.ok('Fordon med ID $id har tagits bort.');
}

////////////////////////////////
// PARKING ROUTES
// GET /parkings
Future<Response> _getAllParkings(Request request) async {
  final parkings = await parkingRepo.getAllParkings();
  return Response.ok(
    jsonEncode(parkings.map((p) => p.toJson()).toList()),
    headers: _jsonHeaders,
  );
}

// POST /parkings
Future<Response> _createParking(Request request) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final parking = Parking.fromJson(data);
  await parkingRepo.addParking(parking); // await för asynkron operation
  return Response.ok('Parkering med ID ${parking.id} skapad.');
}

// GET /parkingspaces/<id>
Future<Response> _getParkingById(Request request, String id) async {
  final parking = await parkingRepo.getParkingById(id);
  if (parking != null) {
    return Response.ok(jsonEncode(parking.toJson()), headers: _jsonHeaders);
  } else {
    return Response.notFound('Parkering med ID $id hittades inte.');
  }
}

// PUT /parkings/<id>
Future<Response> _updateParking(Request request, String id) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final updatedParking = Parking.fromJson(data);
  await parkingRepo.updateParking(id, updatedParking); // await added
  return Response.ok('Parkering med ID $id uppdaterad.');
}

// DELETE /parkings/<id>
Future<Response> _deleteParking(Request request, String id) async {
  await parkingRepo.deleteParking(id); // await added
  return Response.ok('Parkering med ID $id har tagits bort.');
}

//////////////////////////////////
// PARKING SPACE ROUTES
// GET /parkingspaces
Future<Response> _getAllParkingSpaces(Request request) async {
  final parkingSpaces = await parkingSpaceRepo.getAllParkingSpaces();
  return Response.ok(
    jsonEncode(parkingSpaces.map((p) => p.toJson()).toList()),
    headers: _jsonHeaders,
  );
}

// POST /parkingspaces
Future<Response> _createParkingSpace(Request request) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final parkingSpace = ParkingSpace.fromJson(data);
  await parkingSpaceRepo
      .addParkingSpace(parkingSpace); // await för asynkron operation
  return Response.ok('Parkeringsplats med ID ${parkingSpace.id} skapad.');
}

// GET /parkingspaces/<id>
Future<Response> _getParkingSpaceById(Request request, String id) async {
  final parkingSpace = await parkingSpaceRepo.getParkingSpaceById(id);
  if (parkingSpace != null) {
    return Response.ok(jsonEncode(parkingSpace.toJson()),
        headers: _jsonHeaders);
  } else {
    return Response.notFound('Parkeringsplats med ID $id hittades inte.');
  }
}

// PUT /parkingspaces/<id>
Future<Response> _updateParkingSpace(Request request, String id) async {
  final payload = await request.readAsString();
  final data = jsonDecode(payload);
  final updatedParkingSpace = ParkingSpace.fromJson(data);
  await parkingSpaceRepo.updateParkingSpace(
      id, updatedParkingSpace); // await för asynkron operation
  return Response.ok('Parkeringsplats med ID $id uppdaterad.');
}

// DELETE /parkingspaces/<id>
Future<Response> _deleteParkingSpace(Request request, String id) async {
  await parkingSpaceRepo.deleteParkingSpace(id); // await för asynkron operation
  return Response.ok('Parkeringsplats med ID $id har tagits bort.');
}

//////////////////////////////////
void main() async {
  // Kombinera router med middleware
  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  // Start the HTTP server after configuring the routes
  final server = await io.serve(handler, ip, port); // Servern startas här
  print('Servern körs på http://${server.address.host}:${server.port}');

  // Stäng
  await server.first;
}
