// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ItemGroupsTable extends ItemGroups
    with TableInfo<$ItemGroupsTable, ItemGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_groups';
  @override
  VerificationContext validateIntegrity(Insertable<ItemGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $ItemGroupsTable createAlias(String alias) {
    return $ItemGroupsTable(attachedDatabase, alias);
  }
}

class ItemGroup extends DataClass implements Insertable<ItemGroup> {
  final int id;
  final String name;
  const ItemGroup({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  ItemGroupsCompanion toCompanion(bool nullToAbsent) {
    return ItemGroupsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory ItemGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemGroup(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  ItemGroup copyWith({int? id, String? name}) => ItemGroup(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  ItemGroup copyWithCompanion(ItemGroupsCompanion data) {
    return ItemGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemGroup(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemGroup && other.id == this.id && other.name == this.name);
}

class ItemGroupsCompanion extends UpdateCompanion<ItemGroup> {
  final Value<int> id;
  final Value<String> name;
  const ItemGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  ItemGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<ItemGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  ItemGroupsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return ItemGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ItemTypesTable extends ItemTypes
    with TableInfo<$ItemTypesTable, ItemType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemGroupIdMeta =
      const VerificationMeta('itemGroupId');
  @override
  late final GeneratedColumn<int> itemGroupId = GeneratedColumn<int>(
      'item_group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES item_groups (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, itemGroupId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_types';
  @override
  VerificationContext validateIntegrity(Insertable<ItemType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_group_id')) {
      context.handle(
          _itemGroupIdMeta,
          itemGroupId.isAcceptableOrUnknown(
              data['item_group_id']!, _itemGroupIdMeta));
    } else if (isInserting) {
      context.missing(_itemGroupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {itemGroupId, name},
      ];
  @override
  ItemType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemGroupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_group_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $ItemTypesTable createAlias(String alias) {
    return $ItemTypesTable(attachedDatabase, alias);
  }
}

class ItemType extends DataClass implements Insertable<ItemType> {
  final int id;
  final int itemGroupId;
  final String name;
  const ItemType(
      {required this.id, required this.itemGroupId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_group_id'] = Variable<int>(itemGroupId);
    map['name'] = Variable<String>(name);
    return map;
  }

  ItemTypesCompanion toCompanion(bool nullToAbsent) {
    return ItemTypesCompanion(
      id: Value(id),
      itemGroupId: Value(itemGroupId),
      name: Value(name),
    );
  }

  factory ItemType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemType(
      id: serializer.fromJson<int>(json['id']),
      itemGroupId: serializer.fromJson<int>(json['itemGroupId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemGroupId': serializer.toJson<int>(itemGroupId),
      'name': serializer.toJson<String>(name),
    };
  }

  ItemType copyWith({int? id, int? itemGroupId, String? name}) => ItemType(
        id: id ?? this.id,
        itemGroupId: itemGroupId ?? this.itemGroupId,
        name: name ?? this.name,
      );
  ItemType copyWithCompanion(ItemTypesCompanion data) {
    return ItemType(
      id: data.id.present ? data.id.value : this.id,
      itemGroupId:
          data.itemGroupId.present ? data.itemGroupId.value : this.itemGroupId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemType(')
          ..write('id: $id, ')
          ..write('itemGroupId: $itemGroupId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemGroupId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemType &&
          other.id == this.id &&
          other.itemGroupId == this.itemGroupId &&
          other.name == this.name);
}

class ItemTypesCompanion extends UpdateCompanion<ItemType> {
  final Value<int> id;
  final Value<int> itemGroupId;
  final Value<String> name;
  const ItemTypesCompanion({
    this.id = const Value.absent(),
    this.itemGroupId = const Value.absent(),
    this.name = const Value.absent(),
  });
  ItemTypesCompanion.insert({
    this.id = const Value.absent(),
    required int itemGroupId,
    required String name,
  })  : itemGroupId = Value(itemGroupId),
        name = Value(name);
  static Insertable<ItemType> custom({
    Expression<int>? id,
    Expression<int>? itemGroupId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemGroupId != null) 'item_group_id': itemGroupId,
      if (name != null) 'name': name,
    });
  }

  ItemTypesCompanion copyWith(
      {Value<int>? id, Value<int>? itemGroupId, Value<String>? name}) {
    return ItemTypesCompanion(
      id: id ?? this.id,
      itemGroupId: itemGroupId ?? this.itemGroupId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemGroupId.present) {
      map['item_group_id'] = Variable<int>(itemGroupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemTypesCompanion(')
          ..write('id: $id, ')
          ..write('itemGroupId: $itemGroupId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $OrnamentsTable extends Ornaments
    with TableInfo<$OrnamentsTable, Ornament> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrnamentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ornamentCodeMeta =
      const VerificationMeta('ornamentCode');
  @override
  late final GeneratedColumn<String> ornamentCode = GeneratedColumn<String>(
      'ornament_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 40),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _itemGroupIdMeta =
      const VerificationMeta('itemGroupId');
  @override
  late final GeneratedColumn<int> itemGroupId = GeneratedColumn<int>(
      'item_group_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES item_groups (id)'));
  static const VerificationMeta _itemTypeIdMeta =
      const VerificationMeta('itemTypeId');
  @override
  late final GeneratedColumn<int> itemTypeId = GeneratedColumn<int>(
      'item_type_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES item_types (id)'));
  static const VerificationMeta _weightGramsMeta =
      const VerificationMeta('weightGrams');
  @override
  late final GeneratedColumn<double> weightGrams = GeneratedColumn<double>(
      'weight_grams', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _entryDateMeta =
      const VerificationMeta('entryDate');
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
      'entry_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<OrnamentStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('available'))
          .withConverter<OrnamentStatus>($OrnamentsTable.$converterstatus);
  static const VerificationMeta _statusDateMeta =
      const VerificationMeta('statusDate');
  @override
  late final GeneratedColumn<DateTime> statusDate = GeneratedColumn<DateTime>(
      'status_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        ornamentCode,
        itemGroupId,
        itemTypeId,
        weightGrams,
        entryDate,
        status,
        statusDate,
        customerName,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ornaments';
  @override
  VerificationContext validateIntegrity(Insertable<Ornament> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ornament_code')) {
      context.handle(
          _ornamentCodeMeta,
          ornamentCode.isAcceptableOrUnknown(
              data['ornament_code']!, _ornamentCodeMeta));
    } else if (isInserting) {
      context.missing(_ornamentCodeMeta);
    }
    if (data.containsKey('item_group_id')) {
      context.handle(
          _itemGroupIdMeta,
          itemGroupId.isAcceptableOrUnknown(
              data['item_group_id']!, _itemGroupIdMeta));
    } else if (isInserting) {
      context.missing(_itemGroupIdMeta);
    }
    if (data.containsKey('item_type_id')) {
      context.handle(
          _itemTypeIdMeta,
          itemTypeId.isAcceptableOrUnknown(
              data['item_type_id']!, _itemTypeIdMeta));
    } else if (isInserting) {
      context.missing(_itemTypeIdMeta);
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
          _weightGramsMeta,
          weightGrams.isAcceptableOrUnknown(
              data['weight_grams']!, _weightGramsMeta));
    } else if (isInserting) {
      context.missing(_weightGramsMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(_entryDateMeta,
          entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta));
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('status_date')) {
      context.handle(
          _statusDateMeta,
          statusDate.isAcceptableOrUnknown(
              data['status_date']!, _statusDateMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {itemGroupId, ornamentCode},
      ];
  @override
  Ornament map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ornament(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ornamentCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ornament_code'])!,
      itemGroupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_group_id'])!,
      itemTypeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}item_type_id'])!,
      weightGrams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_grams'])!,
      entryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}entry_date'])!,
      status: $OrnamentsTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      statusDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}status_date']),
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $OrnamentsTable createAlias(String alias) {
    return $OrnamentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OrnamentStatus, String, String> $converterstatus =
      const EnumNameConverter<OrnamentStatus>(OrnamentStatus.values);
}

class Ornament extends DataClass implements Insertable<Ornament> {
  final int id;

  /// User-facing alphanumeric code. Unique per item group (not globally).
  final String ornamentCode;
  final int itemGroupId;
  final int itemTypeId;
  final double weightGrams;

  /// Date the ornament was added to stock (today, editable via picker).
  final DateTime entryDate;
  final OrnamentStatus status;

  /// Date of the most recent status change (sold/pending/scrapped date).
  final DateTime? statusDate;

  /// Free-text customer name, only meaningful while status == pending.
  final String? customerName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Ornament(
      {required this.id,
      required this.ornamentCode,
      required this.itemGroupId,
      required this.itemTypeId,
      required this.weightGrams,
      required this.entryDate,
      required this.status,
      this.statusDate,
      this.customerName,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ornament_code'] = Variable<String>(ornamentCode);
    map['item_group_id'] = Variable<int>(itemGroupId);
    map['item_type_id'] = Variable<int>(itemTypeId);
    map['weight_grams'] = Variable<double>(weightGrams);
    map['entry_date'] = Variable<DateTime>(entryDate);
    {
      map['status'] =
          Variable<String>($OrnamentsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || statusDate != null) {
      map['status_date'] = Variable<DateTime>(statusDate);
    }
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrnamentsCompanion toCompanion(bool nullToAbsent) {
    return OrnamentsCompanion(
      id: Value(id),
      ornamentCode: Value(ornamentCode),
      itemGroupId: Value(itemGroupId),
      itemTypeId: Value(itemTypeId),
      weightGrams: Value(weightGrams),
      entryDate: Value(entryDate),
      status: Value(status),
      statusDate: statusDate == null && nullToAbsent
          ? const Value.absent()
          : Value(statusDate),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Ornament.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ornament(
      id: serializer.fromJson<int>(json['id']),
      ornamentCode: serializer.fromJson<String>(json['ornamentCode']),
      itemGroupId: serializer.fromJson<int>(json['itemGroupId']),
      itemTypeId: serializer.fromJson<int>(json['itemTypeId']),
      weightGrams: serializer.fromJson<double>(json['weightGrams']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
      status: $OrnamentsTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      statusDate: serializer.fromJson<DateTime?>(json['statusDate']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ornamentCode': serializer.toJson<String>(ornamentCode),
      'itemGroupId': serializer.toJson<int>(itemGroupId),
      'itemTypeId': serializer.toJson<int>(itemTypeId),
      'weightGrams': serializer.toJson<double>(weightGrams),
      'entryDate': serializer.toJson<DateTime>(entryDate),
      'status': serializer
          .toJson<String>($OrnamentsTable.$converterstatus.toJson(status)),
      'statusDate': serializer.toJson<DateTime?>(statusDate),
      'customerName': serializer.toJson<String?>(customerName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Ornament copyWith(
          {int? id,
          String? ornamentCode,
          int? itemGroupId,
          int? itemTypeId,
          double? weightGrams,
          DateTime? entryDate,
          OrnamentStatus? status,
          Value<DateTime?> statusDate = const Value.absent(),
          Value<String?> customerName = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Ornament(
        id: id ?? this.id,
        ornamentCode: ornamentCode ?? this.ornamentCode,
        itemGroupId: itemGroupId ?? this.itemGroupId,
        itemTypeId: itemTypeId ?? this.itemTypeId,
        weightGrams: weightGrams ?? this.weightGrams,
        entryDate: entryDate ?? this.entryDate,
        status: status ?? this.status,
        statusDate: statusDate.present ? statusDate.value : this.statusDate,
        customerName:
            customerName.present ? customerName.value : this.customerName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Ornament copyWithCompanion(OrnamentsCompanion data) {
    return Ornament(
      id: data.id.present ? data.id.value : this.id,
      ornamentCode: data.ornamentCode.present
          ? data.ornamentCode.value
          : this.ornamentCode,
      itemGroupId:
          data.itemGroupId.present ? data.itemGroupId.value : this.itemGroupId,
      itemTypeId:
          data.itemTypeId.present ? data.itemTypeId.value : this.itemTypeId,
      weightGrams:
          data.weightGrams.present ? data.weightGrams.value : this.weightGrams,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      status: data.status.present ? data.status.value : this.status,
      statusDate:
          data.statusDate.present ? data.statusDate.value : this.statusDate,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ornament(')
          ..write('id: $id, ')
          ..write('ornamentCode: $ornamentCode, ')
          ..write('itemGroupId: $itemGroupId, ')
          ..write('itemTypeId: $itemTypeId, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('entryDate: $entryDate, ')
          ..write('status: $status, ')
          ..write('statusDate: $statusDate, ')
          ..write('customerName: $customerName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      ornamentCode,
      itemGroupId,
      itemTypeId,
      weightGrams,
      entryDate,
      status,
      statusDate,
      customerName,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ornament &&
          other.id == this.id &&
          other.ornamentCode == this.ornamentCode &&
          other.itemGroupId == this.itemGroupId &&
          other.itemTypeId == this.itemTypeId &&
          other.weightGrams == this.weightGrams &&
          other.entryDate == this.entryDate &&
          other.status == this.status &&
          other.statusDate == this.statusDate &&
          other.customerName == this.customerName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrnamentsCompanion extends UpdateCompanion<Ornament> {
  final Value<int> id;
  final Value<String> ornamentCode;
  final Value<int> itemGroupId;
  final Value<int> itemTypeId;
  final Value<double> weightGrams;
  final Value<DateTime> entryDate;
  final Value<OrnamentStatus> status;
  final Value<DateTime?> statusDate;
  final Value<String?> customerName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const OrnamentsCompanion({
    this.id = const Value.absent(),
    this.ornamentCode = const Value.absent(),
    this.itemGroupId = const Value.absent(),
    this.itemTypeId = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.status = const Value.absent(),
    this.statusDate = const Value.absent(),
    this.customerName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  OrnamentsCompanion.insert({
    this.id = const Value.absent(),
    required String ornamentCode,
    required int itemGroupId,
    required int itemTypeId,
    required double weightGrams,
    required DateTime entryDate,
    this.status = const Value.absent(),
    this.statusDate = const Value.absent(),
    this.customerName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : ornamentCode = Value(ornamentCode),
        itemGroupId = Value(itemGroupId),
        itemTypeId = Value(itemTypeId),
        weightGrams = Value(weightGrams),
        entryDate = Value(entryDate);
  static Insertable<Ornament> custom({
    Expression<int>? id,
    Expression<String>? ornamentCode,
    Expression<int>? itemGroupId,
    Expression<int>? itemTypeId,
    Expression<double>? weightGrams,
    Expression<DateTime>? entryDate,
    Expression<String>? status,
    Expression<DateTime>? statusDate,
    Expression<String>? customerName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ornamentCode != null) 'ornament_code': ornamentCode,
      if (itemGroupId != null) 'item_group_id': itemGroupId,
      if (itemTypeId != null) 'item_type_id': itemTypeId,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (entryDate != null) 'entry_date': entryDate,
      if (status != null) 'status': status,
      if (statusDate != null) 'status_date': statusDate,
      if (customerName != null) 'customer_name': customerName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  OrnamentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? ornamentCode,
      Value<int>? itemGroupId,
      Value<int>? itemTypeId,
      Value<double>? weightGrams,
      Value<DateTime>? entryDate,
      Value<OrnamentStatus>? status,
      Value<DateTime?>? statusDate,
      Value<String?>? customerName,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return OrnamentsCompanion(
      id: id ?? this.id,
      ornamentCode: ornamentCode ?? this.ornamentCode,
      itemGroupId: itemGroupId ?? this.itemGroupId,
      itemTypeId: itemTypeId ?? this.itemTypeId,
      weightGrams: weightGrams ?? this.weightGrams,
      entryDate: entryDate ?? this.entryDate,
      status: status ?? this.status,
      statusDate: statusDate ?? this.statusDate,
      customerName: customerName ?? this.customerName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ornamentCode.present) {
      map['ornament_code'] = Variable<String>(ornamentCode.value);
    }
    if (itemGroupId.present) {
      map['item_group_id'] = Variable<int>(itemGroupId.value);
    }
    if (itemTypeId.present) {
      map['item_type_id'] = Variable<int>(itemTypeId.value);
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<double>(weightGrams.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $OrnamentsTable.$converterstatus.toSql(status.value));
    }
    if (statusDate.present) {
      map['status_date'] = Variable<DateTime>(statusDate.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrnamentsCompanion(')
          ..write('id: $id, ')
          ..write('ornamentCode: $ornamentCode, ')
          ..write('itemGroupId: $itemGroupId, ')
          ..write('itemTypeId: $itemTypeId, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('entryDate: $entryDate, ')
          ..write('status: $status, ')
          ..write('statusDate: $statusDate, ')
          ..write('customerName: $customerName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StatusHistoriesTable extends StatusHistories
    with TableInfo<$StatusHistoriesTable, StatusHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StatusHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _ornamentIdMeta =
      const VerificationMeta('ornamentId');
  @override
  late final GeneratedColumn<int> ornamentId = GeneratedColumn<int>(
      'ornament_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES ornaments (id)'));
  @override
  late final GeneratedColumnWithTypeConverter<OrnamentStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<OrnamentStatus>(
              $StatusHistoriesTable.$converterstatus);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, ornamentId, status, date, customerName, recordedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'status_histories';
  @override
  VerificationContext validateIntegrity(Insertable<StatusHistory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ornament_id')) {
      context.handle(
          _ornamentIdMeta,
          ornamentId.isAcceptableOrUnknown(
              data['ornament_id']!, _ornamentIdMeta));
    } else if (isInserting) {
      context.missing(_ornamentIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StatusHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatusHistory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      ornamentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ornament_id'])!,
      status: $StatusHistoriesTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name']),
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
    );
  }

  @override
  $StatusHistoriesTable createAlias(String alias) {
    return $StatusHistoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OrnamentStatus, String, String> $converterstatus =
      const EnumNameConverter<OrnamentStatus>(OrnamentStatus.values);
}

class StatusHistory extends DataClass implements Insertable<StatusHistory> {
  final int id;
  final int ornamentId;
  final OrnamentStatus status;
  final DateTime date;
  final String? customerName;
  final DateTime recordedAt;
  const StatusHistory(
      {required this.id,
      required this.ornamentId,
      required this.status,
      required this.date,
      this.customerName,
      required this.recordedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ornament_id'] = Variable<int>(ornamentId);
    {
      map['status'] = Variable<String>(
          $StatusHistoriesTable.$converterstatus.toSql(status));
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  StatusHistoriesCompanion toCompanion(bool nullToAbsent) {
    return StatusHistoriesCompanion(
      id: Value(id),
      ornamentId: Value(ornamentId),
      status: Value(status),
      date: Value(date),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      recordedAt: Value(recordedAt),
    );
  }

  factory StatusHistory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatusHistory(
      id: serializer.fromJson<int>(json['id']),
      ornamentId: serializer.fromJson<int>(json['ornamentId']),
      status: $StatusHistoriesTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      date: serializer.fromJson<DateTime>(json['date']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ornamentId': serializer.toJson<int>(ornamentId),
      'status': serializer.toJson<String>(
          $StatusHistoriesTable.$converterstatus.toJson(status)),
      'date': serializer.toJson<DateTime>(date),
      'customerName': serializer.toJson<String?>(customerName),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  StatusHistory copyWith(
          {int? id,
          int? ornamentId,
          OrnamentStatus? status,
          DateTime? date,
          Value<String?> customerName = const Value.absent(),
          DateTime? recordedAt}) =>
      StatusHistory(
        id: id ?? this.id,
        ornamentId: ornamentId ?? this.ornamentId,
        status: status ?? this.status,
        date: date ?? this.date,
        customerName:
            customerName.present ? customerName.value : this.customerName,
        recordedAt: recordedAt ?? this.recordedAt,
      );
  StatusHistory copyWithCompanion(StatusHistoriesCompanion data) {
    return StatusHistory(
      id: data.id.present ? data.id.value : this.id,
      ornamentId:
          data.ornamentId.present ? data.ornamentId.value : this.ornamentId,
      status: data.status.present ? data.status.value : this.status,
      date: data.date.present ? data.date.value : this.date,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StatusHistory(')
          ..write('id: $id, ')
          ..write('ornamentId: $ornamentId, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('customerName: $customerName, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ornamentId, status, date, customerName, recordedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatusHistory &&
          other.id == this.id &&
          other.ornamentId == this.ornamentId &&
          other.status == this.status &&
          other.date == this.date &&
          other.customerName == this.customerName &&
          other.recordedAt == this.recordedAt);
}

class StatusHistoriesCompanion extends UpdateCompanion<StatusHistory> {
  final Value<int> id;
  final Value<int> ornamentId;
  final Value<OrnamentStatus> status;
  final Value<DateTime> date;
  final Value<String?> customerName;
  final Value<DateTime> recordedAt;
  const StatusHistoriesCompanion({
    this.id = const Value.absent(),
    this.ornamentId = const Value.absent(),
    this.status = const Value.absent(),
    this.date = const Value.absent(),
    this.customerName = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  StatusHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required int ornamentId,
    required OrnamentStatus status,
    required DateTime date,
    this.customerName = const Value.absent(),
    this.recordedAt = const Value.absent(),
  })  : ornamentId = Value(ornamentId),
        status = Value(status),
        date = Value(date);
  static Insertable<StatusHistory> custom({
    Expression<int>? id,
    Expression<int>? ornamentId,
    Expression<String>? status,
    Expression<DateTime>? date,
    Expression<String>? customerName,
    Expression<DateTime>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ornamentId != null) 'ornament_id': ornamentId,
      if (status != null) 'status': status,
      if (date != null) 'date': date,
      if (customerName != null) 'customer_name': customerName,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  StatusHistoriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? ornamentId,
      Value<OrnamentStatus>? status,
      Value<DateTime>? date,
      Value<String?>? customerName,
      Value<DateTime>? recordedAt}) {
    return StatusHistoriesCompanion(
      id: id ?? this.id,
      ornamentId: ornamentId ?? this.ornamentId,
      status: status ?? this.status,
      date: date ?? this.date,
      customerName: customerName ?? this.customerName,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ornamentId.present) {
      map['ornament_id'] = Variable<int>(ornamentId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $StatusHistoriesTable.$converterstatus.toSql(status.value));
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatusHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('ornamentId: $ornamentId, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('customerName: $customerName, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

class $SilverPlusBoxesTable extends SilverPlusBoxes
    with TableInfo<$SilverPlusBoxesTable, SilverPlusBox> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SilverPlusBoxesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _boxCodeMeta =
      const VerificationMeta('boxCode');
  @override
  late final GeneratedColumn<String> boxCode = GeneratedColumn<String>(
      'box_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 40),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightGramsMeta =
      const VerificationMeta('weightGrams');
  @override
  late final GeneratedColumn<double> weightGrams = GeneratedColumn<double>(
      'weight_grams', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, boxCode, count, weightGrams, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'silver_plus_boxes';
  @override
  VerificationContext validateIntegrity(Insertable<SilverPlusBox> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('box_code')) {
      context.handle(_boxCodeMeta,
          boxCode.isAcceptableOrUnknown(data['box_code']!, _boxCodeMeta));
    } else if (isInserting) {
      context.missing(_boxCodeMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
          _weightGramsMeta,
          weightGrams.isAcceptableOrUnknown(
              data['weight_grams']!, _weightGramsMeta));
    } else if (isInserting) {
      context.missing(_weightGramsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SilverPlusBox map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SilverPlusBox(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      boxCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}box_code'])!,
      count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
      weightGrams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_grams'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SilverPlusBoxesTable createAlias(String alias) {
    return $SilverPlusBoxesTable(attachedDatabase, alias);
  }
}

class SilverPlusBox extends DataClass implements Insertable<SilverPlusBox> {
  final int id;

  /// Alphanumeric, forced uppercase in the UI, unique within this table.
  final String boxCode;
  final int count;
  final double weightGrams;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SilverPlusBox(
      {required this.id,
      required this.boxCode,
      required this.count,
      required this.weightGrams,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['box_code'] = Variable<String>(boxCode);
    map['count'] = Variable<int>(count);
    map['weight_grams'] = Variable<double>(weightGrams);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SilverPlusBoxesCompanion toCompanion(bool nullToAbsent) {
    return SilverPlusBoxesCompanion(
      id: Value(id),
      boxCode: Value(boxCode),
      count: Value(count),
      weightGrams: Value(weightGrams),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SilverPlusBox.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SilverPlusBox(
      id: serializer.fromJson<int>(json['id']),
      boxCode: serializer.fromJson<String>(json['boxCode']),
      count: serializer.fromJson<int>(json['count']),
      weightGrams: serializer.fromJson<double>(json['weightGrams']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'boxCode': serializer.toJson<String>(boxCode),
      'count': serializer.toJson<int>(count),
      'weightGrams': serializer.toJson<double>(weightGrams),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SilverPlusBox copyWith(
          {int? id,
          String? boxCode,
          int? count,
          double? weightGrams,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SilverPlusBox(
        id: id ?? this.id,
        boxCode: boxCode ?? this.boxCode,
        count: count ?? this.count,
        weightGrams: weightGrams ?? this.weightGrams,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SilverPlusBox copyWithCompanion(SilverPlusBoxesCompanion data) {
    return SilverPlusBox(
      id: data.id.present ? data.id.value : this.id,
      boxCode: data.boxCode.present ? data.boxCode.value : this.boxCode,
      count: data.count.present ? data.count.value : this.count,
      weightGrams:
          data.weightGrams.present ? data.weightGrams.value : this.weightGrams,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SilverPlusBox(')
          ..write('id: $id, ')
          ..write('boxCode: $boxCode, ')
          ..write('count: $count, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, boxCode, count, weightGrams, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SilverPlusBox &&
          other.id == this.id &&
          other.boxCode == this.boxCode &&
          other.count == this.count &&
          other.weightGrams == this.weightGrams &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SilverPlusBoxesCompanion extends UpdateCompanion<SilverPlusBox> {
  final Value<int> id;
  final Value<String> boxCode;
  final Value<int> count;
  final Value<double> weightGrams;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SilverPlusBoxesCompanion({
    this.id = const Value.absent(),
    this.boxCode = const Value.absent(),
    this.count = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SilverPlusBoxesCompanion.insert({
    this.id = const Value.absent(),
    required String boxCode,
    required int count,
    required double weightGrams,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : boxCode = Value(boxCode),
        count = Value(count),
        weightGrams = Value(weightGrams);
  static Insertable<SilverPlusBox> custom({
    Expression<int>? id,
    Expression<String>? boxCode,
    Expression<int>? count,
    Expression<double>? weightGrams,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (boxCode != null) 'box_code': boxCode,
      if (count != null) 'count': count,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SilverPlusBoxesCompanion copyWith(
      {Value<int>? id,
      Value<String>? boxCode,
      Value<int>? count,
      Value<double>? weightGrams,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return SilverPlusBoxesCompanion(
      id: id ?? this.id,
      boxCode: boxCode ?? this.boxCode,
      count: count ?? this.count,
      weightGrams: weightGrams ?? this.weightGrams,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (boxCode.present) {
      map['box_code'] = Variable<String>(boxCode.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<double>(weightGrams.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SilverPlusBoxesCompanion(')
          ..write('id: $id, ')
          ..write('boxCode: $boxCode, ')
          ..write('count: $count, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SilverPlusAllocationsTable extends SilverPlusAllocations
    with TableInfo<$SilverPlusAllocationsTable, SilverPlusAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SilverPlusAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _boxIdMeta = const VerificationMeta('boxId');
  @override
  late final GeneratedColumn<int> boxId = GeneratedColumn<int>(
      'box_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES silver_plus_boxes (id)'));
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightGramsMeta =
      const VerificationMeta('weightGrams');
  @override
  late final GeneratedColumn<double> weightGrams = GeneratedColumn<double>(
      'weight_grams', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<AllocationStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('pending'))
          .withConverter<AllocationStatus>(
              $SilverPlusAllocationsTable.$converterstatus);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        boxId,
        count,
        weightGrams,
        date,
        status,
        customerName,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'silver_plus_allocations';
  @override
  VerificationContext validateIntegrity(
      Insertable<SilverPlusAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('box_id')) {
      context.handle(
          _boxIdMeta, boxId.isAcceptableOrUnknown(data['box_id']!, _boxIdMeta));
    } else if (isInserting) {
      context.missing(_boxIdMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
          _weightGramsMeta,
          weightGrams.isAcceptableOrUnknown(
              data['weight_grams']!, _weightGramsMeta));
    } else if (isInserting) {
      context.missing(_weightGramsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SilverPlusAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SilverPlusAllocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      boxId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}box_id'])!,
      count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
      weightGrams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_grams'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      status: $SilverPlusAllocationsTable.$converterstatus.fromSql(
          attachedDatabase.typeMapping
              .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SilverPlusAllocationsTable createAlias(String alias) {
    return $SilverPlusAllocationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AllocationStatus, String, String> $converterstatus =
      const EnumNameConverter<AllocationStatus>(AllocationStatus.values);
}

class SilverPlusAllocation extends DataClass
    implements Insertable<SilverPlusAllocation> {
  final int id;
  final int boxId;
  final int count;
  final double weightGrams;
  final DateTime date;
  final AllocationStatus status;

  /// Free-text customer name, only meaningful while status == pending.
  final String? customerName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SilverPlusAllocation(
      {required this.id,
      required this.boxId,
      required this.count,
      required this.weightGrams,
      required this.date,
      required this.status,
      this.customerName,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['box_id'] = Variable<int>(boxId);
    map['count'] = Variable<int>(count);
    map['weight_grams'] = Variable<double>(weightGrams);
    map['date'] = Variable<DateTime>(date);
    {
      map['status'] = Variable<String>(
          $SilverPlusAllocationsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SilverPlusAllocationsCompanion toCompanion(bool nullToAbsent) {
    return SilverPlusAllocationsCompanion(
      id: Value(id),
      boxId: Value(boxId),
      count: Value(count),
      weightGrams: Value(weightGrams),
      date: Value(date),
      status: Value(status),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SilverPlusAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SilverPlusAllocation(
      id: serializer.fromJson<int>(json['id']),
      boxId: serializer.fromJson<int>(json['boxId']),
      count: serializer.fromJson<int>(json['count']),
      weightGrams: serializer.fromJson<double>(json['weightGrams']),
      date: serializer.fromJson<DateTime>(json['date']),
      status: $SilverPlusAllocationsTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      customerName: serializer.fromJson<String?>(json['customerName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'boxId': serializer.toJson<int>(boxId),
      'count': serializer.toJson<int>(count),
      'weightGrams': serializer.toJson<double>(weightGrams),
      'date': serializer.toJson<DateTime>(date),
      'status': serializer.toJson<String>(
          $SilverPlusAllocationsTable.$converterstatus.toJson(status)),
      'customerName': serializer.toJson<String?>(customerName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SilverPlusAllocation copyWith(
          {int? id,
          int? boxId,
          int? count,
          double? weightGrams,
          DateTime? date,
          AllocationStatus? status,
          Value<String?> customerName = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SilverPlusAllocation(
        id: id ?? this.id,
        boxId: boxId ?? this.boxId,
        count: count ?? this.count,
        weightGrams: weightGrams ?? this.weightGrams,
        date: date ?? this.date,
        status: status ?? this.status,
        customerName:
            customerName.present ? customerName.value : this.customerName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SilverPlusAllocation copyWithCompanion(SilverPlusAllocationsCompanion data) {
    return SilverPlusAllocation(
      id: data.id.present ? data.id.value : this.id,
      boxId: data.boxId.present ? data.boxId.value : this.boxId,
      count: data.count.present ? data.count.value : this.count,
      weightGrams:
          data.weightGrams.present ? data.weightGrams.value : this.weightGrams,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SilverPlusAllocation(')
          ..write('id: $id, ')
          ..write('boxId: $boxId, ')
          ..write('count: $count, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('customerName: $customerName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, boxId, count, weightGrams, date, status,
      customerName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SilverPlusAllocation &&
          other.id == this.id &&
          other.boxId == this.boxId &&
          other.count == this.count &&
          other.weightGrams == this.weightGrams &&
          other.date == this.date &&
          other.status == this.status &&
          other.customerName == this.customerName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SilverPlusAllocationsCompanion
    extends UpdateCompanion<SilverPlusAllocation> {
  final Value<int> id;
  final Value<int> boxId;
  final Value<int> count;
  final Value<double> weightGrams;
  final Value<DateTime> date;
  final Value<AllocationStatus> status;
  final Value<String?> customerName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SilverPlusAllocationsCompanion({
    this.id = const Value.absent(),
    this.boxId = const Value.absent(),
    this.count = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.customerName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SilverPlusAllocationsCompanion.insert({
    this.id = const Value.absent(),
    required int boxId,
    required int count,
    required double weightGrams,
    required DateTime date,
    this.status = const Value.absent(),
    this.customerName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : boxId = Value(boxId),
        count = Value(count),
        weightGrams = Value(weightGrams),
        date = Value(date);
  static Insertable<SilverPlusAllocation> custom({
    Expression<int>? id,
    Expression<int>? boxId,
    Expression<int>? count,
    Expression<double>? weightGrams,
    Expression<DateTime>? date,
    Expression<String>? status,
    Expression<String>? customerName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (boxId != null) 'box_id': boxId,
      if (count != null) 'count': count,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (customerName != null) 'customer_name': customerName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SilverPlusAllocationsCompanion copyWith(
      {Value<int>? id,
      Value<int>? boxId,
      Value<int>? count,
      Value<double>? weightGrams,
      Value<DateTime>? date,
      Value<AllocationStatus>? status,
      Value<String?>? customerName,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return SilverPlusAllocationsCompanion(
      id: id ?? this.id,
      boxId: boxId ?? this.boxId,
      count: count ?? this.count,
      weightGrams: weightGrams ?? this.weightGrams,
      date: date ?? this.date,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (boxId.present) {
      map['box_id'] = Variable<int>(boxId.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<double>(weightGrams.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $SilverPlusAllocationsTable.$converterstatus.toSql(status.value));
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SilverPlusAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('boxId: $boxId, ')
          ..write('count: $count, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('customerName: $customerName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OldSilverEntriesTable extends OldSilverEntries
    with TableInfo<$OldSilverEntriesTable, OldSilverEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OldSilverEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _weightGramsMeta =
      const VerificationMeta('weightGrams');
  @override
  late final GeneratedColumn<double> weightGrams = GeneratedColumn<double>(
      'weight_grams', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _entryDateMeta =
      const VerificationMeta('entryDate');
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
      'entry_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, weightGrams, entryDate, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'old_silver_entries';
  @override
  VerificationContext validateIntegrity(Insertable<OldSilverEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('weight_grams')) {
      context.handle(
          _weightGramsMeta,
          weightGrams.isAcceptableOrUnknown(
              data['weight_grams']!, _weightGramsMeta));
    } else if (isInserting) {
      context.missing(_weightGramsMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(_entryDateMeta,
          entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta));
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OldSilverEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OldSilverEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      weightGrams: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_grams'])!,
      entryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}entry_date'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $OldSilverEntriesTable createAlias(String alias) {
    return $OldSilverEntriesTable(attachedDatabase, alias);
  }
}

class OldSilverEntry extends DataClass implements Insertable<OldSilverEntry> {
  final int id;
  final double weightGrams;
  final DateTime entryDate;
  final String? note;
  final DateTime createdAt;
  const OldSilverEntry(
      {required this.id,
      required this.weightGrams,
      required this.entryDate,
      this.note,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['weight_grams'] = Variable<double>(weightGrams);
    map['entry_date'] = Variable<DateTime>(entryDate);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OldSilverEntriesCompanion toCompanion(bool nullToAbsent) {
    return OldSilverEntriesCompanion(
      id: Value(id),
      weightGrams: Value(weightGrams),
      entryDate: Value(entryDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory OldSilverEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OldSilverEntry(
      id: serializer.fromJson<int>(json['id']),
      weightGrams: serializer.fromJson<double>(json['weightGrams']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weightGrams': serializer.toJson<double>(weightGrams),
      'entryDate': serializer.toJson<DateTime>(entryDate),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OldSilverEntry copyWith(
          {int? id,
          double? weightGrams,
          DateTime? entryDate,
          Value<String?> note = const Value.absent(),
          DateTime? createdAt}) =>
      OldSilverEntry(
        id: id ?? this.id,
        weightGrams: weightGrams ?? this.weightGrams,
        entryDate: entryDate ?? this.entryDate,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
      );
  OldSilverEntry copyWithCompanion(OldSilverEntriesCompanion data) {
    return OldSilverEntry(
      id: data.id.present ? data.id.value : this.id,
      weightGrams:
          data.weightGrams.present ? data.weightGrams.value : this.weightGrams,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OldSilverEntry(')
          ..write('id: $id, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('entryDate: $entryDate, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weightGrams, entryDate, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OldSilverEntry &&
          other.id == this.id &&
          other.weightGrams == this.weightGrams &&
          other.entryDate == this.entryDate &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class OldSilverEntriesCompanion extends UpdateCompanion<OldSilverEntry> {
  final Value<int> id;
  final Value<double> weightGrams;
  final Value<DateTime> entryDate;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const OldSilverEntriesCompanion({
    this.id = const Value.absent(),
    this.weightGrams = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OldSilverEntriesCompanion.insert({
    this.id = const Value.absent(),
    required double weightGrams,
    required DateTime entryDate,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  })  : weightGrams = Value(weightGrams),
        entryDate = Value(entryDate);
  static Insertable<OldSilverEntry> custom({
    Expression<int>? id,
    Expression<double>? weightGrams,
    Expression<DateTime>? entryDate,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weightGrams != null) 'weight_grams': weightGrams,
      if (entryDate != null) 'entry_date': entryDate,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OldSilverEntriesCompanion copyWith(
      {Value<int>? id,
      Value<double>? weightGrams,
      Value<DateTime>? entryDate,
      Value<String?>? note,
      Value<DateTime>? createdAt}) {
    return OldSilverEntriesCompanion(
      id: id ?? this.id,
      weightGrams: weightGrams ?? this.weightGrams,
      entryDate: entryDate ?? this.entryDate,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weightGrams.present) {
      map['weight_grams'] = Variable<double>(weightGrams.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OldSilverEntriesCompanion(')
          ..write('id: $id, ')
          ..write('weightGrams: $weightGrams, ')
          ..write('entryDate: $entryDate, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ItemGroupsTable itemGroups = $ItemGroupsTable(this);
  late final $ItemTypesTable itemTypes = $ItemTypesTable(this);
  late final $OrnamentsTable ornaments = $OrnamentsTable(this);
  late final $StatusHistoriesTable statusHistories =
      $StatusHistoriesTable(this);
  late final $SilverPlusBoxesTable silverPlusBoxes =
      $SilverPlusBoxesTable(this);
  late final $SilverPlusAllocationsTable silverPlusAllocations =
      $SilverPlusAllocationsTable(this);
  late final $OldSilverEntriesTable oldSilverEntries =
      $OldSilverEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        itemGroups,
        itemTypes,
        ornaments,
        statusHistories,
        silverPlusBoxes,
        silverPlusAllocations,
        oldSilverEntries
      ];
}

typedef $$ItemGroupsTableCreateCompanionBuilder = ItemGroupsCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$ItemGroupsTableUpdateCompanionBuilder = ItemGroupsCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$ItemGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $ItemGroupsTable, ItemGroup> {
  $$ItemGroupsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ItemTypesTable, List<ItemType>>
      _itemTypesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.itemTypes,
          aliasName:
              $_aliasNameGenerator(db.itemGroups.id, db.itemTypes.itemGroupId));

  $$ItemTypesTableProcessedTableManager get itemTypesRefs {
    final manager = $$ItemTypesTableTableManager($_db, $_db.itemTypes)
        .filter((f) => f.itemGroupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemTypesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OrnamentsTable, List<Ornament>>
      _ornamentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.ornaments,
          aliasName:
              $_aliasNameGenerator(db.itemGroups.id, db.ornaments.itemGroupId));

  $$OrnamentsTableProcessedTableManager get ornamentsRefs {
    final manager = $$OrnamentsTableTableManager($_db, $_db.ornaments)
        .filter((f) => f.itemGroupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ornamentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ItemGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $ItemGroupsTable> {
  $$ItemGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  Expression<bool> itemTypesRefs(
      Expression<bool> Function($$ItemTypesTableFilterComposer f) f) {
    final $$ItemTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemTypes,
        getReferencedColumn: (t) => t.itemGroupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemTypesTableFilterComposer(
              $db: $db,
              $table: $db.itemTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> ornamentsRefs(
      Expression<bool> Function($$OrnamentsTableFilterComposer f) f) {
    final $$OrnamentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ornaments,
        getReferencedColumn: (t) => t.itemGroupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrnamentsTableFilterComposer(
              $db: $db,
              $table: $db.ornaments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemGroupsTable> {
  $$ItemGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$ItemGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemGroupsTable> {
  $$ItemGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> itemTypesRefs<T extends Object>(
      Expression<T> Function($$ItemTypesTableAnnotationComposer a) f) {
    final $$ItemTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.itemTypes,
        getReferencedColumn: (t) => t.itemGroupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.itemTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> ornamentsRefs<T extends Object>(
      Expression<T> Function($$OrnamentsTableAnnotationComposer a) f) {
    final $$OrnamentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ornaments,
        getReferencedColumn: (t) => t.itemGroupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrnamentsTableAnnotationComposer(
              $db: $db,
              $table: $db.ornaments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemGroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemGroupsTable,
    ItemGroup,
    $$ItemGroupsTableFilterComposer,
    $$ItemGroupsTableOrderingComposer,
    $$ItemGroupsTableAnnotationComposer,
    $$ItemGroupsTableCreateCompanionBuilder,
    $$ItemGroupsTableUpdateCompanionBuilder,
    (ItemGroup, $$ItemGroupsTableReferences),
    ItemGroup,
    PrefetchHooks Function({bool itemTypesRefs, bool ornamentsRefs})> {
  $$ItemGroupsTableTableManager(_$AppDatabase db, $ItemGroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              ItemGroupsCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              ItemGroupsCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ItemGroupsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {itemTypesRefs = false, ornamentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (itemTypesRefs) db.itemTypes,
                if (ornamentsRefs) db.ornaments
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemTypesRefs)
                    await $_getPrefetchedData<ItemGroup, $ItemGroupsTable,
                            ItemType>(
                        currentTable: table,
                        referencedTable:
                            $$ItemGroupsTableReferences._itemTypesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemGroupsTableReferences(db, table, p0)
                                .itemTypesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.itemGroupId == item.id),
                        typedResults: items),
                  if (ornamentsRefs)
                    await $_getPrefetchedData<ItemGroup, $ItemGroupsTable,
                            Ornament>(
                        currentTable: table,
                        referencedTable:
                            $$ItemGroupsTableReferences._ornamentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemGroupsTableReferences(db, table, p0)
                                .ornamentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.itemGroupId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ItemGroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemGroupsTable,
    ItemGroup,
    $$ItemGroupsTableFilterComposer,
    $$ItemGroupsTableOrderingComposer,
    $$ItemGroupsTableAnnotationComposer,
    $$ItemGroupsTableCreateCompanionBuilder,
    $$ItemGroupsTableUpdateCompanionBuilder,
    (ItemGroup, $$ItemGroupsTableReferences),
    ItemGroup,
    PrefetchHooks Function({bool itemTypesRefs, bool ornamentsRefs})>;
typedef $$ItemTypesTableCreateCompanionBuilder = ItemTypesCompanion Function({
  Value<int> id,
  required int itemGroupId,
  required String name,
});
typedef $$ItemTypesTableUpdateCompanionBuilder = ItemTypesCompanion Function({
  Value<int> id,
  Value<int> itemGroupId,
  Value<String> name,
});

final class $$ItemTypesTableReferences
    extends BaseReferences<_$AppDatabase, $ItemTypesTable, ItemType> {
  $$ItemTypesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemGroupsTable _itemGroupIdTable(_$AppDatabase db) =>
      db.itemGroups.createAlias(
          $_aliasNameGenerator(db.itemTypes.itemGroupId, db.itemGroups.id));

  $$ItemGroupsTableProcessedTableManager get itemGroupId {
    final $_column = $_itemColumn<int>('item_group_id')!;

    final manager = $$ItemGroupsTableTableManager($_db, $_db.itemGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$OrnamentsTable, List<Ornament>>
      _ornamentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.ornaments,
          aliasName:
              $_aliasNameGenerator(db.itemTypes.id, db.ornaments.itemTypeId));

  $$OrnamentsTableProcessedTableManager get ornamentsRefs {
    final manager = $$OrnamentsTableTableManager($_db, $_db.ornaments)
        .filter((f) => f.itemTypeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ornamentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ItemTypesTableFilterComposer
    extends Composer<_$AppDatabase, $ItemTypesTable> {
  $$ItemTypesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  $$ItemGroupsTableFilterComposer get itemGroupId {
    final $$ItemGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemGroupId,
        referencedTable: $db.itemGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemGroupsTableFilterComposer(
              $db: $db,
              $table: $db.itemGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> ornamentsRefs(
      Expression<bool> Function($$OrnamentsTableFilterComposer f) f) {
    final $$OrnamentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ornaments,
        getReferencedColumn: (t) => t.itemTypeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrnamentsTableFilterComposer(
              $db: $db,
              $table: $db.ornaments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemTypesTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemTypesTable> {
  $$ItemTypesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  $$ItemGroupsTableOrderingComposer get itemGroupId {
    final $$ItemGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemGroupId,
        referencedTable: $db.itemGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.itemGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ItemTypesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemTypesTable> {
  $$ItemTypesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$ItemGroupsTableAnnotationComposer get itemGroupId {
    final $$ItemGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemGroupId,
        referencedTable: $db.itemGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.itemGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> ornamentsRefs<T extends Object>(
      Expression<T> Function($$OrnamentsTableAnnotationComposer a) f) {
    final $$OrnamentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ornaments,
        getReferencedColumn: (t) => t.itemTypeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrnamentsTableAnnotationComposer(
              $db: $db,
              $table: $db.ornaments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ItemTypesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ItemTypesTable,
    ItemType,
    $$ItemTypesTableFilterComposer,
    $$ItemTypesTableOrderingComposer,
    $$ItemTypesTableAnnotationComposer,
    $$ItemTypesTableCreateCompanionBuilder,
    $$ItemTypesTableUpdateCompanionBuilder,
    (ItemType, $$ItemTypesTableReferences),
    ItemType,
    PrefetchHooks Function({bool itemGroupId, bool ornamentsRefs})> {
  $$ItemTypesTableTableManager(_$AppDatabase db, $ItemTypesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemTypesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemTypesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemTypesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> itemGroupId = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              ItemTypesCompanion(
            id: id,
            itemGroupId: itemGroupId,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int itemGroupId,
            required String name,
          }) =>
              ItemTypesCompanion.insert(
            id: id,
            itemGroupId: itemGroupId,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ItemTypesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {itemGroupId = false, ornamentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ornamentsRefs) db.ornaments],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (itemGroupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemGroupId,
                    referencedTable:
                        $$ItemTypesTableReferences._itemGroupIdTable(db),
                    referencedColumn:
                        $$ItemTypesTableReferences._itemGroupIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ornamentsRefs)
                    await $_getPrefetchedData<ItemType, $ItemTypesTable,
                            Ornament>(
                        currentTable: table,
                        referencedTable:
                            $$ItemTypesTableReferences._ornamentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ItemTypesTableReferences(db, table, p0)
                                .ornamentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.itemTypeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ItemTypesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ItemTypesTable,
    ItemType,
    $$ItemTypesTableFilterComposer,
    $$ItemTypesTableOrderingComposer,
    $$ItemTypesTableAnnotationComposer,
    $$ItemTypesTableCreateCompanionBuilder,
    $$ItemTypesTableUpdateCompanionBuilder,
    (ItemType, $$ItemTypesTableReferences),
    ItemType,
    PrefetchHooks Function({bool itemGroupId, bool ornamentsRefs})>;
typedef $$OrnamentsTableCreateCompanionBuilder = OrnamentsCompanion Function({
  Value<int> id,
  required String ornamentCode,
  required int itemGroupId,
  required int itemTypeId,
  required double weightGrams,
  required DateTime entryDate,
  Value<OrnamentStatus> status,
  Value<DateTime?> statusDate,
  Value<String?> customerName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$OrnamentsTableUpdateCompanionBuilder = OrnamentsCompanion Function({
  Value<int> id,
  Value<String> ornamentCode,
  Value<int> itemGroupId,
  Value<int> itemTypeId,
  Value<double> weightGrams,
  Value<DateTime> entryDate,
  Value<OrnamentStatus> status,
  Value<DateTime?> statusDate,
  Value<String?> customerName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$OrnamentsTableReferences
    extends BaseReferences<_$AppDatabase, $OrnamentsTable, Ornament> {
  $$OrnamentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemGroupsTable _itemGroupIdTable(_$AppDatabase db) =>
      db.itemGroups.createAlias(
          $_aliasNameGenerator(db.ornaments.itemGroupId, db.itemGroups.id));

  $$ItemGroupsTableProcessedTableManager get itemGroupId {
    final $_column = $_itemColumn<int>('item_group_id')!;

    final manager = $$ItemGroupsTableTableManager($_db, $_db.itemGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemGroupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ItemTypesTable _itemTypeIdTable(_$AppDatabase db) =>
      db.itemTypes.createAlias(
          $_aliasNameGenerator(db.ornaments.itemTypeId, db.itemTypes.id));

  $$ItemTypesTableProcessedTableManager get itemTypeId {
    final $_column = $_itemColumn<int>('item_type_id')!;

    final manager = $$ItemTypesTableTableManager($_db, $_db.itemTypes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemTypeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$StatusHistoriesTable, List<StatusHistory>>
      _statusHistoriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.statusHistories,
              aliasName: $_aliasNameGenerator(
                  db.ornaments.id, db.statusHistories.ornamentId));

  $$StatusHistoriesTableProcessedTableManager get statusHistoriesRefs {
    final manager =
        $$StatusHistoriesTableTableManager($_db, $_db.statusHistories)
            .filter((f) => f.ornamentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_statusHistoriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrnamentsTableFilterComposer
    extends Composer<_$AppDatabase, $OrnamentsTable> {
  $$OrnamentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ornamentCode => $composableBuilder(
      column: $table.ornamentCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
      column: $table.entryDate, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<OrnamentStatus, OrnamentStatus, String>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get statusDate => $composableBuilder(
      column: $table.statusDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ItemGroupsTableFilterComposer get itemGroupId {
    final $$ItemGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemGroupId,
        referencedTable: $db.itemGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemGroupsTableFilterComposer(
              $db: $db,
              $table: $db.itemGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemTypesTableFilterComposer get itemTypeId {
    final $$ItemTypesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemTypeId,
        referencedTable: $db.itemTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemTypesTableFilterComposer(
              $db: $db,
              $table: $db.itemTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> statusHistoriesRefs(
      Expression<bool> Function($$StatusHistoriesTableFilterComposer f) f) {
    final $$StatusHistoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.statusHistories,
        getReferencedColumn: (t) => t.ornamentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StatusHistoriesTableFilterComposer(
              $db: $db,
              $table: $db.statusHistories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrnamentsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrnamentsTable> {
  $$OrnamentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ornamentCode => $composableBuilder(
      column: $table.ornamentCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
      column: $table.entryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get statusDate => $composableBuilder(
      column: $table.statusDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ItemGroupsTableOrderingComposer get itemGroupId {
    final $$ItemGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemGroupId,
        referencedTable: $db.itemGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.itemGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemTypesTableOrderingComposer get itemTypeId {
    final $$ItemTypesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemTypeId,
        referencedTable: $db.itemTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemTypesTableOrderingComposer(
              $db: $db,
              $table: $db.itemTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrnamentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrnamentsTable> {
  $$OrnamentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ornamentCode => $composableBuilder(
      column: $table.ornamentCode, builder: (column) => column);

  GeneratedColumn<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrnamentStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get statusDate => $composableBuilder(
      column: $table.statusDate, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ItemGroupsTableAnnotationComposer get itemGroupId {
    final $$ItemGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemGroupId,
        referencedTable: $db.itemGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.itemGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ItemTypesTableAnnotationComposer get itemTypeId {
    final $$ItemTypesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.itemTypeId,
        referencedTable: $db.itemTypes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ItemTypesTableAnnotationComposer(
              $db: $db,
              $table: $db.itemTypes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> statusHistoriesRefs<T extends Object>(
      Expression<T> Function($$StatusHistoriesTableAnnotationComposer a) f) {
    final $$StatusHistoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.statusHistories,
        getReferencedColumn: (t) => t.ornamentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StatusHistoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.statusHistories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrnamentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrnamentsTable,
    Ornament,
    $$OrnamentsTableFilterComposer,
    $$OrnamentsTableOrderingComposer,
    $$OrnamentsTableAnnotationComposer,
    $$OrnamentsTableCreateCompanionBuilder,
    $$OrnamentsTableUpdateCompanionBuilder,
    (Ornament, $$OrnamentsTableReferences),
    Ornament,
    PrefetchHooks Function(
        {bool itemGroupId, bool itemTypeId, bool statusHistoriesRefs})> {
  $$OrnamentsTableTableManager(_$AppDatabase db, $OrnamentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrnamentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrnamentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrnamentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> ornamentCode = const Value.absent(),
            Value<int> itemGroupId = const Value.absent(),
            Value<int> itemTypeId = const Value.absent(),
            Value<double> weightGrams = const Value.absent(),
            Value<DateTime> entryDate = const Value.absent(),
            Value<OrnamentStatus> status = const Value.absent(),
            Value<DateTime?> statusDate = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              OrnamentsCompanion(
            id: id,
            ornamentCode: ornamentCode,
            itemGroupId: itemGroupId,
            itemTypeId: itemTypeId,
            weightGrams: weightGrams,
            entryDate: entryDate,
            status: status,
            statusDate: statusDate,
            customerName: customerName,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String ornamentCode,
            required int itemGroupId,
            required int itemTypeId,
            required double weightGrams,
            required DateTime entryDate,
            Value<OrnamentStatus> status = const Value.absent(),
            Value<DateTime?> statusDate = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              OrnamentsCompanion.insert(
            id: id,
            ornamentCode: ornamentCode,
            itemGroupId: itemGroupId,
            itemTypeId: itemTypeId,
            weightGrams: weightGrams,
            entryDate: entryDate,
            status: status,
            statusDate: statusDate,
            customerName: customerName,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrnamentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {itemGroupId = false,
              itemTypeId = false,
              statusHistoriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (statusHistoriesRefs) db.statusHistories
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (itemGroupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemGroupId,
                    referencedTable:
                        $$OrnamentsTableReferences._itemGroupIdTable(db),
                    referencedColumn:
                        $$OrnamentsTableReferences._itemGroupIdTable(db).id,
                  ) as T;
                }
                if (itemTypeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.itemTypeId,
                    referencedTable:
                        $$OrnamentsTableReferences._itemTypeIdTable(db),
                    referencedColumn:
                        $$OrnamentsTableReferences._itemTypeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (statusHistoriesRefs)
                    await $_getPrefetchedData<Ornament, $OrnamentsTable,
                            StatusHistory>(
                        currentTable: table,
                        referencedTable: $$OrnamentsTableReferences
                            ._statusHistoriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrnamentsTableReferences(db, table, p0)
                                .statusHistoriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.ornamentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OrnamentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrnamentsTable,
    Ornament,
    $$OrnamentsTableFilterComposer,
    $$OrnamentsTableOrderingComposer,
    $$OrnamentsTableAnnotationComposer,
    $$OrnamentsTableCreateCompanionBuilder,
    $$OrnamentsTableUpdateCompanionBuilder,
    (Ornament, $$OrnamentsTableReferences),
    Ornament,
    PrefetchHooks Function(
        {bool itemGroupId, bool itemTypeId, bool statusHistoriesRefs})>;
typedef $$StatusHistoriesTableCreateCompanionBuilder = StatusHistoriesCompanion
    Function({
  Value<int> id,
  required int ornamentId,
  required OrnamentStatus status,
  required DateTime date,
  Value<String?> customerName,
  Value<DateTime> recordedAt,
});
typedef $$StatusHistoriesTableUpdateCompanionBuilder = StatusHistoriesCompanion
    Function({
  Value<int> id,
  Value<int> ornamentId,
  Value<OrnamentStatus> status,
  Value<DateTime> date,
  Value<String?> customerName,
  Value<DateTime> recordedAt,
});

final class $$StatusHistoriesTableReferences extends BaseReferences<
    _$AppDatabase, $StatusHistoriesTable, StatusHistory> {
  $$StatusHistoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $OrnamentsTable _ornamentIdTable(_$AppDatabase db) =>
      db.ornaments.createAlias(
          $_aliasNameGenerator(db.statusHistories.ornamentId, db.ornaments.id));

  $$OrnamentsTableProcessedTableManager get ornamentId {
    final $_column = $_itemColumn<int>('ornament_id')!;

    final manager = $$OrnamentsTableTableManager($_db, $_db.ornaments)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ornamentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StatusHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $StatusHistoriesTable> {
  $$StatusHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<OrnamentStatus, OrnamentStatus, String>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  $$OrnamentsTableFilterComposer get ornamentId {
    final $$OrnamentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ornamentId,
        referencedTable: $db.ornaments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrnamentsTableFilterComposer(
              $db: $db,
              $table: $db.ornaments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StatusHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $StatusHistoriesTable> {
  $$StatusHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  $$OrnamentsTableOrderingComposer get ornamentId {
    final $$OrnamentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ornamentId,
        referencedTable: $db.ornaments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrnamentsTableOrderingComposer(
              $db: $db,
              $table: $db.ornaments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StatusHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StatusHistoriesTable> {
  $$StatusHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrnamentStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  $$OrnamentsTableAnnotationComposer get ornamentId {
    final $$OrnamentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.ornamentId,
        referencedTable: $db.ornaments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrnamentsTableAnnotationComposer(
              $db: $db,
              $table: $db.ornaments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StatusHistoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StatusHistoriesTable,
    StatusHistory,
    $$StatusHistoriesTableFilterComposer,
    $$StatusHistoriesTableOrderingComposer,
    $$StatusHistoriesTableAnnotationComposer,
    $$StatusHistoriesTableCreateCompanionBuilder,
    $$StatusHistoriesTableUpdateCompanionBuilder,
    (StatusHistory, $$StatusHistoriesTableReferences),
    StatusHistory,
    PrefetchHooks Function({bool ornamentId})> {
  $$StatusHistoriesTableTableManager(
      _$AppDatabase db, $StatusHistoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StatusHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StatusHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StatusHistoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> ornamentId = const Value.absent(),
            Value<OrnamentStatus> status = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
          }) =>
              StatusHistoriesCompanion(
            id: id,
            ornamentId: ornamentId,
            status: status,
            date: date,
            customerName: customerName,
            recordedAt: recordedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int ornamentId,
            required OrnamentStatus status,
            required DateTime date,
            Value<String?> customerName = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
          }) =>
              StatusHistoriesCompanion.insert(
            id: id,
            ornamentId: ornamentId,
            status: status,
            date: date,
            customerName: customerName,
            recordedAt: recordedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StatusHistoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({ornamentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (ornamentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.ornamentId,
                    referencedTable:
                        $$StatusHistoriesTableReferences._ornamentIdTable(db),
                    referencedColumn: $$StatusHistoriesTableReferences
                        ._ornamentIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StatusHistoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StatusHistoriesTable,
    StatusHistory,
    $$StatusHistoriesTableFilterComposer,
    $$StatusHistoriesTableOrderingComposer,
    $$StatusHistoriesTableAnnotationComposer,
    $$StatusHistoriesTableCreateCompanionBuilder,
    $$StatusHistoriesTableUpdateCompanionBuilder,
    (StatusHistory, $$StatusHistoriesTableReferences),
    StatusHistory,
    PrefetchHooks Function({bool ornamentId})>;
typedef $$SilverPlusBoxesTableCreateCompanionBuilder = SilverPlusBoxesCompanion
    Function({
  Value<int> id,
  required String boxCode,
  required int count,
  required double weightGrams,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$SilverPlusBoxesTableUpdateCompanionBuilder = SilverPlusBoxesCompanion
    Function({
  Value<int> id,
  Value<String> boxCode,
  Value<int> count,
  Value<double> weightGrams,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$SilverPlusBoxesTableReferences extends BaseReferences<
    _$AppDatabase, $SilverPlusBoxesTable, SilverPlusBox> {
  $$SilverPlusBoxesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SilverPlusAllocationsTable,
      List<SilverPlusAllocation>> _silverPlusAllocationsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.silverPlusAllocations,
          aliasName: $_aliasNameGenerator(
              db.silverPlusBoxes.id, db.silverPlusAllocations.boxId));

  $$SilverPlusAllocationsTableProcessedTableManager
      get silverPlusAllocationsRefs {
    final manager = $$SilverPlusAllocationsTableTableManager(
            $_db, $_db.silverPlusAllocations)
        .filter((f) => f.boxId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_silverPlusAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SilverPlusBoxesTableFilterComposer
    extends Composer<_$AppDatabase, $SilverPlusBoxesTable> {
  $$SilverPlusBoxesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get boxCode => $composableBuilder(
      column: $table.boxCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> silverPlusAllocationsRefs(
      Expression<bool> Function($$SilverPlusAllocationsTableFilterComposer f)
          f) {
    final $$SilverPlusAllocationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.silverPlusAllocations,
            getReferencedColumn: (t) => t.boxId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SilverPlusAllocationsTableFilterComposer(
                  $db: $db,
                  $table: $db.silverPlusAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$SilverPlusBoxesTableOrderingComposer
    extends Composer<_$AppDatabase, $SilverPlusBoxesTable> {
  $$SilverPlusBoxesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get boxCode => $composableBuilder(
      column: $table.boxCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SilverPlusBoxesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SilverPlusBoxesTable> {
  $$SilverPlusBoxesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get boxCode =>
      $composableBuilder(column: $table.boxCode, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> silverPlusAllocationsRefs<T extends Object>(
      Expression<T> Function($$SilverPlusAllocationsTableAnnotationComposer a)
          f) {
    final $$SilverPlusAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.silverPlusAllocations,
            getReferencedColumn: (t) => t.boxId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SilverPlusAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.silverPlusAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$SilverPlusBoxesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SilverPlusBoxesTable,
    SilverPlusBox,
    $$SilverPlusBoxesTableFilterComposer,
    $$SilverPlusBoxesTableOrderingComposer,
    $$SilverPlusBoxesTableAnnotationComposer,
    $$SilverPlusBoxesTableCreateCompanionBuilder,
    $$SilverPlusBoxesTableUpdateCompanionBuilder,
    (SilverPlusBox, $$SilverPlusBoxesTableReferences),
    SilverPlusBox,
    PrefetchHooks Function({bool silverPlusAllocationsRefs})> {
  $$SilverPlusBoxesTableTableManager(
      _$AppDatabase db, $SilverPlusBoxesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SilverPlusBoxesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SilverPlusBoxesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SilverPlusBoxesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> boxCode = const Value.absent(),
            Value<int> count = const Value.absent(),
            Value<double> weightGrams = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SilverPlusBoxesCompanion(
            id: id,
            boxCode: boxCode,
            count: count,
            weightGrams: weightGrams,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String boxCode,
            required int count,
            required double weightGrams,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SilverPlusBoxesCompanion.insert(
            id: id,
            boxCode: boxCode,
            count: count,
            weightGrams: weightGrams,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SilverPlusBoxesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({silverPlusAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (silverPlusAllocationsRefs) db.silverPlusAllocations
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (silverPlusAllocationsRefs)
                    await $_getPrefetchedData<SilverPlusBox,
                            $SilverPlusBoxesTable, SilverPlusAllocation>(
                        currentTable: table,
                        referencedTable: $$SilverPlusBoxesTableReferences
                            ._silverPlusAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SilverPlusBoxesTableReferences(db, table, p0)
                                .silverPlusAllocationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.boxId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SilverPlusBoxesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SilverPlusBoxesTable,
    SilverPlusBox,
    $$SilverPlusBoxesTableFilterComposer,
    $$SilverPlusBoxesTableOrderingComposer,
    $$SilverPlusBoxesTableAnnotationComposer,
    $$SilverPlusBoxesTableCreateCompanionBuilder,
    $$SilverPlusBoxesTableUpdateCompanionBuilder,
    (SilverPlusBox, $$SilverPlusBoxesTableReferences),
    SilverPlusBox,
    PrefetchHooks Function({bool silverPlusAllocationsRefs})>;
typedef $$SilverPlusAllocationsTableCreateCompanionBuilder
    = SilverPlusAllocationsCompanion Function({
  Value<int> id,
  required int boxId,
  required int count,
  required double weightGrams,
  required DateTime date,
  Value<AllocationStatus> status,
  Value<String?> customerName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$SilverPlusAllocationsTableUpdateCompanionBuilder
    = SilverPlusAllocationsCompanion Function({
  Value<int> id,
  Value<int> boxId,
  Value<int> count,
  Value<double> weightGrams,
  Value<DateTime> date,
  Value<AllocationStatus> status,
  Value<String?> customerName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$SilverPlusAllocationsTableReferences extends BaseReferences<
    _$AppDatabase, $SilverPlusAllocationsTable, SilverPlusAllocation> {
  $$SilverPlusAllocationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $SilverPlusBoxesTable _boxIdTable(_$AppDatabase db) =>
      db.silverPlusBoxes.createAlias($_aliasNameGenerator(
          db.silverPlusAllocations.boxId, db.silverPlusBoxes.id));

  $$SilverPlusBoxesTableProcessedTableManager get boxId {
    final $_column = $_itemColumn<int>('box_id')!;

    final manager =
        $$SilverPlusBoxesTableTableManager($_db, $_db.silverPlusBoxes)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_boxIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SilverPlusAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $SilverPlusAllocationsTable> {
  $$SilverPlusAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AllocationStatus, AllocationStatus, String>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$SilverPlusBoxesTableFilterComposer get boxId {
    final $$SilverPlusBoxesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.boxId,
        referencedTable: $db.silverPlusBoxes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SilverPlusBoxesTableFilterComposer(
              $db: $db,
              $table: $db.silverPlusBoxes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SilverPlusAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SilverPlusAllocationsTable> {
  $$SilverPlusAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$SilverPlusBoxesTableOrderingComposer get boxId {
    final $$SilverPlusBoxesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.boxId,
        referencedTable: $db.silverPlusBoxes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SilverPlusBoxesTableOrderingComposer(
              $db: $db,
              $table: $db.silverPlusBoxes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SilverPlusAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SilverPlusAllocationsTable> {
  $$SilverPlusAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AllocationStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SilverPlusBoxesTableAnnotationComposer get boxId {
    final $$SilverPlusBoxesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.boxId,
        referencedTable: $db.silverPlusBoxes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SilverPlusBoxesTableAnnotationComposer(
              $db: $db,
              $table: $db.silverPlusBoxes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SilverPlusAllocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SilverPlusAllocationsTable,
    SilverPlusAllocation,
    $$SilverPlusAllocationsTableFilterComposer,
    $$SilverPlusAllocationsTableOrderingComposer,
    $$SilverPlusAllocationsTableAnnotationComposer,
    $$SilverPlusAllocationsTableCreateCompanionBuilder,
    $$SilverPlusAllocationsTableUpdateCompanionBuilder,
    (SilverPlusAllocation, $$SilverPlusAllocationsTableReferences),
    SilverPlusAllocation,
    PrefetchHooks Function({bool boxId})> {
  $$SilverPlusAllocationsTableTableManager(
      _$AppDatabase db, $SilverPlusAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SilverPlusAllocationsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$SilverPlusAllocationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SilverPlusAllocationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> boxId = const Value.absent(),
            Value<int> count = const Value.absent(),
            Value<double> weightGrams = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<AllocationStatus> status = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SilverPlusAllocationsCompanion(
            id: id,
            boxId: boxId,
            count: count,
            weightGrams: weightGrams,
            date: date,
            status: status,
            customerName: customerName,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int boxId,
            required int count,
            required double weightGrams,
            required DateTime date,
            Value<AllocationStatus> status = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SilverPlusAllocationsCompanion.insert(
            id: id,
            boxId: boxId,
            count: count,
            weightGrams: weightGrams,
            date: date,
            status: status,
            customerName: customerName,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SilverPlusAllocationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({boxId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (boxId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.boxId,
                    referencedTable:
                        $$SilverPlusAllocationsTableReferences._boxIdTable(db),
                    referencedColumn: $$SilverPlusAllocationsTableReferences
                        ._boxIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SilverPlusAllocationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SilverPlusAllocationsTable,
        SilverPlusAllocation,
        $$SilverPlusAllocationsTableFilterComposer,
        $$SilverPlusAllocationsTableOrderingComposer,
        $$SilverPlusAllocationsTableAnnotationComposer,
        $$SilverPlusAllocationsTableCreateCompanionBuilder,
        $$SilverPlusAllocationsTableUpdateCompanionBuilder,
        (SilverPlusAllocation, $$SilverPlusAllocationsTableReferences),
        SilverPlusAllocation,
        PrefetchHooks Function({bool boxId})>;
typedef $$OldSilverEntriesTableCreateCompanionBuilder
    = OldSilverEntriesCompanion Function({
  Value<int> id,
  required double weightGrams,
  required DateTime entryDate,
  Value<String?> note,
  Value<DateTime> createdAt,
});
typedef $$OldSilverEntriesTableUpdateCompanionBuilder
    = OldSilverEntriesCompanion Function({
  Value<int> id,
  Value<double> weightGrams,
  Value<DateTime> entryDate,
  Value<String?> note,
  Value<DateTime> createdAt,
});

class $$OldSilverEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $OldSilverEntriesTable> {
  $$OldSilverEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
      column: $table.entryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$OldSilverEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OldSilverEntriesTable> {
  $$OldSilverEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
      column: $table.entryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$OldSilverEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OldSilverEntriesTable> {
  $$OldSilverEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get weightGrams => $composableBuilder(
      column: $table.weightGrams, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OldSilverEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OldSilverEntriesTable,
    OldSilverEntry,
    $$OldSilverEntriesTableFilterComposer,
    $$OldSilverEntriesTableOrderingComposer,
    $$OldSilverEntriesTableAnnotationComposer,
    $$OldSilverEntriesTableCreateCompanionBuilder,
    $$OldSilverEntriesTableUpdateCompanionBuilder,
    (
      OldSilverEntry,
      BaseReferences<_$AppDatabase, $OldSilverEntriesTable, OldSilverEntry>
    ),
    OldSilverEntry,
    PrefetchHooks Function()> {
  $$OldSilverEntriesTableTableManager(
      _$AppDatabase db, $OldSilverEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OldSilverEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OldSilverEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OldSilverEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> weightGrams = const Value.absent(),
            Value<DateTime> entryDate = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OldSilverEntriesCompanion(
            id: id,
            weightGrams: weightGrams,
            entryDate: entryDate,
            note: note,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double weightGrams,
            required DateTime entryDate,
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              OldSilverEntriesCompanion.insert(
            id: id,
            weightGrams: weightGrams,
            entryDate: entryDate,
            note: note,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OldSilverEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OldSilverEntriesTable,
    OldSilverEntry,
    $$OldSilverEntriesTableFilterComposer,
    $$OldSilverEntriesTableOrderingComposer,
    $$OldSilverEntriesTableAnnotationComposer,
    $$OldSilverEntriesTableCreateCompanionBuilder,
    $$OldSilverEntriesTableUpdateCompanionBuilder,
    (
      OldSilverEntry,
      BaseReferences<_$AppDatabase, $OldSilverEntriesTable, OldSilverEntry>
    ),
    OldSilverEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ItemGroupsTableTableManager get itemGroups =>
      $$ItemGroupsTableTableManager(_db, _db.itemGroups);
  $$ItemTypesTableTableManager get itemTypes =>
      $$ItemTypesTableTableManager(_db, _db.itemTypes);
  $$OrnamentsTableTableManager get ornaments =>
      $$OrnamentsTableTableManager(_db, _db.ornaments);
  $$StatusHistoriesTableTableManager get statusHistories =>
      $$StatusHistoriesTableTableManager(_db, _db.statusHistories);
  $$SilverPlusBoxesTableTableManager get silverPlusBoxes =>
      $$SilverPlusBoxesTableTableManager(_db, _db.silverPlusBoxes);
  $$SilverPlusAllocationsTableTableManager get silverPlusAllocations =>
      $$SilverPlusAllocationsTableTableManager(_db, _db.silverPlusAllocations);
  $$OldSilverEntriesTableTableManager get oldSilverEntries =>
      $$OldSilverEntriesTableTableManager(_db, _db.oldSilverEntries);
}
