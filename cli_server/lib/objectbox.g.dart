// GENERATED CODE - DO NOT MODIFY BY HAND
// This code was generated by ObjectBox. To update it run the generator again
// with `dart run build_runner build`.
// See also https://docs.objectbox.io/getting-started#generate-objectbox-code

// ignore_for_file: camel_case_types, depend_on_referenced_packages
// coverage:ignore-file

import 'dart:typed_data';

import 'package:flat_buffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'
    as obx_int; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart' as obx;

import 'models/Parking.dart';
import 'models/ParkingSpace.dart';
import 'models/Person.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <obx_int.ModelEntity>[
  obx_int.ModelEntity(
      id: const obx_int.IdUid(1, 2901661101577721036),
      name: 'Parking',
      lastPropertyId: const obx_int.IdUid(5, 5608798301651552547),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 8641516416030137104),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3337318876874822512),
            name: 'vehicleId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(1, 5064053773773796579),
            relationTarget: 'Vehicle'),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7051891498731239499),
            name: 'parkingSpaceId',
            type: 11,
            flags: 520,
            indexId: const obx_int.IdUid(2, 3210728811895650838),
            relationTarget: 'ParkingSpace'),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(4, 2998436982810254675),
            name: 'startTime',
            type: 10,
            flags: 0),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(5, 5608798301651552547),
            name: 'endTime',
            type: 10,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(2, 1161205363529624153),
      name: 'ParkingSpace',
      lastPropertyId: const obx_int.IdUid(3, 6915302794006349390),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 5306954156578879582),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3733505355541841149),
            name: 'address',
            type: 9,
            flags: 2048,
            indexId: const obx_int.IdUid(3, 5564003874537992562)),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 6915302794006349390),
            name: 'pricePerHour',
            type: 8,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[]),
  obx_int.ModelEntity(
      id: const obx_int.IdUid(3, 1519859493253967796),
      name: 'Person',
      lastPropertyId: const obx_int.IdUid(3, 7285563221192134133),
      flags: 0,
      properties: <obx_int.ModelProperty>[
        obx_int.ModelProperty(
            id: const obx_int.IdUid(1, 7494013658001642964),
            name: 'id',
            type: 6,
            flags: 1),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(2, 3254844371935294095),
            name: 'name',
            type: 9,
            flags: 2048,
            indexId: const obx_int.IdUid(4, 4798284582577413301)),
        obx_int.ModelProperty(
            id: const obx_int.IdUid(3, 7285563221192134133),
            name: 'personNumber',
            type: 9,
            flags: 0)
      ],
      relations: <obx_int.ModelRelation>[],
      backlinks: <obx_int.ModelBacklink>[])
];

/// Shortcut for [obx.Store.new] that passes [getObjectBoxModel] and for Flutter
/// apps by default a [directory] using `defaultStoreDirectory()` from the
/// ObjectBox Flutter library.
///
/// Note: for desktop apps it is recommended to specify a unique [directory].
///
/// See [obx.Store.new] for an explanation of all parameters.
///
/// For Flutter apps, also calls `loadObjectBoxLibraryAndroidCompat()` from
/// the ObjectBox Flutter library to fix loading the native ObjectBox library
/// on Android 6 and older.
obx.Store openStore(
    {String? directory,
    int? maxDBSizeInKB,
    int? maxDataSizeInKB,
    int? fileMode,
    int? maxReaders,
    bool queriesCaseSensitiveDefault = true,
    String? macosApplicationGroup}) {
  return obx.Store(getObjectBoxModel(),
      directory: directory,
      maxDBSizeInKB: maxDBSizeInKB,
      maxDataSizeInKB: maxDataSizeInKB,
      fileMode: fileMode,
      maxReaders: maxReaders,
      queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
      macosApplicationGroup: macosApplicationGroup);
}

