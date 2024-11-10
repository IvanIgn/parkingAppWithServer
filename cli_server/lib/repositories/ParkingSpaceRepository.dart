import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';

class ParkingSpaceRepository {
  // final String baseUrl = 'http://localhost:8080'; // Serverns URL

  // Singleton-instans av ParkingSpaceRepository

  static final ParkingSpaceRepository instance = ParkingSpaceRepository._();

  ParkingSpaceRepository._();

  final Box<ParkingSpace> parkingSpaceBox =
      ServerConfig.instance.store.box<ParkingSpace>();

/*
  // Lägga till en ny parkeringsplats via HTTP POST-begäran
  Future<void> addParkingSpace(ParkingSpace parkingSpace) async {
    try {
      final url = Uri.parse('$baseUrl/parkingSpaces');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(parkingSpace.toJson()),
      );

      if (response.statusCode == 201) {
        print('Parkeringsplats med ID ${parkingSpace.id} tillagd.');
      } else if (response.statusCode == 400) {
        print('Ogiltig förfrågan: ${response.body}');
      } else {
        print('Fel vid tillägg av parkeringsplats: ${response.body}');
      }
    } catch (e) {
      print('Fel vid tillägg av parkeringsplats: $e');
    }
  }

  // Hämta alla parkeringsplatser från servern
  Future<List<ParkingSpace>> getAllParkingSpaces() async {
    try {
      final url = Uri.parse('$baseUrl/parkingSpaces');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => ParkingSpace.fromJson(json)).toList();
      } else {
        print('Fel vid hämtning av parkeringsplatser: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Fel vid hämtning av parkeringsplatser: $e');
      return [];
    }
  }

  // Hämta en specifik parkeringsplats via ID
  Future<ParkingSpace?> getParkingSpaceById(String id) async {
    try {
      final url = Uri.parse('$baseUrl/parkingSpaces/$id');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return ParkingSpace.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        print('Parkeringsplats ej funnen: $id');
        return null;
      } else {
        print('Fel vid hämtning av parkeringsplats: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Fel vid hämtning av parkeringsplats: $e');
      return null;
    }
  }

  // Uppdatera en parkeringsplats via HTTP PUT-begäran
  Future<void> updateParkingSpace(
      String id, ParkingSpace updatedParkingSpace) async {
    try {
      final url = Uri.parse('$baseUrl/parkingSpaces/$id');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedParkingSpace.toJson()),
      );

      if (response.statusCode == 200) {
        print('Parkeringsplats med ID $id uppdaterad.');
      } else if (response.statusCode == 404) {
        print('Parkeringsplats ej funnen: $id');
      } else {
        print('Fel vid uppdatering av parkeringsplats: ${response.body}');
      }
    } catch (e) {
      print('Fel vid uppdatering av parkeringsplats: $e');
    }
  }

  // Ta bort en parkeringsplats via HTTP DELETE-begäran
  Future<void> deleteParkingSpace(String id) async {
    try {
      final url = Uri.parse('$baseUrl/parkingSpaces/$id');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Parkeringsplats med ID $id har tagits bort.');
      } else if (response.statusCode == 404) {
        print('Parkeringsplats ej funnen: $id');
      } else {
        print('Fel vid borttagning av parkeringsplats: ${response.body}');
      }
    } catch (e) {
      print('Fel vid borttagning av parkeringsplats: $e');
    }
  }
}

*/
//////////////////////////////////////////////Future<Person> create(Person person) async {
  Future<ParkingSpace> createParkingSpace(ParkingSpace parkingSpace) async {
    parkingSpaceBox.put(parkingSpace, mode: PutMode.insert);

    // above command did not error
    return parkingSpace;
  }

  Future<ParkingSpace?> getByParkingSpaceById(int id) async {
    return parkingSpaceBox.get(id);
  }

  Future<List<ParkingSpace>> getAllParkingSpaces() async {
    return parkingSpaceBox.getAll();
  }

  Future<ParkingSpace> updateParkingSpace(
      int id, ParkingSpace newParkingSpace) async {
    parkingSpaceBox.put(newParkingSpace, mode: PutMode.update);
    return newParkingSpace;
  }

  Future<ParkingSpace?> deleteParkingSpace(int id) async {
    ParkingSpace? item = parkingSpaceBox.get(id);

    if (item != null) {
      parkingSpaceBox.remove(id);
    }

    return item;
  }
}
