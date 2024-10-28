import 'package:objectbox/objectbox.dart';
//import 'cli_server/bin/models.dart'; // импортируй модели

class ObjectBox {
  late final Store store;

  late final Box<Person> personBox; // Box для работы с сущностью Person

  ObjectBox._create(this.store) {
    personBox = Box<Person>(store);
  }

  static Future<ObjectBox> create() async {
    // Инициализация базы данных
    final store = await openStore();
    return ObjectBox._create(store);
  }
}
