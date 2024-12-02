//import 'package:objectbox/objectbox.dart';
//import '../models/Vehicle.dart';
//import 'package:cli_server/router_config.dart';

import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_server_stuff.dart';

class VehicleRepository {
  static final VehicleRepository instance = VehicleRepository._();
  VehicleRepository._();

  // Инициализируем Box<Vehicle> через конфигурацию сервера
  final Box<Vehicle> vehicleBox = ServerConfig.instance.store.box<Vehicle>();

  Future<Vehicle?> add(Vehicle vehicle) async {
    vehicleBox.put(vehicle, mode: PutMode.insert);

    // above command did not error
    return vehicle;
  }

  Future<Vehicle?> getById(int id) async {
    return vehicleBox.get(id);
  }

  Future<List<Vehicle>?> getAll() async {
    return vehicleBox.getAll();
  }

  Future<Vehicle> update(int id, Vehicle newVehicle) async {
    vehicleBox.put(newVehicle, mode: PutMode.update);
    return newVehicle;
  }

  Future<Vehicle?> delete(int id) async {
    Vehicle? vehicle = vehicleBox.get(id);

    if (vehicle != null) {
      vehicleBox.remove(id);
    }

    return vehicle;
  }
}
