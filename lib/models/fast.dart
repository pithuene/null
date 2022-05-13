import 'package:isar/isar.dart';
part 'fast.g.dart';

@Collection()
class Fast {
  @Id()
  int? id;
  DateTime start;
  DateTime? end;
  int targetHours;

  Fast({
    this.id,
    required this.start,
    this.end,
    required this.targetHours,
  });
}
