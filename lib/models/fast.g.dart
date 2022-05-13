// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fast.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetFastCollection on Isar {
  IsarCollection<Fast> get fasts => getCollection();
}

const FastSchema = CollectionSchema(
  name: 'Fast',
  schema:
      '{"name":"Fast","idName":"id","properties":[{"name":"end","type":"Long"},{"name":"start","type":"Long"},{"name":"targetHours","type":"Long"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {'end': 0, 'start': 1, 'targetHours': 2},
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _fastGetId,
  setId: _fastSetId,
  getLinks: _fastGetLinks,
  attachLinks: _fastAttachLinks,
  serializeNative: _fastSerializeNative,
  deserializeNative: _fastDeserializeNative,
  deserializePropNative: _fastDeserializePropNative,
  serializeWeb: _fastSerializeWeb,
  deserializeWeb: _fastDeserializeWeb,
  deserializePropWeb: _fastDeserializePropWeb,
  version: 3,
);

int? _fastGetId(Fast object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _fastSetId(Fast object, int id) {
  object.id = id;
}

List<IsarLinkBase> _fastGetLinks(Fast object) {
  return [];
}

void _fastSerializeNative(IsarCollection<Fast> collection, IsarRawObject rawObj,
    Fast object, int staticSize, List<int> offsets, AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.end;
  final _end = value0;
  final value1 = object.start;
  final _start = value1;
  final value2 = object.targetHours;
  final _targetHours = value2;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeDateTime(offsets[0], _end);
  writer.writeDateTime(offsets[1], _start);
  writer.writeLong(offsets[2], _targetHours);
}

Fast _fastDeserializeNative(IsarCollection<Fast> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Fast(
    end: reader.readDateTimeOrNull(offsets[0]),
    id: id,
    start: reader.readDateTime(offsets[1]),
    targetHours: reader.readLong(offsets[2]),
  );
  return object;
}

P _fastDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _fastSerializeWeb(IsarCollection<Fast> collection, Fast object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(
      jsObj, 'end', object.end?.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(
      jsObj, 'start', object.start.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, 'targetHours', object.targetHours);
  return jsObj;
}

Fast _fastDeserializeWeb(IsarCollection<Fast> collection, dynamic jsObj) {
  final object = Fast(
    end: IsarNative.jsObjectGet(jsObj, 'end') != null
        ? DateTime.fromMillisecondsSinceEpoch(
                IsarNative.jsObjectGet(jsObj, 'end'),
                isUtc: true)
            .toLocal()
        : null,
    id: IsarNative.jsObjectGet(jsObj, 'id'),
    start: IsarNative.jsObjectGet(jsObj, 'start') != null
        ? DateTime.fromMillisecondsSinceEpoch(
                IsarNative.jsObjectGet(jsObj, 'start'),
                isUtc: true)
            .toLocal()
        : DateTime.fromMillisecondsSinceEpoch(0),
    targetHours:
        IsarNative.jsObjectGet(jsObj, 'targetHours') ?? double.negativeInfinity,
  );
  return object;
}

P _fastDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'end':
      return (IsarNative.jsObjectGet(jsObj, 'end') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'end'),
                  isUtc: true)
              .toLocal()
          : null) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id')) as P;
    case 'start':
      return (IsarNative.jsObjectGet(jsObj, 'start') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'start'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case 'targetHours':
      return (IsarNative.jsObjectGet(jsObj, 'targetHours') ??
          double.negativeInfinity) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _fastAttachLinks(IsarCollection col, int id, Fast object) {}

extension FastQueryWhereSort on QueryBuilder<Fast, Fast, QWhere> {
  QueryBuilder<Fast, Fast, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension FastQueryWhere on QueryBuilder<Fast, Fast, QWhereClause> {
  QueryBuilder<Fast, Fast, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<Fast, Fast, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Fast, Fast, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Fast, Fast, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }
}

extension FastQueryFilter on QueryBuilder<Fast, Fast, QFilterCondition> {
  QueryBuilder<Fast, Fast, QAfterFilterCondition> endIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'end',
      value: null,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> endEqualTo(DateTime? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'end',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> endGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'end',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> endLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'end',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> endBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'end',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> idIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'id',
      value: null,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> startEqualTo(DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'start',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> startGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'start',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> startLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'start',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> startBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'start',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> targetHoursEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'targetHours',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> targetHoursGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'targetHours',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> targetHoursLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'targetHours',
      value: value,
    ));
  }

  QueryBuilder<Fast, Fast, QAfterFilterCondition> targetHoursBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'targetHours',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension FastQueryLinks on QueryBuilder<Fast, Fast, QFilterCondition> {}

extension FastQueryWhereSortBy on QueryBuilder<Fast, Fast, QSortBy> {
  QueryBuilder<Fast, Fast, QAfterSortBy> sortByEnd() {
    return addSortByInternal('end', Sort.asc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> sortByEndDesc() {
    return addSortByInternal('end', Sort.desc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> sortByStart() {
    return addSortByInternal('start', Sort.asc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> sortByStartDesc() {
    return addSortByInternal('start', Sort.desc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> sortByTargetHours() {
    return addSortByInternal('targetHours', Sort.asc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> sortByTargetHoursDesc() {
    return addSortByInternal('targetHours', Sort.desc);
  }
}

extension FastQueryWhereSortThenBy on QueryBuilder<Fast, Fast, QSortThenBy> {
  QueryBuilder<Fast, Fast, QAfterSortBy> thenByEnd() {
    return addSortByInternal('end', Sort.asc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> thenByEndDesc() {
    return addSortByInternal('end', Sort.desc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> thenByStart() {
    return addSortByInternal('start', Sort.asc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> thenByStartDesc() {
    return addSortByInternal('start', Sort.desc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> thenByTargetHours() {
    return addSortByInternal('targetHours', Sort.asc);
  }

  QueryBuilder<Fast, Fast, QAfterSortBy> thenByTargetHoursDesc() {
    return addSortByInternal('targetHours', Sort.desc);
  }
}

extension FastQueryWhereDistinct on QueryBuilder<Fast, Fast, QDistinct> {
  QueryBuilder<Fast, Fast, QDistinct> distinctByEnd() {
    return addDistinctByInternal('end');
  }

  QueryBuilder<Fast, Fast, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Fast, Fast, QDistinct> distinctByStart() {
    return addDistinctByInternal('start');
  }

  QueryBuilder<Fast, Fast, QDistinct> distinctByTargetHours() {
    return addDistinctByInternal('targetHours');
  }
}

extension FastQueryProperty on QueryBuilder<Fast, Fast, QQueryProperty> {
  QueryBuilder<Fast, DateTime?, QQueryOperations> endProperty() {
    return addPropertyNameInternal('end');
  }

  QueryBuilder<Fast, int?, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Fast, DateTime, QQueryOperations> startProperty() {
    return addPropertyNameInternal('start');
  }

  QueryBuilder<Fast, int, QQueryOperations> targetHoursProperty() {
    return addPropertyNameInternal('targetHours');
  }
}