/// Returns the ObjectBox model definition for this project for use with
/// [obx.Store.new].
obx_int.ModelDefinition getObjectBoxModel() {
  final model = obx_int.ModelInfo(
      entities: _entities,
      lastEntityId: const obx_int.IdUid(3, 1519859493253967796),
      lastIndexId: const obx_int.IdUid(4, 4798284582577413301),
      lastRelationId: const obx_int.IdUid(0, 0),
      lastSequenceId: const obx_int.IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, obx_int.EntityDefinition>{
    Parking: obx_int.EntityDefinition<Parking>(
        model: _entities[0],
        toOneRelations: (Parking object) =>
            [object.vehicle, object.parkingSpace],
        toManyRelations: (Parking object) => {},
        getId: (Parking object) => object.id,
        setId: (Parking object, int id) {
          object.id = id;
        },
        objectToFB: (Parking object, fb.Builder fbb) {
          fbb.startTable(6);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.vehicle.targetId);
          fbb.addInt64(2, object.parkingSpace.targetId);
          fbb.addInt64(3, object.startTime.millisecondsSinceEpoch);
          fbb.addInt64(4, object.endTime.millisecondsSinceEpoch);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final startTimeParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0));
          final endTimeParam = DateTime.fromMillisecondsSinceEpoch(
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 12, 0));
          final object = Parking(
              id: idParam, startTime: startTimeParam, endTime: endTimeParam);
          object.vehicle.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0);
          object.vehicle.attach(store);
          object.parkingSpace.targetId =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0);
          object.parkingSpace.attach(store);
          return object;
        }),
    ParkingSpace: obx_int.EntityDefinition<ParkingSpace>(
        model: _entities[1],
        toOneRelations: (ParkingSpace object) => [],
        toManyRelations: (ParkingSpace object) => {},
        getId: (ParkingSpace object) => object.id,
        setId: (ParkingSpace object, int id) {
          object.id = id;
        },
        objectToFB: (ParkingSpace object, fb.Builder fbb) {
          final addressOffset = fbb.writeString(object.address);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, addressOffset);
          fbb.addFloat64(2, object.pricePerHour);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final addressParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final pricePerHourParam =
              const fb.Float64Reader().vTableGet(buffer, rootOffset, 8, 0);
          final object = ParkingSpace(
              id: idParam,
              address: addressParam,
              pricePerHour: pricePerHourParam);

          return object;
        }),
    Person: obx_int.EntityDefinition<Person>(
        model: _entities[2],
        toOneRelations: (Person object) => [],
        toManyRelations: (Person object) => {},
        getId: (Person object) => object.id,
        setId: (Person object, int id) {
          object.id = id;
        },
        objectToFB: (Person object, fb.Builder fbb) {
          final nameOffset = fbb.writeString(object.name);
          final personNumberOffset = fbb.writeString(object.personNumber);
          fbb.startTable(4);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, nameOffset);
          fbb.addOffset(2, personNumberOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (obx.Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);
          final idParam =
              const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0);
          final nameParam = const fb.StringReader(asciiOptimization: true)
              .vTableGet(buffer, rootOffset, 6, '');
          final personNumberParam =
              const fb.StringReader(asciiOptimization: true)
                  .vTableGet(buffer, rootOffset, 8, '');
          final object = Person(
              id: idParam, name: nameParam, personNumber: personNumberParam);

          return object;
        })
  };

  return obx_int.ModelDefinition(model, bindings);
}

/// [Parking] entity fields to define ObjectBox queries.
class Parking_ {
  /// See [Parking.id].
  static final id =
      obx.QueryIntegerProperty<Parking>(_entities[0].properties[0]);

  /// See [Parking.vehicle].
  static final vehicle =
      obx.QueryRelationToOne<Parking, Vehicle>(_entities[0].properties[1]);

  /// See [Parking.parkingSpace].
  static final parkingSpace =
      obx.QueryRelationToOne<Parking, ParkingSpace>(_entities[0].properties[2]);

  /// See [Parking.startTime].
  static final startTime =
      obx.QueryDateProperty<Parking>(_entities[0].properties[3]);

  /// See [Parking.endTime].
  static final endTime =
      obx.QueryDateProperty<Parking>(_entities[0].properties[4]);
}

/// [ParkingSpace] entity fields to define ObjectBox queries.
class ParkingSpace_ {
  /// See [ParkingSpace.id].
  static final id =
      obx.QueryIntegerProperty<ParkingSpace>(_entities[1].properties[0]);

  /// See [ParkingSpace.address].
  static final address =
      obx.QueryStringProperty<ParkingSpace>(_entities[1].properties[1]);

  /// See [ParkingSpace.pricePerHour].
  static final pricePerHour =
      obx.QueryDoubleProperty<ParkingSpace>(_entities[1].properties[2]);
}

/// [Person] entity fields to define ObjectBox queries.
class Person_ {
  /// See [Person.id].
  static final id =
      obx.QueryIntegerProperty<Person>(_entities[2].properties[0]);

  /// See [Person.name].
  static final name =
      obx.QueryStringProperty<Person>(_entities[2].properties[1]);

  /// See [Person.personNumber].
  static final personNumber =
      obx.QueryStringProperty<Person>(_entities[2].properties[2]);
}
