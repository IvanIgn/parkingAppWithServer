import 'package:cli_server/router_config.dart';
import 'package:cli_shared/cli_shared.dart';

class PersonRepository {
  // Инициализируем Box<Person> через конфигурацию сервера

  static final PersonRepository instance = PersonRepository._();
  PersonRepository._();

  final Box<Person> personBox = ServerConfig.instance.store.box<Person>();

  // Добавляет объект Person в базу данных
/*
  Future<Person> create(Person person) async {
    personBox.put(person,
        mode: PutMode.insert); // Вставляем запись, если не существует
    return person;
  }

  // Возвращает все объекты Person из базы данных

  Future<List<Person>> getAll() async {
    return personBox.getAll(); // Возвращает список всех записей
  }

  // Получает объект Person по персональному номеру

  Future<Person?> getByPersonNumber(String personNumber) async {
    return personBox
        .query(Person_.personNumber.equals(personNumber)
            as Condition<Person>?) // Создаем запрос
        .build()
        .findFirst(); // Возвращает первую запись, соответствующую условию, или null
  }

  // Обновляет существующий объект Person

  Future<Person> update(Person person) async {
    personBox.put(person, mode: PutMode.update); // Обновляем запись
    return person;
  }

  // Удаляет объект Person по персональному номеру и возвращает его, если он существовал

  Future<Person?> delete(String personNumber) async {
    final person = await getByPersonNumber(personNumber);
    if (person != null) {
      personBox.remove(person.id); // Удаляем запись, если она найдена
    }
    return person; // Возвращаем удаленную запись или null
  }
}
*/

  Future<Person> createPerson(Person person) async {
    personBox.put(person, mode: PutMode.insert);

    // above command did not error
    return person;
  }

  Future<Person?> getByPersonId(int id) async {
    return personBox.get(id);
  }

  Future<List<Person>> getAllPersons() async {
    return personBox.getAll();
  }

  Future<Person> updatePerson(int id, Person newPerson) async {
    personBox.put(newPerson, mode: PutMode.update);
    return newPerson;
  }

  Future<Person?> deletePerson(int id) async {
    Person? item = personBox.get(id);

    if (item != null) {
      personBox.remove(id);
    }

    return item;
  }
}
