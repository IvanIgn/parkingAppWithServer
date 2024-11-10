//import '../models/Parking.dart' as server_parking;
//import 'package:objectbox/objectbox.dart';
//import 'package:cli_server/router_config.dart';

import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';
//import 'package:cli_shared/cli_shared.dart' as shared;

class ParkingRepository {
  // Получаем Box<Parking> через конфигурацию сервера
  //static final Parking _instance =
  //   Parking._internal();
  // static Parking get instance => _instance;
  // Parking._internal();

  static final ParkingRepository instance = ParkingRepository._();

  ParkingRepository._();

  Box<Parking> parkingBox = ServerConfig.instance.store.box<Parking>();

  // Создает новый объект Parking в базе данных
/*
  Future<Parking> addParking(Parking parking) async {
    parkingBox.put(parking,
        mode: PutMode.insert); // Вставляем запись, если не существует
    return parking;
  }

  // Получает объект Parking по ID

  Future<Parking?> getParkingById(int id) async {
    return parkingBox
        .get(id); // Возвращает Parking с указанным ID или null, если не найден
  }

  // Получает все объекты Parking

  Future<List<Parking>> getAllParkings() async {
    return parkingBox.getAll(); // Возвращает список всех записей
  }

  // Обновляет существующий объект Parking по ID

  Future<Parking> updateParking(int id, Parking newParking) async {
    newParking.id = id; // Устанавливаем ID, чтобы сохранить существующую запись
    parkingBox.put(newParking, mode: PutMode.update); // Обновляем запись
    return newParking;
  }

  // Удаляет объект Parking по ID и возвращает его, если он существовал

  Future<Parking?> deleteParking(int id) async {
    Parking? parking = parkingBox.get(id);

    if (parking != null) {
      parkingBox.remove(id); // Удаляем запись, если она найдена
    }

    return parking; // Возвращаем удаленную запись или null
  }
}

*/

  Future<Parking> addParking(Parking parking) async {
    parkingBox.put(parking, mode: PutMode.insert);

    // above command did not error
    return parking;
  }

  Future<Parking?> getByParkingId(int id) async {
    return parkingBox.get(id);
  }

  Future<List<Parking>> getAllParkings() async {
    return parkingBox.getAll();
  }

  Future<Parking> updateParking(int id, Parking newParking) async {
    parkingBox.put(newParking, mode: PutMode.update);
    return newParking;
  }

  Future<Parking?> deleteParking(int id) async {
    Parking? item = parkingBox.get(id);

    if (item != null) {
      parkingBox.remove(id);
    }

    return item;
  }
}
