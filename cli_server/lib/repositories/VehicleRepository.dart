//import 'package:objectbox/objectbox.dart';
//import '../models/Vehicle.dart';
//import 'package:cli_server/router_config.dart';

import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';

class VehicleRepository {
  static final VehicleRepository instance = VehicleRepository._();
  VehicleRepository._();

  // Инициализируем Box<Vehicle> через конфигурацию сервера
  final Box<Vehicle> vehicleBox = ServerConfig.instance.store.box<Vehicle>();

  // Создает новый объект Vehicle в базе данных
/*
  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    vehicleBox.put(vehicle,
        mode: PutMode.insert); // Вставляем запись, если не существует
    return vehicle;
  }

  // Получает все объекты Vehicle

  Future<List<Vehicle>> getAllVehicles() async {
    return vehicleBox.getAll(); // Возвращает список всех записей
  }

  // Получает объект Vehicle по регистрационному номеру

  Future<Vehicle?> getByRegistrationNumber(String registrationNumber) async {
    return vehicleBox
        .query(Vehicle_.registrationNumber
            .equals(registrationNumber)) // Создаем запрос
        .build()
        .findFirst(); // Возвращает первую запись, соответствующую условию, или null
  }

  // Обновляет объект Vehicle по регистрационному номеру

  Future<Vehicle> updateVehicle(
      String registrationNumber, Vehicle newVehicle) async {
    final existingVehicle = await getByRegistrationNumber(registrationNumber);
    if (existingVehicle != null) {
      newVehicle.id = existingVehicle.id; // Присваиваем ID существующей записи
      vehicleBox.put(newVehicle, mode: PutMode.update); // Обновляем запись
    }
    return newVehicle;
  }

  // Удаляет объект Vehicle по регистрационному номеру и возвращает его, если он существовал

  Future<Vehicle?> deleteVehicle(String registrationNumber) async {
    final vehicle = await getByRegistrationNumber(registrationNumber);
    if (vehicle != null) {
      vehicleBox.remove(vehicle.id); // Удаляем запись, если она найдена
    }
    return vehicle; // Возвращаем удаленную запись или null
  }
}
*/

  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    vehicleBox.put(vehicle, mode: PutMode.insert);

    // above command did not error
    return vehicle;
  }

  Future<Vehicle?> getByVehicleById(int id) async {
    return vehicleBox.get(id);
  }

  Future<List<Vehicle>> getAllVehicles() async {
    return vehicleBox.getAll();
  }

  Future<Vehicle> updateVehicle(int id, Vehicle newVehicle) async {
    vehicleBox.put(newVehicle, mode: PutMode.update);
    return newVehicle;
  }

  Future<Vehicle?> deleteVehicle(int id) async {
    Vehicle? item = vehicleBox.get(id);

    if (item != null) {
      vehicleBox.remove(id);
    }

    return item;
  }
}
